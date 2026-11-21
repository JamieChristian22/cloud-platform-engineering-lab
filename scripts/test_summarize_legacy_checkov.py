"""Tests for the advisory-but-parse-strict legacy Checkov summary."""
import unittest

from summarize_legacy_checkov import summarize


class LegacyCheckovSummaryTests(unittest.TestCase):
    def test_failing_findings_are_reported_not_hidden(self):
        report = {
            "check_type": "terraform",
            "results": {
                "passed_checks": [{"check_id": "GOOD"}],
                "failed_checks": [{"check_id": "CKV_TEST_1", "resource": "aws_s3_bucket.audit"}],
                "skipped_checks": [],
            },
            "parsing_errors": [],
        }
        lines, n = summarize(report)
        self.assertEqual(n, 1)
        self.assertTrue(any("CKV_TEST_1" in line for line in lines))

    def test_parsing_errors_fail_the_audit(self):
        with self.assertRaisesRegex(ValueError, "parsing errors"):
            summarize({
                "results": {"passed_checks": [], "failed_checks": []},
                "parsing_errors": ["broken.tf"],
            })

    def test_missing_results_fails(self):
        with self.assertRaisesRegex(ValueError, "Missing Checkov results"):
            summarize({"check_type": "terraform"})

    def test_array_form_supported(self):
        report = {"results": {"passed_checks": [], "failed_checks": []}, "parsing_errors": []}
        self.assertEqual(summarize([report])[1], 0)


if __name__ == "__main__":
    unittest.main()
