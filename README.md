# Azure SRE Agent NanoHack

A condensed, **3–4 hour** edition of the Aetherion AirOps / Azure SRE Agent MicroHack. You
play a new reliability engineer on a global airline platform and work with the **Azure
SRE Agent** through six challenges: onboard it read-only, detect and investigate an
incident, recover it under approval, let the agent act autonomously within guardrails,
command a multi-service major incident, and brief leadership.

> Documentation site: https://abengtss-max.github.io/azure-sre-agent-nanohack/

Your facilitator has already provisioned your environment. Start with
**[Set up your environment](https://abengtss-max.github.io/azure-sre-agent-nanohack/getting-started/environment/)**.

---

## Quick start (attendees)

```powershell
git clone https://github.com/abengtss-max/azure-sre-agent-nanohack.git
cd azure-sre-agent-nanohack

az login
az account set --subscription "<subscription-id>"

# Attach to the resource group your facilitator gave you
./scripts/attach-environment.ps1 -ResourceGroup <your-resource-group>

# Then, for each challenge N:
./scripts/start-challenge.ps1 <N>
./scripts/check-challenge.ps1 <N>
```

Requires PowerShell 7, Azure CLI and kubectl.

## Repository layout

| Path | Purpose |
| --- | --- |
| `docs/` | The NanoHack documentation site (Material for MkDocs) |
| `scripts/` | Attach, start and check challenges |
| `knowledge/` | Markdown knowledge base for the optional grounding challenge |
| `agents/`, `skills/` | Subagent and skill files for the optional engineering challenge |
| `app/`, `infra/`, `k8s/`, `load/` | The Aetherion AirOps platform source your facilitator deployed |

## Notes

- This is a **fictional, non-production teaching environment**. It models an operational
  platform, **not** safety-of-flight avionics.
- Work only in your assigned resource group. Your facilitator removes the environment
  after the session.
