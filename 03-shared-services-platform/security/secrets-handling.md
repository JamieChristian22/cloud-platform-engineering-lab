# Secrets Handling

## Rules

- Never commit secrets to GitHub.
- Never publish real credentials in screenshots.
- Use Secrets Manager for application secrets.
- Use IAM permissions to control secret access.
- Rotate production secrets.

## Portfolio Screenshot Guidance

Never show retrieved secret values in a public screenshot, even when they are demonstration credentials. Avoid publishing account numbers, full ARNs, user names, browser bookmarks, session information, and secrets-manager version IDs. Prefer an illustrative image with explicitly redacted placeholders and an accompanying link to the actual service runbook. Blurring or masking *only* the password is not sufficient if other identifying information remains.

### Previously published evidence

A screenshot containing account/resource identifiers and a username was replaced on the current branch with a privacy-safe SVG illustration. The password appeared masked, but prior Git commits and caches may retain older content. The original is not proof of credential compromise; nevertheless, review your account and rotate any real credentials if appropriate. For full historical removal, use GitHub's official sensitive-data history-removal process and consider cached copies.

## Future Enhancement

Enable automatic secret rotation using Lambda.
