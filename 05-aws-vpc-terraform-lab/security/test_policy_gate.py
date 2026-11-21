"""Offline unit tests for explicit policy guardrails."""
import unittest

from policy_gate import (
    issues_for_observability_tf,
    issues_for_security_tf,
    issues_for_workflow,
    run,
)


class SecurityPolicyTests(unittest.TestCase):
    def test_existing_repository_conforms(self):
        self.assertEqual(run(), [])

    def test_public_ssh_rule_is_blocked(self):
        fake = """resource "aws_vpc_security_group_ingress_rule" "ssh" {
          cidr_ipv4 = "0.0.0.0/0"
          from_port = 22
          to_port = 22
        }"""
        result = issues_for_security_tf(fake)
        self.assertTrue(any("entire internet" in item for item in result))
        self.assertTrue(any("SSH" in item for item in result))

    def test_opt_in_is_enforced(self):
        config = """resource "aws_flow_log" "vpc" { count = 1 }"""
        variables = """variable "enable_flow_logs" { default = true }"""
        self.assertTrue(issues_for_observability_tf(config, variables))

    def test_unpinned_action_is_blocked(self):
        fake = """permissions:
  contents: read
jobs:
  test:
    steps:
      - uses: actions/checkout@v4
"""
        issues = issues_for_workflow(fake, "ci.yml")
        self.assertTrue(any("not pinned" in item for item in issues))

    def test_deployment_command_is_blocked(self):
        fake = """permissions:
  contents: read
jobs:
  test:
    steps:
      - run: terraform apply
"""
        issues = issues_for_workflow(fake, "ci.yml")
        self.assertTrue(any("deployment commands" in item for item in issues))


if __name__ == "__main__":
    unittest.main()
