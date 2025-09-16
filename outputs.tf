output "cloud_run_service_name" {
  description = "The name of the deployed Cloud Run service"
  value       = google_cloud_run_service.default.name
}

output "cloud_run_region" {
  description = "Region where the Cloud Run service is deployed"
  value       = google_cloud_run_service.default.location
}

output "cloud_run_url" {
  description = "The public URL of the Cloud Run service"
  value       = google_cloud_run_service.default.status[0].url
}
