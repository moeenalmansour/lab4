variable "owner" {
  description = "Your name or GitHub user, used in tags"
  type        = string
}

variable "prefix" {
  description = "Short prefix for every resource name, for example ai381-talomari"
  type        = string
  default     = "ai381-<your-name>"
}

variable "location" {
  description = "Azure region (Azure for Students allows a limited list of regions)"
  type        = string
  default     = "westeurope"
}

variable "image" {
  description = "Container image to run, for example ghcr.io/<user>/<your-image-name>"
  type        = string
}

variable "image_tag" {
  description = "Image tag: the short commit SHA built by CI"
  type        = string
}

variable "min_replicas" {
  description = "0 = scale to zero when idle (no cost)"
  type        = number
  default     = 0
}

variable "budget_amount" {
  description = "Monthly budget for the resource group, in USD"
  type        = number
  default     = 10
}

variable "budget_email" {
  description = "Email that receives budget alerts"
  type        = string
}
