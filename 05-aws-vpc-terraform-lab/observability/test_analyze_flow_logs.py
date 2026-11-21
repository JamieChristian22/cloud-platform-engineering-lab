"""Unit tests for the offline VPC Flow Logs analyzer."""
import unittest
from pathlib import Path

from analyze_flow_logs import summarize


FIXTURE = Path(__file__).with_name("sample-flow-logs.log")


class FlowLogTests(unittest.TestCase):
    def test_synthetic_fixture_counts(self):
        result = summarize(FIXTURE.read_text(encoding="utf-8").splitlines())
        self.assertEqual(result["processed_records"], 7)
        self.assertEqual(result["accepted_records"], 4)
        self.assertEqual(result["rejected_records"], 3)
        self.assertEqual(result["non_ok_records"], 1)
        self.assertEqual(result["rejected_sources"]["198.51.100.18"], 2)
        self.assertEqual(result["rejected_destination_ports"]["22"], 1)
        self.assertEqual(result["rejected_destination_ports"]["443"], 2)

    def test_empty_and_comments(self):
        result = summarize(["# comment", "", "  "])
        self.assertEqual(result["processed_records"], 0)
        self.assertEqual(result["rejected_records"], 0)

    def test_malformed_field_count(self):
        with self.assertRaisesRegex(ValueError, "expected 14 fields"):
            summarize(["2 000000000000 eni-sim-public"])

    def test_unsupported_version(self):
        with self.assertRaisesRegex(ValueError, "only version 2"):
            summarize(["3 000000000000 eni-sim 10.20.1.1 10.20.1.2 1111 443 6 1 100 1 2 ACCEPT OK"])

    def test_invalid_ip(self):
        with self.assertRaisesRegex(ValueError, "invalid IP address or number"):
            summarize(["2 000000000000 eni-sim not-an-ip 10.20.1.2 1111 443 6 1 100 1 2 ACCEPT OK"])


if __name__ == "__main__":
    unittest.main()
