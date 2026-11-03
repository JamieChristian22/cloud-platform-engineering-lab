"""Offline regression checks for the landing-zone repository contract.

These checks inspect source configuration; they do not prove an AWS deployment.
"""
import pathlib
import unittest

ROOT = pathlib.Path(__file__).resolve().parents[1]
TF = ROOT / "terraform" / "terraform"

class LandingZoneContract(unittest.TestCase):
    def test_only_one_terraform_root(self):
        self.assertTrue((TF / "versions.tf").is_file())
        self.assertTrue((TF / "network.tf").is_file())
        self.assertFalse((ROOT / "terraform" / "main.tf").exists())
        self.assertFalse((ROOT / "terraform" / "provider.tf").exists())

    def test_scripts_use_canonical_root(self):
        for name in ("bootstrap", "validate", "plan", "deploy", "destroy", "smoke-test"):
            with self.subTest(name=name):
                script = (ROOT / "scripts" / (name + ".sh")).read_text()
                self.assertIn("terraform/terraform", script)
                self.assertIn("set -euo pipefail", script)

    def test_no_public_ssh_rule(self):
        security = (TF / "security.tf").read_text()
        self.assertNotIn("from_port   = 22", security)
        self.assertIn("SSM", security)
        self.assertIn("from_port   = 80", security)

    def test_audit_bucket_protected_from_destroy(self):
        logging = (TF / "logging.tf").read_text()
        self.assertIn("force_destroy = false", logging)
        self.assertIn("enable_log_file_validation    = true", logging)

    def test_plan_must_be_reviewed(self):
        deploy = (ROOT / "scripts" / "deploy.sh").read_text()
        self.assertNotIn("-auto-approve", deploy)
        self.assertIn("No reviewed plan found", deploy)

    def test_nat_is_explicitly_opt_in(self):
        variables = (TF / "variables.tf").read_text()
        network = (TF / "network.tf").read_text()
        self.assertRegex(variables, r'variable "enable_nat_gateway"[\\s\\S]*?default\\s*=\\s*false')
        self.assertIn("count = var.enable_nat_gateway ? 1 : 0", network)
        self.assertIn('enable_nat_gateway = false', (TF / "terraform.tfvars.example").read_text())

    def test_audit_security_and_service_key_permissions(self):
        security = (TF / "security.tf").read_text()
        logging = (TF / "logging.tf").read_text()
        monitoring = (TF / "monitoring.tf").read_text()
        self.assertIn('resource "aws_kms_key" "logs"', security)
        self.assertIn('resource "aws_kms_key" "alerts"', security)
        self.assertIn('"cloudtrail.amazonaws.com"', security)
        self.assertIn('logs.${var.aws_region}.amazonaws.com', security)
        self.assertIn('"cloudwatch.amazonaws.com"', security)
        self.assertIn('kms_master_key_id = aws_kms_key.alerts.arn', monitoring)
        self.assertIn('DenyNonTLSConnections', logging)
        self.assertIn('"aws:SecureTransport"', logging)
        self.assertIn('"aws:SourceArn"', logging)
        self.assertIn('block_public_policy     = true', logging)
        self.assertIn('Resource = aws_cloudwatch_log_group.flow.arn', logging)
        self.assertIn('filter {}', logging)

    def test_no_legacy_ssh_or_public_access_backend(self):
        security = (TF / "security.tf").read_text()
        compute = (TF / "compute.tf").read_text()
        self.assertNotIn('from_port   = 22', security)
        self.assertNotIn('YOUR_IP_ADDRESS', security)
        self.assertIn('http_tokens   = "required"', compute)
        self.assertIn('AmazonSSMManagedInstanceCore', compute)

    def test_evidence_is_explicitly_not_live_verified(self):
        evidence = (ROOT / "evidence" / "project-completion-checklist.md").read_text()
        self.assertIn('- [ ] Infrastructure apply', evidence)
        self.assertIn('- [ ] CloudTrail', evidence)

if __name__ == "__main__":
    unittest.main()
