# Create a dedicated service account for Cloud Run execution
resource "google_service_account" "cloudrun_exec" {
  account_id   = "cloudrun-exec-sa"
  display_name = "Cloud Run Execution Service Account"
}

# Grant Artifact Registry read permissions
resource "google_project_iam_member" "artifactregistry_reader" {
  project = var.project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${google_service_account.cloudrun_exec.email}"
}

# Grant legacy Container Registry (gcr.io) read permissions if needed
resource "google_project_iam_member" "storage_object_viewer" {
  project = var.project_id
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.cloudrun_exec.email}"
}

# Cloud Run service
resource "google_cloud_run_service" "default" {
  name     = var.service_name
  location = var.region

  template {
    spec {
      service_account_name = google_service_account.cloudrun_exec.email

      containers {
        image = var.image

        env {
          name  = "ENVIRONMENT"
          value = var.environment
        }
      }
    }
  }

  autogenerate_revision_name = true
}

# Allow public (unauthenticated) access
resource "google_cloud_run_service_iam_member" "invoker" {
  location = google_cloud_run_service.default.location
  service  = google_cloud_run_service.default.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}
