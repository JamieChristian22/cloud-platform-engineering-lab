"""Offline secret-pattern and screenshot-name check for the public portfolio.

Detects common plaintext credentials in tracked *text files* and filenames that
suggest public screenshots of secret values. It does not inspect PNG/JPG pixels,
Git history, cloud accounts, or verify that no sensitive material exists.
"""
from __future__ import annotations
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
TEXT_EXTENSIONS = {".py", ".tf", ".tfvars", ".yaml", ".yml", ".json", ".md",
                   ".txt", ".sh", ".toml", ".xml", ".ini", ".conf",
                   ".html", ".js", ".ts", ".sql", ".properties"}
IMAGE_EXTENSIONS = {".png", ".jpg", ".jpeg", ".webp", ".gif"}
PATTERNS = {
    "AWS access key identifier": re.compile(r"(?<![A-Z0-9])(?:AKIA|ASIA)[A-Z0-9]{16}(?![A-Z0-9])"),
    "GitHub access token": re.compile(r"(?<![A-Za-z0-9_])(?:ghp_|gho_|ghu_|ghs_|ghr_)[A-Za-z0-9_]{32,}"),
    "GitHub fine-grained token": re.compile(r"github_pat_[A-Za-z0-9_]{35,}"),
    "Private key block": re.compile(r"-----BEGIN (?:RSA |EC |OPENSSH |DSA )?PRIVATE KEY-----"),
    "Slack token": re.compile(r"(?<![A-Za-z0-9])xox[baprs]-[A-Za-z0-9-]{20,}"),
}
RISKY_SCREENSHOT = re.compile(r"(?:secret[-_]value|password[-_]value|"
                              r"token[-_]value|api[-_]key[-_]value|"
                              r"plaintext[-_]secret)", re.I)

def tracked_paths():
    result = subprocess.run(["git", "-C", str(ROOT), "ls-files", "-z"],
                            capture_output=True, check=True)
    return [ROOT / p.decode("utf-8", errors="replace")
            for p in result.stdout.split(b"\0") if p]

issues = []
files_scanned = 0
images_seen = 0
for path in tracked_paths():
    rel = path.relative_to(ROOT).as_posix()
    if path.suffix.lower() in IMAGE_EXTENSIONS:
        images_seen += 1
        if RISKY_SCREENSHOT.search(path.stem):
            issues.append(f"Screenshot filename suggests secret values: {rel}")
        continue
    if not path.is_file() or path.suffix.lower() not in TEXT_EXTENSIONS:
        continue
    files_scanned += 1
    try:
        content = path.read_text(encoding="utf-8")
    except UnicodeError:
        issues.append(f"Unexpected non-UTF8 text: {rel}")
        continue
    for label, pattern in PATTERNS.items():
        for match in pattern.finditer(content):
            line = content.count("\n", 0, match.start()) + 1
            issues.append(f"{rel}:{line}: possible {label}")
    # Do not print matching content: CI logs should not repeat possible secrets.

print(f"Text files scanned: {files_scanned}; image filenames inspected: {images_seen}")
if issues:
    for issue in issues:
        print("REVIEW:", issue, file=sys.stderr)
    raise SystemExit(1)
print("PASS: no matches for configured secret signatures or risky screenshot names")
print("LIMIT: regex checks cannot audit image pixels, full Git history, or live cloud accounts")
