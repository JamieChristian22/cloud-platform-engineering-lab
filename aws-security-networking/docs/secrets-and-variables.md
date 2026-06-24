# CI/CD Secrets and Variables

## Required GitHub Secrets

| Secret | Purpose |
|---|---|
| AWS_ACCESS_KEY_ID | AWS automation identity |
| AWS_SECRET_ACCESS_KEY | AWS automation secret |
| AZURE_CLIENT_ID | Azure service principal ID |
| AZURE_CLIENT_SECRET | Azure service principal secret |
| AZURE_TENANT_ID | Azure tenant |
| AZURE_SUBSCRIPTION_ID | Azure subscription |
| GCP_PROJECT_ID | GCP project |
| GCP_SERVICE_ACCOUNT_KEY | GCP service account key |

## Security Rules

- Never commit secrets to GitHub.
- Use GitHub Environments for production approvals.
- Rotate secrets regularly.
- Use least privilege service accounts.
- Prefer OIDC federation over long-lived secrets where possible.
