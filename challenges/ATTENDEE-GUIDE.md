# Azure SRE Agent NanoHack: Attendee Guide

The full guide for this event is the documentation site:

**https://abengtss-max.github.io/azure-sre-agent-nanohack/**

Start with **Set up your environment**. In short:

```powershell
git clone https://github.com/abengtss-max/azure-sre-agent-nanohack.git
cd azure-sre-agent-nanohack

az login
az account set --subscription "<subscription-id>"

./scripts/attach-environment.ps1 -ResourceGroup <your-resource-group>

./scripts/start-challenge.ps1 <N>     # open challenge N
./scripts/check-challenge.ps1 <N>     # verify it
```

You run six challenges, numbered **1 to 6**. The two optional extras, **A** and **B**, are
for if you finish early (`./scripts/start-challenge.ps1 A`).

> This is a fictional, non-production teaching environment. It models an operational
> platform, not safety-of-flight avionics.
