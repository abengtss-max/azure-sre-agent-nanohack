# Commands

All scripts live in `scripts/` and are PowerShell 7 (`pwsh`). Run them from the
repository root, signed in with `az login` and the correct subscription selected.
`.sh` equivalents exist for the cross-platform ones.

## Provisioning

| Command | What it does |
|---------|--------------|
| `./scripts/00-check-providers.ps1` | Verifies and registers required resource providers (idempotent) |
| `./scripts/01-deploy-infra.ps1 -ResourceGroup <your-rg> -Location swedencentral` | Provisions infrastructure via Bicep |
| `./scripts/02-build-push-images.ps1 -ResourceGroup <your-rg>` | Builds and pushes the app image to ACR |
| `./scripts/03-deploy-app.ps1 -ResourceGroup <your-rg>` | Deploys the app + k6 to AKS and wires APIM to the gateway |
| `./scripts/03b-setup-https.ps1` | Configures HTTPS on the gateway (Let's Encrypt) |
| `./scripts/03c-setup-grafana.ps1` | Provisions the Grafana dashboards and Azure Monitor data source |
| `./scripts/04-validate.ps1` | Validates the estate is healthy and generating traffic (reads the resource group from local state) |
| `./scripts/attach-environment.ps1 -ResourceGroup <your-rg>` | **NanoHack:** attaches to your pre-provisioned environment and writes the local state file the challenge scripts read |
| `./scripts/provision-environment.ps1` | Facilitator only. End-to-end provisioning wrapper. Always provisions into a **uniquely named** `rg-aetherion-microhack-<suffix>` and prints the name |

## Running the hack

| Command | What it does |
|---------|--------------|
| `./scripts/start-challenge.ps1 <n>` | Sets up and briefs challenge `n` |
| `./scripts/check-challenge.ps1 <n>` | Validates your work for challenge `n` |
| `./scripts/reset-environment.ps1` | Restores a clean, healthy baseline between runs (add `-ResetProgress` to also re-lock challenges for a fresh run) |

## Teardown

!!! warning "Facilitator only"
    In the NanoHack your facilitator owns teardown. Attendees do not run the delete commands below.

| Command | What it does |
|---------|--------------|
| `./scripts/reset-environment.ps1` | Restores a clean, healthy baseline between runs (add `-ResetProgress` to also re-lock challenges for a fresh run) |
| `./scripts/99-teardown.ps1` | Lists the microhack(s) in your subscription and lets you pick which to delete. Removes the hack resource group **and** its `-loadgen` pair |
| `./scripts/99-teardown.ps1 -ResourceGroup <rg>` | Deletes a specific microhack (and its `-loadgen` pair) non-interactively |
| `./scripts/99-teardown.ps1 -All` | Deletes every Aetherion microhack in the subscription |
