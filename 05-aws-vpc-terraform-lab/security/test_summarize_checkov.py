"""Checkov JSON report parser unit tests."""
import unittest

from summarize_checkov import summarize, unapproved_findings


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

    def test_documented_unattached_sg_findings_are_visible_but_accepted(self):
        report = {
            "results": {"failed_checks": [
                {"check_id": "CKV2_AWS_5", "resource": "aws_security_group.web"},
                {"check_id": "CKV2_AWS_5", "resource": "aws_security_group.app"},
            ], "passed_checks": [], "skipped_checks": []},
            "parsing_errors": [],
        }
        self.assertEqual(unapproved_findings(report), [])
        self.assertEqual(summarize(report)[1], 2)

    def test_new_policy_finding_blocks_ci(self):
        report = {
            "results": {"failed_checks": [
                {"check_id": "CKV_AWS_394", "resource": "aws_availability_zones.available"},
            ]},
            "parsing_errors": [],
        }
        self.assertTrue(any("CKV_AWS_394" in x for x in unapproved_findings(report)))

    def test_parsing_error_blocks_ci(self):
        report = {"results": {"failed_checks": []}, "parsing_errors": ["broken.tf"]}
        self.assertTrue(unapproved_findings(report))

    def test_missing_results_is_error(self):
        with self.assertRaisesRegex(ValueError, "results"):
            summarize({})


if __name__ == "__main__":
    unittest.main()
