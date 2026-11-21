#!/usr/bin/env python3
"""Summarize a scoped Checkov JSON audit without hiding existing security debt.

This legacy assessment is advisory on misconfiguration findings and
blocking on missing/unparseable scanner results. No AWS access is used.
"""
from __future__ import annotations

import json
import os
from pathlib import Path
import sys


def summarize(document: object) -> tuple[list[str], int]:
    reports = document if isinstance(document, list) else [document]
    if not reports or not all(isinstance(r, dict) for r in reports):
        raise ValueError("Expected a nonempty Checkov object or list")
    results = []
    failed_count = 0
    for report in reports:
        section = report.get("results")
        if not isinstance(section, dict):
            raise ValueError("Missing Checkov results object")
        passed = section.get("passed_checks")
        failed = section.get("failed_checks")
        skipped = section.get("skipped_checks", [])
        parsing_errors = report.get("parsing_errors", [])
        if not all(isinstance(a, list) for a in [passed, failed, skipped, parsing_errors]):
            raise ValueError("Missing or invalid Checkov result lists")
        if parsing_errors:
            raise ValueError(f"Checkov parsing errors: {parsing_errors}")
        failed_count += len(failed)
        results.append(
            f"{report.get('check_type', 'terraform')}: {len(passed)} passed, "
            f"{len(failed)} findings, {len(skipped)} skipped, no parse errors"
        )
        for check in failed[:40]:
            if not isinstance(check, dict):
                raise ValueError("Malformed individual Checkov finding")
            results.append(f"  {check.get('check_id', 'UNKNOWN')}: {check.get('resource', 'UNKNOWN')}")
        if len(failed) > 40:
            results.append(f"  ... {len(failed) - 40} more findings in JSON artifact")
    return results, failed_count


def main() -> int:
    if len(sys.argv) != 3:
        print("Usage: summarize_legacy_checkov.py <checkov.json> <root_slug>", file=sys.stderr)
        return 2
    try:
        document = json.loads(Path(sys.argv[1]).read_text(encoding="utf-8"))
        lines, n = summarize(document)
    except (OSError, ValueError) as exc:
        print(f"Checkov audit incomplete: {exc}", file=sys.stderr)
        return 2
    print(f"Legacy root: {sys.argv[2]}")
    print("\n".join(lines))
    print(f"ADVISORY: {n} unremediated IaC findings. This is not deployment approval.")
    summary_path = os.environ.get("GITHUB_STEP_SUMMARY")
    if summary_path:
        with open(summary_path, "a", encoding="utf-8") as stream:
            stream.write(f"### Legacy Terraform root: {sys.argv[2]}\n\n")
            stream.write(f"Advisory Checkov findings: {n}; **not a security clearance**.\n\n")
            stream.write("\n".join("- " + line for line in lines) + "\n")
    return 0


if __name__ == "__main__":
    sys.exit(main())
