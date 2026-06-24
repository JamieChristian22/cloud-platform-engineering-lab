# Capacity Planning Model

## Metrics to Track

- CPU utilization
- Memory utilization
- Request count
- Error rate
- Latency
- Storage growth
- Network throughput
- Cloud spend

## Forecasting Method

1. Capture baseline usage.
2. Identify peak traffic.
3. Estimate monthly growth.
4. Define scaling threshold.
5. Set budget alert.
6. Review every month.

## Scaling Rules

| Metric | Warning | Action |
|---|---|---|
| CPU | >70% sustained | Scale out |
| Memory | >75% sustained | Increase memory or scale |
| Latency | p95 >300ms | Investigate bottleneck |
| Error Rate | >1% | Open incident |
| Storage | >80% capacity | Expand or lifecycle data |
