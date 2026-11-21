#!/usr/bin/env python3
"""Narrow, deterministic security regression gate for the AWS VPC Terraform lab.

This is not a replacement for a real HCL parser, Checkov, AWS Config,
or an assessment of effective deployed network policy.
"""
from __future__ import annotations

import re
import sys
from pathlib import Path

LAB = Path(__file__).resolve().parents[1]
ROOT = LAB.parent
WORKFLOWS = (
    ROOT / ".github/workflows/terraform-vpc-validation.yml",
    ROOT / ".github/workflows/terraform-vpc-security.yml",
)
MONITORING_TYPES = (
    "aws_cloudwatch_log_group",
    "aws_iam_role",
    "aws_iam_role_policy",
    "aws_flow_log",
    "aws_cloudwatch_log_metric_filter",
    "aws_cloudwatch_metric_alarm",
)


def blocks(source: str, kind: str) -> list[str]:
    """Extract top-level Terraform blocks by counting braces (no external deps)."""
    found = []
    pattern = re.compile(r'\b(?:resource|variable)\s+"(' + re.escape(kind) + r')"\s*(?:"[^"]+"\s*)?\{')
    for match in pattern.finditer(source):
        start = match.end()
        depth = 1
        index = start
        in_string = False
        escape = False
        while index < len(source) and depth > 0:
            char = source[index]
            if in_string:
                if escape:
                    escape = False
                elif char == "\\":
                    escape = True
                elif char == '"':
                    in_string = False
            else:
                if char == '"':
                    in_string = True
                elif char == "{":
                    depth += 1
                elif char == "}":
                    depth -= 1
            index += 1
        if depth:
            raise ValueError("Unclosed HCL block: " + kind)
        found.append(source[start:index - 1])
    return found


def issues_for_security_tf(content: str) -> list[str]:
    issues = []
    defaults = blocks(content, "aws_default_security_group")
    if len(defaults) != 1:
        issues.append("security.tf: expected one managed locked-down default security group")
    elif re.search(r"\b(?:ingress|egress)\s*\{", defaults[0]):
        issues.append("security.tf: default security group must have no ingress or egress blocks")
    ingress = blocks(content, "aws_vpc_security_group_ingress_rule")
    if not ingress:
        issues.append("security.tf: expected security group ingress rules are missing")
    for i, body in enumerate(ingress, 1):
        if re.search(r'\bcidr_ipv[46]\s*=\s*"(?:(?:0\.0\.0\.0/0)|(?:::)/0)"', body):
            issues.append(f"security.tf: ingress rule {i} allows the entire internet")
        if re.search(r'\b(?:from_port|to_port)\s*=\s*22\b', body):
            issues.append(f"security.tf: ingress rule {i} opens SSH port 22")
    for body in blocks(content, "aws_vpc_security_group_egress_rule"):
        if re.search(r'\bcidr_ipv4\s*=\s*"0\.0\.0\.0/0"', body):
            issues.append("security.tf: broad IPv4 security group egress")
    return issues


def issues_for_observability_tf(content: str, variables: str) -> list[str]:
    issues = []
    enable = blocks(variables, "enable_flow_logs")
    if len(enable) != 1 or not re.search(r'\bdefault\s*=\s*false\b', enable[0]):
        issues.append("variables.tf: enable_flow_logs must default to false")
    for resource_type in MONITORING_TYPES:
        matches = blocks(content, resource_type)
        if len(matches) != 1:
            issues.append(f"observability.tf: expected one {resource_type} declaration")
            continue
        if not re.search(r'\bcount\s*=\s*var\.enable_flow_logs\s*\?\s*1\s*:\s*0\b', matches[0]):
            issues.append(f"observability.tf: {resource_type} must be opt-in gated")
    return issues


def issues_for_workflow(content: str, filename: str) -> list[str]:
    issues = []
    if not re.search(r'^permissions:\s*\n\s+contents:\s*read\s*$', content, re.M):
        issues.append(f"{filename}: must use read-only contents permission")
    if "pull_request_target:" in content:
        issues.append(f"{filename}: pull_request_target is not allowed")
    if re.search(r'\bterraform\s+(?:apply|destroy)\b', content):
        issues.append(f"{filename}: deployment commands are forbidden in validation workflows")
    for action in re.findall(r'^\s*-?\s*uses:\s*([^\s#]+)', content, re.M):
        if not re.fullmatch(r'[^\s@]+@[a-f0-9]{40}', action):
            issues.append(f"{filename}: action is not pinned to a full SHA: {action}")
    return issues


def run() -> list[str]:
    issues = []
    issues.extend(issues_for_security_tf((LAB / "security.tf").read_text()))
    issues.extend(issues_for_observability_tf(
        (LAB / "observability.tf").read_text(),
        (LAB / "variables.tf").read_text(),
    ))
    for wf in WORKFLOWS:
        issues.extend(issues_for_workflow(wf.read_text(), wf.name))
    return issues


if __name__ == "__main__":
    try:
        findings = run()
    except (OSError, ValueError) as exc:
        print(f"Security policy gate could not complete: {exc}", file=sys.stderr)
        sys.exit(2)
    if findings:
        for finding in findings:
            print("FAIL:", finding, file=sys.stderr)
        sys.exit(1)
    print("PASS: scoped IaC security regression guardrails (not live AWS verification)")
