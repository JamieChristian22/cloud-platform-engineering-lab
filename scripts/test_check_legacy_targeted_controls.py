"""Offline verification for targeted Checkov remediation gating."""
import unittest

from check_legacy_targeted_controls import verify


def report(passed=(), failed=(), errors=()):
    return {
        "check_type": "terraform",
        "results": {
            "passed_checks": [{"check_id": cid, "resource": res} for cid, res in passed],
            "failed_checks": [{"check_id": cid, "resource": res} for cid, res in failed],
        },
        "parsing_errors": list(errors),
    }


class TargetedSecurityGateTests(unittest.TestCase):
    def test_shared_services_requires_both_checks(self):
        result = report(passed=[
            ("CKV_AWS_130", "aws_subnet.public"),
            ("CKV2_AWS_12", "aws_vpc.shared_services"),
        ])
        self.assertEqual(verify(result, "03-services"), [])

    def test_missing_control_is_not_silently_accepted(self):
        result = report(passed=[("CKV_AWS_130", "aws_subnet.public")])
        self.assertTrue(any("CKV2_AWS_12" in issue for issue in verify(result, "03-services")))

    def test_wrong_resource_does_not_satisfy_control(self):
        result = report(passed=[("CKV_AWS_26", "aws_sns_topic.other")])
        self.assertTrue(verify(result, "04-observability"))

    def test_failed_control_blocks(self):
        result = report(failed=[("CKV_AWS_26", "aws_sns_topic.ops_alerts")])
        self.assertTrue(any("failed" in issue for issue in verify(result, "04-observability")))

    def test_encrypted_sns_passes(self):
        result = report(passed=[("CKV_AWS_26", "aws_sns_topic.ops_alerts")])
        self.assertEqual(verify(result, "04-observability"), [])

    def test_parser_failure_is_blocking(self):
        with self.assertRaisesRegex(ValueError, "parsing errors"):
            verify(report(errors=["main.tf"]), "04-observability")

    def test_unknown_root_fails_closed(self):
        with self.assertRaisesRegex(ValueError, "Unknown protected root"):
            verify(report(), "01-basic")


if __name__ == "__main__":
    unittest.main()
