# SLI/SLO and Error Budget

## Service Level Indicators

| SLI | Definition | Target |
|---|---|---|
| Availability | Successful requests / total requests | 99.9% |
| Latency | Percentage of requests under threshold | 95% under 300ms |
| Error Rate | 5xx errors / total requests | Less than 1% |
| Deployment Success | Successful deployments / total deployments | 95% |
| Recovery Time | Time to restore service | Under 60 minutes |

## Service Level Objectives

- Monthly availability target: 99.9%
- Error budget: 43.2 minutes of downtime per month
- Incident acknowledgement: under 15 minutes
- Critical incident recovery target: under 60 minutes

## Error Budget Policy

If error budget burn exceeds 50%, pause non-critical production releases and focus on reliability improvements.

If error budget burn exceeds 80%, require engineering review before new deployments.

If error budget is exhausted, freeze feature releases until reliability is restored.
