variable "deployment_id" {
  default     = "gpp0"
  description = "(required) 4 character string used to group related resources"
  type        = string

  validation {
    condition     = can(regex("^[^\\s]{4}$", var.deployment_id))
    error_message = "The deployment_id value must be a 4 character alphanumeric string"
  }
}
