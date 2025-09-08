variable "project_id" {
  description = "GCP Project ID"
  type        = string
  default     = "hip-ether-466911-g0"
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
  description = "Deployment environment (dev, stage, prod)"
  type        = string
}

variable "image" {
  description = "Container image to deploy"
  type        = string
  default     = "gcr.io/cloudrun/hello"
}
