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

You run six challenges, in this order: **1, 2, 3, 6, 7, 8**. Challenges 4 and 5 are
optional extras if you finish early.

> This is a fictional, non-production teaching environment. It models an operational
> platform, not safety-of-flight avionics.
