#!/usr/bin/env python3
"""Hard-fail specific remediated Checkov findings without masking other legacy debt.

The five-root Checkov security job remains advisory for other findings.
These checks require the exact resource/policy pair to appear in passed_checks.
"""
from __future__ import annotations

import json
from pathlib import Path
import sys

REQUIRED_PASS = {
    "03-services": {
        ("CKV_AWS_130", "aws_subnet.public"),
        ("CKV2_AWS_12", "aws_vpc.shared_services"),
    },
    "04-observability": {
        ("CKV_AWS_26", "aws_sns_topic.ops_alerts"),
    },
}


def verify(document: object, root_slug: str) -> list[str]:
    if root_slug not in REQUIRED_PASS:
        raise ValueError(f"Unknown protected root: {root_slug}")
    reports = document if isinstance(document, list) else [document]
    if not reports or not all(isinstance(r, dict) for r in reports):
        raise ValueError("Invalid or empty Checkov report")
    passed = set()
    failing = set()
    for report in reports:
        if report.get("parsing_errors"):
            raise ValueError("Incomplete Checkov report: parsing errors")
        result = report.get("results")
        if not isinstance(result, dict):
            raise ValueError("Checkov report is missing results")
        for key, target in (("passed_checks", passed), ("failed_checks", failing)):
            items = result.get(key)
            if not isinstance(items, list):
                raise ValueError(f"Checkov report is missing {key}")
            for item in items:
                if not isinstance(item, dict):
                    raise ValueError(f"Malformed {key} entry")
                target.add((str(item.get("check_id", "")), str(item.get("resource", ""))))
    errors = []
    for check_id, resource in sorted(REQUIRED_PASS[root_slug]):
        key = (check_id, resource)
        if key in failing:
            errors.append(f"{check_id} failed for {resource}")
        elif key not in passed:
            errors.append(f"{check_id} missing for {resource} (fail closed)")
    return errors


def main() -> int:
    if len(sys.argv) != 3:
        print("Usage: check_legacy_targeted_controls.py <checkov.json> <root_slug>", file=sys.stderr)
        return 2
    try:
        findings = json.loads(Path(sys.argv[1]).read_text(encoding="utf-8"))
        errors = verify(findings, sys.argv[2])
    except (OSError, ValueError) as exc:
        print(f"Security gate incomplete: {exc}", file=sys.stderr)
        return 2
    for item in errors:
        print(f"FAIL: {item}", file=sys.stderr)
    if errors:
        return 1
    print(f"PASS: all required remediated security controls for {sys.argv[2]} passed Checkov")
    return 0


if __name__ == "__main__":
    sys.exit(main())
