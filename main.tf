resource "google_cloud_run_service" "default" {
  name     = var.service_name
  location = var.region

  template {
    spec {
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

# Allow unauthenticated (public) access
resource "google_cloud_run_service_iam_member" "invoker" {
  location = google_cloud_run_service.default.location
  service  = google_cloud_run_service.default.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}

output "cloud_run_url" {
  description = "Public URL of the Cloud Run service"
  value       = google_cloud_run_service.default.status[0].url
}
