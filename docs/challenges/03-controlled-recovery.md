# Challenge 3 · Controlled Recovery

!!! abstract "Challenge 03 of 06 · Act II: Human-Guided Operations"
    **Time:** ~25 min · **Run mode:** Review, approved writes · **Access:** every action approved by you

**Situation.** Your check-in hypothesis is solid. **Elena Vasquez**, Aetherion's operations director,
wants it fixed **safely**, with a human in the loop. The incident from Challenge 2 is still open.

**Mission.** Recover check-in with the least-disruptive action, under your approval, and verify it
from telemetry.

!!! example "Start this challenge"

    ```powershell
    ./scripts/start-challenge.ps1 3
    ```

    This continues the Challenge 2 incident. No new fault is added.

### Tasks

1. **Plan the fix.** Ask the agent to turn your hypothesis into a concrete `booking` remediation plan and to name the permission it needs.
2. **Recover under approval.** Keep the agent in Review, approve the least-disruptive fix, and confirm latency is back to baseline.

![Challenge 3 storyboard: Sam, Aria and Elena run a controlled recovery](../assets/storyboard/img-challenge-3.webp){ .story-panel loading=lazy }

### Suggested prompt

!!! quote "Paste into the agent chat"
    Check-in is still slow. Propose a fix. Don't change anything yet.

Whatever it proposes, make it name the permission each action needs before it goes near production.

### Success criteria

- Check-in is fixed by a least-disruptive action you approved in **Review** mode, not by ungoverned automation.
- `booking` is healthy, latency is back to baseline, and **the setting the change altered matches what the repository declares**. Compensating around it is not a fix.

!!! success "Verify your work"

    ```powershell
    ./scripts/check-challenge.ps1 3
    ```

??? tip "Hints"

    - Ask for a *plan* before any action. The plan names the permission the write needs, and it is what you approve.
    - The safe fix puts back exactly what the last change took away. It should not restart the cache, touch the database or go near the nodes.
    - Still stuck? Ask: *"Turn my check-in hypothesis into a remediation plan for `booking`. Restore it to exactly what the repository manifest declares, not a value you choose, and tell me what permission the action needs."*

??? question "Stuck? Step by step"

    ??? note "Task 1 · Plan the fix"
        Paste the prompt above. The agent should say exactly what it will change and which **permission** that needs.

        !!! warning "A plan is not a pending action"
            No **Approve** button appears yet. That is correct: in Review mode the card only appears when the
            agent **attempts a write**. When you are happy with the plan, say *"Apply the booking remediation now."*

    ??? note "Task 2 · Recover under approval"
        Read the exact command on the approval card, then select **Approve action**. One instruction queues
        one action. Then confirm `booking` latency is back to baseline and that no override is left on the
        deployment.

        - **What gated the write?** Your **run mode**, not the agent's Azure role. Permissions decide what the
          agent can reach; run mode decides whether it asks first.
        - **Who made the change?** The card says *"Agent permissions will be used"*: the write runs as the
          agent's managed identity, so the Activity Log names the agent, not you. Remember this in Challenge 6.
        - **Check the change record.** `kubectl rollout history deploy/booking -n aetherion` shows the bad change
          and the fix with the same change cause, because the fix did not record why. That is why teams insist on
          pipelines that leave a record.

### Reference

- [Review and approve mitigations](https://learn.microsoft.com/en-us/azure/sre-agent/execute-mitigations)
- [Manage roles and permissions](https://learn.microsoft.com/en-us/azure/sre-agent/manage-permissions)

!!! success "Up next: let the agent act on its own"
    Every write so far waited for your approval. Next, a minor incident is safe enough to hand to the agent.

    [Proceed to Challenge 4 · Autonomous Recovery →](04-autonomous-recovery.md){ .md-button .md-button--primary }
