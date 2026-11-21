#!/usr/bin/env python3
"""Checkov JSON summarizer. Reports all findings without erasing known risks."""
from __future__ import annotations

import json
import os
from pathlib import Path
import sys


def summarize(document: object) -> tuple[list[str], int]:
    reports = document if isinstance(document, list) else [document]
    if not reports or not all(isinstance(r, dict) for r in reports):
        raise ValueError("Unexpected Checkov JSON: expected an object or list of objects")
    messages: list[str] = []
    failed_total = 0
    found_results = False
    for report in reports:
        data = report.get("results")
        if not isinstance(data, dict):
            raise ValueError("Checkov report is missing its results object")
        found_results = True
        failed = data.get("failed_checks", [])
        passed = data.get("passed_checks", [])
        skipped = data.get("skipped_checks", [])
        errors = report.get("parsing_errors", [])
        if not all(isinstance(x, list) for x in (failed, passed, skipped, errors)):
            raise ValueError("Unexpected Checkov results format")
        framework = str(report.get("check_type", "terraform"))
        messages.append(f"{framework}: {len(passed)} passed, {len(failed)} failed, {len(skipped)} skipped; {len(errors)} parsing errors")
        failed_total += len(failed)
        if errors:
            messages.append(f"WARNING: {len(errors)} files failed to parse. Audit is incomplete.")
        for check in failed[:30]:
            cid = check.get("check_id", "unknown") if isinstance(check, dict) else "unknown"
            resource = check.get("resource", "unknown") if isinstance(check, dict) else "unknown"
            messages.append(f"  FINDING {cid} — {resource}")
        if len(failed) > 30:
            messages.append(f"  ... and {len(failed) - 30} additional findings in the uploaded JSON report")
    if not found_results:
        raise ValueError("Checkov results are empty")
    return messages, failed_total


# These are deliberate architecture placeholders, not remediated vulnerabilities.
# An explicitly attached workload should remove its entry from this allowlist.
DOCUMENTED_LAB_LIMITATIONS = frozenset({
    ("CKV2_AWS_5", "aws_security_group.web"),
    ("CKV2_AWS_5", "aws_security_group.app"),
})


def unapproved_findings(document: object) -> list[str]:
    """Fail closed on every new Checkov misconfiguration or parsing error."""
    reports = document if isinstance(document, list) else [document]
    blockers = []
    for report in reports:
        if report.get("parsing_errors"):
            blockers.append("Checkov failed to parse some Terraform files")
        for check in report["results"]["failed_checks"]:
            key = (str(check.get("check_id", "")), str(check.get("resource", "")))
            if key not in DOCUMENTED_LAB_LIMITATIONS:
                blockers.append(f"New/unapproved finding {key[0]} on {key[1]}")
    return blockers


def main() -> int:
    if len(sys.argv) != 2:
        print("Usage: summarize_checkov.py <checkov.json>", file=sys.stderr)
        return 2
    try:
        report = json.loads(Path(sys.argv[1]).read_text(encoding="utf-8"))
        lines, failures = summarize(report)
        blockers = unapproved_findings(report)
    except (OSError, ValueError, json.JSONDecodeError) as exc:
        print(f"Unable to interpret Checkov results: {exc}", file=sys.stderr)
        return 2
    for line in lines:
        print(line)
    print(f"Checkov: {failures} failed policy instances (including documented exceptions).")
    for blocker in blockers:
        print(f"BLOCKING: {blocker}", file=sys.stderr)
    path = os.environ.get("GITHUB_STEP_SUMMARY")
    if path:
        with open(path, "a", encoding="utf-8") as stream:
            stream.write("### Terraform Checkov misconfiguration audit (new findings gated)\n\n")
            stream.write("Scans source configuration only; no cloud resources were provisioned.\n\n")
            stream.write("\n".join("- " + line.replace("\n", " ") for line in lines))
            stream.write("\n")
    if blockers:
        return 1
    print("PASS: no Checkov findings outside two documented unattached security group exceptions")
    return 0


if __name__ == "__main__":
    sys.exit(main())
