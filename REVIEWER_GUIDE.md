# Reviewer guide and asset provenance checklist

**Project:** cloud-platform-engineering-lab · [README](README.md) · [License](LICENSE) · [CI runs](https://github.com/JamieChristian22/cloud-platform-engineering-lab/actions)

## Five-minute review

1. Read the root README for the project's purpose, evidence limitations, and what is simulated versus independently verified.
2. Open the project paths below to inspect original deliverables. These links refer to tracked default-branch paths; the guide does not certify the underlying results.
3. Review the GitHub Actions runs for recent checks and their conclusions. A queued or failed run is not a passing test.
4. Inspect inputs, calculations, and outputs before quoting performance or business-impact metrics.

### Project entry points

1. [01-enterprise-landing-zone](<01-enterprise-landing-zone>)
2. [02-multi-account-governance-platform](<02-multi-account-governance-platform>)
3. [03-shared-services-platform](<03-shared-services-platform>)
4. [04-enterprise-observability-platform](<04-enterprise-observability-platform>)

## Asset source and redistribution review

The following **sample tracked files** need a source/ownership check. Listing a file here does not mean it is third-party material or improperly licensed. Confirm the creator or provider, original URL (if external), applicable terms, permissions to share or modify, and whether real personal/customer data is present.

| Tracked asset candidate | Origin and license verification |
| --- | --- |
| `01-enterprise-landing-zone/architecture/AWS enterprise landing zone architecture diagram.png` | **Not independently verified** — check source and permissions |
| `01-enterprise-landing-zone/screenshots/01-budget-created.png` | **Not independently verified** — check source and permissions |
| `01-enterprise-landing-zone/screenshots/02-vpc-created.png` | **Not independently verified** — check source and permissions |
| `01-enterprise-landing-zone/screenshots/03-public-subnet.png` | **Not independently verified** — check source and permissions |
| `01-enterprise-landing-zone/screenshots/04-private-subnet.png` | **Not independently verified** — check source and permissions |
| `01-enterprise-landing-zone/screenshots/05-igw-attached.png` | **Not independently verified** — check source and permissions |
| `01-enterprise-landing-zone/screenshots/06-route-table.png` | **Not independently verified** — check source and permissions |
| `01-enterprise-landing-zone/screenshots/07-security-group.png` | **Not independently verified** — check source and permissions |

### Verification standard

- For first-party assets: record how they were created and whether they contain generated or synthetic data.
- For external assets: cite source, author/provider, version, license, and redistribution/commercial-use permissions.
- For modeled outcomes: label as **simulated**, **illustrative**, or **measured**, accurately and consistently.
- If ownership or rights cannot be established, do not claim the repository's MIT license grants rights to that material. Remove or replace material when necessary.
- Do not publish passwords, API credentials, private data, or sensitive screenshots while documenting evidence.

## Scope and limitations

This is a navigation and **verification checklist**, not a security certification, a pass report, or legal clearance for any asset. Automated checks do not prove third-party rights or the correctness of business outcomes. Refer to [GitHub Actions](https://github.com/JamieChristian22/cloud-platform-engineering-lab/actions) for live validation status.
