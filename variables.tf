variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region for Cloud Run"
  type        = string
  default     = "us-central1"
}

variable "service_name" {
  description = "Cloud Run service name"
  type        = string
}

variable "environment" {
  description = "Deployment environment (dev, uat, prod)"
  type        = string
}

variable "image" {
  description = "Container image to deploy"
  type        = string
  default     = "gcr.io/cloudrun/hello"
}
