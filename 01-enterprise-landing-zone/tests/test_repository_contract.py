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

if __name__ == "__main__":
    unittest.main()
