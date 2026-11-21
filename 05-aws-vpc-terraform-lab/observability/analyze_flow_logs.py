#!/usr/bin/env python3
"""Offline analysis of synthetic VPC Flow Logs version 2 (14 default fields).

Uses the Python standard library only. No AWS credentials, network calls,
or cloud resources are required.
"""
from __future__ import annotations

import argparse
from collections import Counter
import ipaddress
import json
from pathlib import Path


FIELDS = (
    "version", "account_id", "interface_id", "srcaddr", "dstaddr",
    "srcport", "dstport", "protocol", "packets", "bytes",
    "start", "end", "action", "log_status",
)


def summarize(lines: list[str]) -> dict:
    """Return deterministic counts and investigation leads for version-2 records."""
    actions = Counter()
    rejected_sources = Counter()
    rejected_ports = Counter()
    statuses = Counter()
    total_packets = 0
    total_bytes = 0
    processed = 0

    for line_no, raw in enumerate(lines, 1):
        line = raw.strip()
        if not line or line.startswith("#"):
            continue

        values = line.split()
        if len(values) != len(FIELDS):
            raise ValueError(
                f"Line {line_no}: expected {len(FIELDS)} fields, got {len(values)}"
            )
        row = dict(zip(FIELDS, values))
        if row["version"] != "2":
            raise ValueError(f"Line {line_no}: only version 2 is supported")

        statuses[row["log_status"]] += 1
        if row["log_status"] != "OK":
            # AWS may emit '-' placeholders on NODATA or SKIPDATA rows.
            continue

        if row["action"] not in {"ACCEPT", "REJECT"}:
            raise ValueError(f"Line {line_no}: unexpected action {row['action']}")
        try:
            ipaddress.ip_address(row["srcaddr"])
            ipaddress.ip_address(row["dstaddr"])
            source_port = int(row["srcport"])
            dest_port = int(row["dstport"])
            packets = int(row["packets"])
            size_bytes = int(row["bytes"])
            start = int(row["start"])
            end = int(row["end"])
            protocol = int(row["protocol"])
        except ValueError as exc:
            raise ValueError(f"Line {line_no}: invalid IP address or number") from exc

        if not (0 <= source_port <= 65535 and 0 <= dest_port <= 65535):
            raise ValueError(f"Line {line_no}: invalid port range")
        if packets < 0 or size_bytes < 0 or start > end or protocol < 0:
            raise ValueError(f"Line {line_no}: invalid traffic metrics")

        processed += 1
        actions[row["action"]] += 1
        total_packets += packets
        total_bytes += size_bytes
        if row["action"] == "REJECT":
            rejected_sources[row["srcaddr"]] += 1
            rejected_ports[str(dest_port)] += 1

    return {
        "processed_records": processed,
        "accepted_records": actions["ACCEPT"],
        "rejected_records": actions["REJECT"],
        "non_ok_records": sum(n for state, n in statuses.items() if state != "OK"),
        "log_statuses": dict(sorted(statuses.items())),
        "total_packets": total_packets,
        "total_bytes": total_bytes,
        "rejected_sources": dict(sorted(rejected_sources.items())),
        "rejected_destination_ports": dict(sorted(rejected_ports.items(), key=lambda p: int(p[0]))),
    }


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("logfile", type=Path, help="Path to default-format VPC Flow Logs")
    args = parser.parse_args()
    try:
        data = summarize(args.logfile.read_text(encoding="utf-8").splitlines())
    except (OSError, ValueError) as exc:
        parser.exit(2, f"Error: {exc}\n")
    print(json.dumps(data, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
