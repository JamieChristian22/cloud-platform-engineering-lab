#!/usr/bin/env python3
"""Audit exactly five legacy Terraform roots without AWS credentials or API calls."""
from __future__ import annotations

import json
from pathlib import Path
import re
import sys

REPOSITORY = Path(__file__).resolve().parents[1]
ROOTS = (
    ("01 basic landing zone", "01-enterprise-landing-zone/terraform"),
    ("01 advanced landing zone", "01-enterprise-landing-zone/terraform/terraform"),
    ("02 multi-account governance", "02-multi-account-governance-platform/terraform"),
    ("03 shared services", "03-shared-services-platform/terraform"),
    ("04 observability", "04-enterprise-observability-platform/terraform"),
)
SENSITIVE_RESOURCES = {
    "aws_nat_gateway": "Recurring NAT gateway charges if provisioned",
    "aws_eip": "Public IPv4 charges may apply",
    "aws_instance": "EC2 compute charges if provisioned",
    "aws_cloudtrail": "Audit trails may incur charges",
    "aws_cloudwatch_log_group": "Log ingestion and retention may incur charges",
    "aws_budgets_budget": "A budget alert does not cap spend",
    "aws_kms_key": "KMS key storage and usage charges if provisioned",
    "aws_organizations_organizational_unit": "Organizational changes require privileged access",
    "aws_sns_topic": "Messaging charges can apply",
}
RESOURCE_RE = re.compile(r'^\s*resource\s+"([a-z0-9_]+)"\s+"[^"]+"\s*\{', re.M)


def source_files(root: Path) -> list[Path]:
    """Only Terraform files directly in this root, never recursively."""
    return sorted(path for path in root.glob("*.tf") if path.is_file())


def inspect(root: Path) -> dict:
    sources = source_files(root)
    issues = []
    if not sources:
        issues.append("No root-level *.tf files")
    resources: dict[str, int] = {}
    for path in sources:
        text = path.read_text(encoding="utf-8")
        for item in RESOURCE_RE.findall(text):
            resources[item] = resources.get(item, 0) + 1
        if "YOUR_IP_ADDRESS/32" in text:
            issues.append(f"Invalid SSH CIDR placeholder: {path.name}")
        # Inspect each simple legacy ingress block independently. A public HTTP
        # rule and a separately restricted SSH rule are not public SSH.
        for ingress in re.findall(r'(?ms)^\s*ingress\s*\{([^{}]*)\}', text):
            public = re.search(r'\bcidr_blocks\s*=\s*\["0\.0\.0\.0/0"\]', ingress)
            ssh = re.search(r'\b(?:from_port|to_port)\s*=\s*22\b', ingress)
            if public and ssh:
                issues.append(f"Internet-wide SSH ingress in {path.name}")
    return {
        "terraform_files": len(sources),
        "resources": resources,
        "risk_signals": [
            {"resource": key, "count": count, "note": SENSITIVE_RESOURCES[key]}
            for key, count in sorted(resources.items())
            if key in SENSITIVE_RESOURCES
        ],
        "issues": issues,
    }


def inventory() -> tuple[dict, list[str]]:
    results: dict[str, dict] = {}
    problems: list[str] = []
    for label, relative in ROOTS:
        findings = inspect(REPOSITORY / relative)
        results[relative] = findings
        problems.extend(f"{label}: {problem}" for problem in findings["issues"])
    return results, problems


if __name__ == "__main__":
    try:
        rows, issues = inventory()
    except OSError as exc:
        print(f"Cannot read Terraform sources: {exc}", file=sys.stderr)
        sys.exit(2)
    print(json.dumps({"roots": rows, "scope": "source-only, no AWS access"}, indent=2, sort_keys=True))
    if issues:
        for issue in issues:
            print(f"FAIL: {issue}", file=sys.stderr)
        sys.exit(1)
    print("PASS: five isolated Terraform roots inventoried; invalid SSH placeholder not found")
