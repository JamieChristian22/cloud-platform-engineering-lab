# Live Deployment Checklist

Use this before marking the project complete on GitHub.

## Pre-Deployment

- Confirm cloud budget alert exists.
- Confirm resource names are unique.
- Confirm Terraform variables are updated.
- Confirm no secrets are committed.
- Confirm least privilege permissions.
- Confirm rollback plan.

## Deployment

- Run terraform fmt.
- Run terraform init.
- Run terraform validate.
- Run terraform plan.
- Review plan.
- Run terraform apply only if safe.
- Capture screenshots.

## Post-Deployment

- Confirm resources exist.
- Confirm logs are flowing.
- Confirm monitoring works.
- Confirm alert rule exists.
- Confirm encryption is enabled.
- Confirm public access settings.
- Confirm cost dashboard.
- Update README with evidence.
