variable "root_domain" {
  default     = "davidjeddy.com"
  description = "(required) 4 character string used to group related resources"
  type        = string
}

# Note: To reduce repeated configurations a tool like Terragrunt can be used to abstract and consolidate. For this project I did not want to introduce 3rd party tools without knowing the evaluation process would also have to tools available.

variable "deployment_id" {
  default     = "gpp0"
  description = "(required) 4 character string used to group related resources"
  type        = string

  validation {
    condition     = can(regex("^[^\\s]{4}$", var.deployment_id))
    error_message = "The deployment_id value must be a 4 character alphanumeric string"
  }
}

variable "web_app_sub_domain" {
  default     = "web-app"
  description = "(required) DNS sub-domain as a string"
  type        = string

  validation {
    condition     = can(regex("^([0-9A-Za-z]).{4,32}$", var.web_app_sub_domain))
    error_message = "The web_app_sub_domain value must be an alphanumeric string between 4 and 32 characters in length"
  }
}
