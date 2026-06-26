# CloudWatch Logs Insights Queries

## Purpose

CloudWatch Logs Insights allows platform engineers to query logs during operational investigations.

## Query 1: Recent Events

```sql
fields @timestamp, @message
| sort @timestamp desc
| limit 25
```

## Query 2: Error Search

```sql
fields @timestamp, @message
| filter @message like /ERROR/
| sort @timestamp desc
| limit 20
```

## Query 3: Unauthorized Activity

```sql
fields @timestamp, @message
| filter @message like /Unauthorized|AccessDenied|Denied/
| sort @timestamp desc
| limit 20
```

## Screenshot

Save query evidence as:

`05-log-insights-query.png`

## Note

If the log group has no events, a query returning no results is acceptable for a lab. It still demonstrates query setup and log analytics workflow.
