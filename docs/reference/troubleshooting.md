# Troubleshooting

Common friction points during setup and delivery. For live application incidents,
that *is* the hack. Start from the [Operations Center](../getting-started/environment.md)
and let the agent investigate.

## Setup

??? question "Provisioning fails on a missing resource provider"
    Run `./scripts/00-check-providers.ps1`. It registers the required providers
    idempotently. Registration can take a few minutes to propagate, so re-run the
    failed script afterwards.

??? question "`az` commands hit the wrong subscription"
    Confirm the active subscription with `az account show`. Set the right one with
    `az account set --subscription "<subscription-id>"` before re-running.

??? question "AKS pods are not becoming Ready"
    Check events with `kubectl get pods -n aetherion` and
    `kubectl describe pod <name> -n aetherion`. Image pull or resource pressure are
    the usual causes. `./scripts/04-validate.ps1` reports overall health.

??? question "The Operations Center GUI will not load over HTTPS"
    HTTPS is provisioned by `./scripts/03b-setup-https.ps1` (Envoy Gateway +
    Let's Encrypt). Until the certificate is issued, use the direct
    `http://<gateway-public-ip>/` endpoint.

## During the hack

??? question "The agent cannot see or act on a resource"
    This is almost always RBAC. The agent acts through its **own managed identity**.
    Grant Reader broadly and narrow write roles only where remediation is intended.
    See [SRE Agent basics](../getting-started/sre-agent-fundamentals.md).

??? question "The agent proposes a plan but never executes"
    That is **Review mode** working as designed. It waits for explicit approval.
    Approve the plan, or promote the fault class to **Autonomous** once you trust it.

??? question "A challenge validation keeps failing"
    Re-read the challenge's **Challenge tasks** section, then run
    `./scripts/check-challenge.ps1 <n>`. If the environment drifted, reset it with
    `./scripts/reset-environment.ps1` and retry.

??? question "The environment is in a weird state after several faults"
    Run `./scripts/reset-environment.ps1` to restore a clean, healthy baseline, then
    re-inject only the fault for the current challenge.

??? question "The agent is looking at the wrong resource group"
    Provisioning creates a uniquely suffixed `rg-aetherion-microhack-<suffix>`, and
    re-provisioning leaves the previous one running. If the agent reports resources
    that don't match your board, its **Azure resources** scope is pointed at an older
    environment. Re-open the agent's setup, re-select the resource group the
    provisioner printed, and delete the stale environments with
    `./scripts/99-teardown.ps1`.

??? question "Knowledge files stay stuck and never reach Indexed (Extra A)"
    Bulk upload can partially fail without reporting it. Open **Builder → Knowledge
    Sources** and check every file individually reached **Indexed**; re-upload any
    that didn't, one at a time. An un-indexed runbook is invisible to the agent, so
    the advice stays generic and the challenge looks broken when it isn't.

??? question "The Sev1 response plan never fires (Challenge 4 → 7)"
    This is the failure that only surfaces once Challenge 5 is already open. Check
    **Incidents → Triggers & response plans**:

    - **Status** must be **On**, and **Severity** must be exactly **Sev1** — a
      broader filter fires on everything, a mismatched one catches nothing.
    - **Azure Monitor** must be connected as an incident platform.
    - No leftover **quickstart** plan should be competing with yours.

    Fix it, then re-run `./scripts/start-challenge.ps1 5`.

??? question "GitHub writes fail in Challenge 6"
    The GitHub MCP connector accepts a **PAT only**, and the token you created during
    setup expires quickly by design. Confirm it hasn't expired, and that it is scoped
    to *your* `aetherion-airops-platform` copy with **Contents**, **Pull requests**
    and **Issues** set to read and write. A token missing one of those fails at the
    step that needs it, not at connection time.

??? question "The agent runs out of tools after adding an MCP server (Challenge 6)"
    Tools are capped at an **80-tool budget** across the agent. A full MCP server can
    consume most of it on its own. Disable the tools you don't need on the connector
    so the agent keeps the Azure and Kubernetes tools the rest of the day depends on.

## Still stuck

Re-read the hints in the current challenge and work forward from the evidence in
the Operations Center, Application Insights, and Grafana. Reset with
`./scripts/reset-environment.ps1` if the estate is in a confusing state.
