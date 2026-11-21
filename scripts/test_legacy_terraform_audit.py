"""Unit tests for the offline five-root Terraform source inventory."""
import tempfile
import unittest
from pathlib import Path
from legacy_terraform_audit import ROOTS, inspect, inventory, source_files


class LegacyTerraformAuditTests(unittest.TestCase):
    def test_exactly_five_distinct_roots(self):
        paths = [path for _, path in ROOTS]
        self.assertEqual(len(paths), 5)
        self.assertEqual(len(set(paths)), 5)
        self.assertIn("01-enterprise-landing-zone/terraform/terraform", paths)

    def test_discovery_never_descends_into_nested_root(self):
        with tempfile.TemporaryDirectory() as d:
            root = Path(d)
            (root / "main.tf").write_text('resource "aws_vpc" "example" {}')
            inner = root / "terraform"
            inner.mkdir()
            (inner / "network.tf").write_text('resource "aws_nat_gateway" "x" {}')
            self.assertEqual([p.name for p in source_files(root)], ["main.tf"])
            summary = inspect(root)
            self.assertEqual(summary["terraform_files"], 1)
            self.assertNotIn("aws_nat_gateway", summary["resources"])

    def test_invalid_ssh_cidr_placeholder_is_rejected(self):
        with tempfile.TemporaryDirectory() as d:
            (Path(d) / "main.tf").write_text('cidr_blocks = ["YOUR_IP_ADDRESS/32"]')
            self.assertTrue(any("Invalid SSH CIDR placeholder" in x for x in inspect(Path(d))["issues"]))

    def test_cost_signals_are_reported_not_deleted(self):
        with tempfile.TemporaryDirectory() as d:
            (Path(d) / "main.tf").write_text('resource "aws_nat_gateway" "main" {}')
            report = inspect(Path(d))
            self.assertEqual(report["resources"]["aws_nat_gateway"], 1)
            self.assertTrue(report["risk_signals"])
            self.assertFalse(report["issues"])

    def test_repository_root_discovery(self):
        _, problems = inventory()
        self.assertEqual(problems, [])


if __name__ == "__main__":
    unittest.main()
