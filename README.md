# cloud-run-terraform
Flow:

Developer pushes updates (e.g., dev.tfvars, uat.tfvars, prod.tfvars) to GitHub main branch.

Cloud Build trigger detects the change.

Cloud Build runs cloudbuild.yaml:

Terraform Init

Terraform Plan (for logs/visibility)

Terraform Apply (deployment)

Terraform provisions/updates Cloud Run with the given .tfvars.

Cloud Run service is deployed with correct environment configuration.

⚙️ Prerequisites

Enable required APIs in your GCP project:

gcloud services enable cloudbuild.googleapis.com run.googleapis.com artifactregistry.googleapis.com iam.googleapis.com


Service Account for Cloud Build

Name: cloudbuild-terraform-sa

Roles required:

roles/run.admin (Cloud Run Admin)

roles/logging.logWriter (Logs Writer)

roles/storage.admin (Terraform backend bucket, if used)

roles/iam.serviceAccountUser (to impersonate service accounts)

Example creation:

gcloud iam service-accounts create cloudbuild-terraform-sa \
  --display-name="Service account for Cloud Build Terraform"

gcloud projects add-iam-policy-binding PROJECT_ID \
  --member="serviceAccount:cloudbuild-terraform-sa@PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/run.admin"

🚀 Setup Cloud Build Trigger

Open Google Cloud Console → Cloud Build → Triggers.

Click Create Trigger.

Configure:

Name: cloud-run-terraform-trigger

Region: us-east1

Event: Push to branch

Branch regex: ^main$

Repository: zerotohero200222/cloud-run-terraform (GitHub App)

Build config: /cloudbuild.yaml

Service Account: cloudbuild-terraform-sa@PROJECT_ID.iam.gserviceaccount.com

Substitutions: _ENV=dev (default; override in trigger if needed)

▶️ Usage
Deploy to Dev
# Edit environments/dev.tfvars
git add environments/dev.tfvars
git commit -m "Update dev environment config"
git push origin main


Cloud Build will run automatically and deploy the updated Cloud Run service.

Deploy to UAT

Override _ENV=uat in the Cloud Build trigger or manually run with substitution.

Deploy to Prod

Override _ENV=prod in the Cloud Build trigger.

(Optionally enable manual approval for production deployments).

📊 Outputs

After deployment, Terraform prints:

Cloud Run Service Name

Region

Public URL

Example:

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

Outputs:

cloud_run_service_name = "my-cloudrun-service-dev"
cloud_run_region       = "us-central1"
cloud_run_url          = "https://my-cloudrun-service-dev-abc123.run.app"

🔒 Notes

Terraform state should be stored in a remote backend (e.g., GCS bucket) in production setups.

For simplicity, this repo uses local state (not recommended for team environments).

Replace gcr.io/cloudrun/hello with your actual container image for real workloads.

✅ With this setup, every push to main automatically deploys Cloud Run services using Terraform through Cloud Build.
