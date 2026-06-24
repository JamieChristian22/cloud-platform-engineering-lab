# GitOps Workflow

## Purpose

Git is the source of truth for infrastructure and application configuration.

## Flow

```text
Git commit -> Pull request -> Policy checks -> Merge -> GitOps controller sync -> Cluster state updated
```

## Controls

- Pull request review
- Branch protection
- Automated validation
- Manifest review
- Rollback by reverting commit
- Environment-specific overlays

## Folder Pattern

```text
gitops/
├── base
│   └── deployment.yaml
└── overlays
    ├── dev
    ├── staging
    └── production
```
