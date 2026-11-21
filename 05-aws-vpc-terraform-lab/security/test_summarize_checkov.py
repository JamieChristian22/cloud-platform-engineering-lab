"""Checkov JSON report parser unit tests."""
import unittest

from summarize_checkov import summarize


class CheckovSummarizerTests(unittest.TestCase):
    def test_summary_and_report_findings(self):
        sample = {
            "check_type": "terraform",
            "results": {
                "passed_checks": [{"check_id": "GOOD"}],
                "failed_checks": [{"check_id": "CKV_AWS_158", "resource": "aws_cloudwatch_log_group.vpc"}],
                "skipped_checks": [],
            },
            "parsing_errors": [],
        }
        lines, fails = summarize(sample)
        self.assertEqual(fails, 1)
        self.assertTrue(any("CKV_AWS_158" in line for line in lines))

    def test_missing_results_is_error(self):
        with self.assertRaisesRegex(ValueError, "results"):
            summarize({})


if __name__ == "__main__":
    unittest.main()
