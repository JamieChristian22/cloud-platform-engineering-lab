"""Run fail-closed deployment-script tests without AWS credentials or Terraform."""
from __future__ import annotations

import os
import pathlib
import shutil
import subprocess
import tempfile
import unittest

SOURCE = pathlib.Path(__file__).resolve().parents[1] / "scripts"


class ScriptSafetyTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = pathlib.Path(self.temp.name)
        self.scripts = self.root / "scripts"
        self.scripts.mkdir()
        for script in ("plan.sh", "deploy.sh", "destroy.sh"):
            shutil.copyfile(SOURCE / script, self.scripts / script.name)
        self.tf = self.root / "terraform" / "terraform"
        self.tf.mkdir(parents=True)
        self.bin = self.root / "bin"
        self.bin.mkdir()
        self.calls = self.root / "terraform_calls.log"
        fake = self.bin / "terraform"
        fake.write_text(
            "#!/bin/sh\n"
            "printf '%s\\n' \"$*\" >> \"$MOCK_TERRAFORM_LOG\"\n"
            "exit 0\n"
        )
        fake.chmod(0o755)
        self.env = os.environ.copy()
        self.env["PATH"] = str(self.bin) + os.pathsep + self.env.get("PATH", "")
        self.env["MOCK_TERRAFORM_LOG"] = str(self.calls)

    def run_script(self, name, **env):
        return subprocess.run(
            ["bash", str(self.scripts / name)],
            env={**self.env, **env},
            cwd=self.root,
            capture_output=True,
            text=True,
            timeout=6,
            check=False,
        )

    def test_plan_rejects_missing_tfvars(self):
        result = self.run_script("plan.sh")
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("Copy terraform/terraform/", result.stderr)
        self.assertFalse(self.calls.exists())

    def test_plan_rejects_path_traversal(self):
        (self.tf / "terraform.tfvars").write_text("")
        result = self.run_script("plan.sh", TFVARS_FILE="../sensitive.tfvars")
        self.assertNotEqual(result.returncode, 0)
        self.assertFalse(self.calls.exists())

    def test_deploy_requires_explicit_saved_plan(self):
        result = self.run_script("deploy.sh")
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("No reviewed plan found", result.stderr)
        self.assertFalse(self.calls.exists())

    def test_deploy_does_not_auto_approve(self):
        (self.tf / "tfplan").write_text("fake-plan")
        result = self.run_script("deploy.sh")
        self.assertEqual(result.returncode, 0, result.stderr)
        calls = self.calls.read_text()
        self.assertIn("apply -input=false tfplan", calls)
        self.assertNotIn("-auto-approve", calls)

    def test_destroy_rejects_unsafe_tfvars_filename(self):
        (self.tf / "terraform.tfvars").write_text("")
        result = self.run_script("destroy.sh", TFVARS_FILE="../../x")
        self.assertNotEqual(result.returncode, 0)
        self.assertFalse(self.calls.exists())


if __name__ == "__main__":
    unittest.main()
