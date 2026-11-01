# Public-cloud screenshot and credential review

## What changed

The evidence image previously named \`03-shared-services-platform/screenshots/17-secret-value.png\` was withdrawn from the current public branch. Inspection found a **masked password**, but the screenshot exposed AWS account/resource identifiers and a username. The replacement at [17-secret-value-redacted.svg](03-shared-services-platform/screenshots/17-secret-value-redacted.svg) is a deliberately **illustrative** image, not an original console capture.

The adjacent screenshot \`16-secret-created.png\` was inspected. It displays a secret's name and its creation confirmation, but not a plaintext password or an account number in the visible console content. It remains in the repository as supporting evidence, subject to the general screenshot review guidance.

## Risk and limitations

- A masked password is not a plaintext credential leak. Account numbers, ARNs, and usernames are identifiers, not passwords, but publishing them unnecessarily increases exposure.
- Removing the file from \`main\` **does not remove it from Git history**, forks, caches, or archives. Any active credentials that were visible in previously shared material should be rotated and exposure investigated.
- The new CI check [check_public_artifacts.py](tools/check_public_artifacts.py) scans tracked source files for *some known token patterns* and flags risky screenshot filenames. It **does not inspect image pixels**, validate access to cloud resources, examine historical commits or guarantee freedom from secrets.
- Before uploading any screenshot: hide account IDs, emails, ARNs, user names, instance/IP identifiers, browser bookmarks, MFA/login details, retrieved secret values, and session tokens.
- Prefer screenshots captured from a dedicated demo environment with test-only data. If a screenshot isn't essential to substantiate the project, show an explanatory architecture diagram instead.
- To remove files from past Git commits as well, follow GitHub's official sensitive-data removal process and coordinate with anyone who may have fetched the repository. This process is separate from ordinary file deletion and may disrupt clones/branches.

## Verification

Run locally:

\`\`\`bash
python tools/check_public_artifacts.py
\`\`\`

Review [the workflow](.github/workflows/security-hygiene.yml). A passing result is only a minimum hygiene check; manual reviews of visuals and native cloud artifacts remain necessary.
