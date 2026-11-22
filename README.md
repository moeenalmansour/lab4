cd ~/lab4
cat > README.md <<'EOF'
# AI381 Lab 4: Your Cloud as Code (Terraform)

The Lab 3 churn API on Azure Container Apps, described as Terraform code.

## What is here
- `infra/`: Terraform for a resource group, a Log Analytics workspace, a Container Apps environment and the Container App. Names, region and image tag are variables. Every resource has the tags owner, course and lab.
- `scripts/bootstrap-state.sh`: creates the Azure Storage account that holds the remote state (with locking).
- `scripts/azure-oidc-setup.sh`: lets GitHub Actions log in to Azure with OIDC, so no password is stored.
- `.github/workflows/terraform.yml`: the pipeline.

## Pipeline
- On every pull request: `terraform fmt`, `validate`, a Trivy security scan, and `plan` posted as a comment.
- On merge to main: `terraform apply` through OIDC, then a smoke test on `/health`.
- Actions are pinned to full commit SHAs.

## Notes
- The state is stored in Azure Storage, never in Git.
- `terraform.tfvars` and `backend.hcl` are not committed. The pipeline gets its values from GitHub variables and secrets.
- The region is francecentral, because the student subscription only allows a few regions.
EOF
cat > /mnt/c/Users/USER/Desktop/reflection.txt <<'EOF'
After this lab, I would never build cloud resources by hand in the portal again.
When I changed a tag in the portal on purpose, Azure accepted it silently, and only terraform plan showed the difference. Git then put it back through one pull request.
In code, every change is reviewed in a pull request, the plan is shown before the merge, and the history says who changed what and why.
I could also destroy everything and rebuild it from Git with one command in under three minutes.
And I would never store a cloud password in the pipeline: OIDC gives short-lived access with no secret to leak.
EOF
git add README.md && git commit -m "Add README" && git push
