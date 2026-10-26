---
hide:
  - navigation
  - toc
---

<div class="aet-hero" markdown>

<div class="aet-hero-brand" markdown>
<img src="assets/sre-agent-logo.png" alt="Azure SRE Agent" class="aet-hero-logo" width="88" height="88">
<span class="aet-hero-tagline">Your AI teammate for site reliability</span>
</div>

<div class="aet-hero-copy" markdown>
<span class="aet-eyebrow">Azure SRE Agent NanoHack</span>

# Keep Aetherion AirOps flying

You are the new reliability team for a global airline platform. In one focused
session you will pair with the **Azure SRE Agent**: first guiding it hands-on, then
trusting it to recover a live microservices estate on its own within guardrails,
moving from human-approved fixes to bounded autonomy before peak departure.

<p class="aet-meta">Self-paced · 4 acts · 6 challenges · ~3–4 hours</p>

[Start here](getting-started/environment.md){ .md-button .md-button--primary }
</div>

</div>

<div class="aet-flow" markdown>
<span>Observe</span> <em>→</em> <span>Detect</span> <em>→</em> <span>Investigate</span> <em>→</em> <span>Decide</span> <em>→</em> <span>Remediate</span> <em>→</em> <span>Verify</span> <em>→</em> <span>Learn</span>
</div>


New to the agent? Skim the optional primer **[Meet the SRE Agent](getting-started/sre-agent-fundamentals.md)** first and learn about permissions, run modes, skills and subagents in a couple of minutes.

!!! info "What you need before you start"
    Your facilitator has already provisioned your Aetherion environment in your own
    resource group. You need **PowerShell 7**, **Azure CLI**, **kubectl**, **Git** and the
    **GitHub CLI**, plus a **GitHub personal access token** for Challenge 6.
    [Set up your environment](getting-started/environment.md) walks through all of it.

## The journey

<div class="grid cards" markdown>

-   __Act I · Foundation__ <span class="aet-badge phase">Orient</span>

    ---

    Onboard the SRE Agent in read-only mode and capture a healthy baseline.

-   __Act II · Human-Guided Operations__ <span class="aet-badge phase">Respond</span>

    ---

    Detect and investigate an incident read-only, then recover under human approval.

-   __Act III · Autonomous__ <span class="aet-badge phase">Automate</span>

    ---

    Let the agent remediate autonomously within bounds and arm a Sev1 response plan.

-   __Act IV · Major Incident__ <span class="aet-badge phase">Command</span>

    ---

    Restore global check-in during a multi-service incident, then brief airline leadership.

</div>

Finished early? Two **optional extras** are in the Optional extras tab: ground the agent in
Aetherion's runbooks, and build a specialist subagent and skill.
