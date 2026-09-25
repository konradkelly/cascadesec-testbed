# cascadesec-testbed

A mock production environment for demonstrating [CascadeSec](https://github.com/konradkelly/CascadeSec),
a GitHub App that scans infrastructure-as-code in pull requests, maps findings to
CIS controls, and suggests fixes it has verified by re-scanning them.

**Nothing here is real or meant to be deployed.** Account ids, domains and names
are placeholders. Pull requests against this repository introduce
misconfigurations on purpose, so CascadeSec has something to find.

## What's here

| Path | What it models |
|---|---|
| `environments/prod/aws/` | Terraform: a VPC, an encrypted data bucket, CloudTrail, a Postgres database and the payments service's security groups |
| `k8s/payments-api/` | Kubernetes: the payments API's Deployment and Service |
| `cloudformation/` | A CloudFormation stack: the payments event queue |
| `azure/` | Bicep: a storage account for exports |

`main` is reasonably hardened, not perfect. The scanners still report findings
on it, the way they would on most real environments, and the check's summary counts
them. What a PR is judged on is the lines it adds.

## How a demo PR goes

1. A PR adds infrastructure for a new feature, with some mistakes in it.
2. The **CascadeSec** check annotates the findings on the lines the PR adds, and
   offers **Draft fixes** when there is something it can try to fix.
3. **Draft fixes** drafts a fix per finding and re-scans the corrected file. A
   fix is posted as a suggested change only if it clears its finding, introduces
   no new one, and rests on no assumption a person should check.

The demo PRs are built so that both outcomes show:

- **Suggested:** a change with no side effects — for example, turning on KMS
  key rotation.
- **Held for a person:** a change the scanner is right about but that has a
  cost CascadeSec cannot judge — encrypting an existing database recreates it;
  closing SSH to the internet needs someone to say which network should keep it.

Held fixes are visible in CascadeSec's review dashboard with their reasons.
