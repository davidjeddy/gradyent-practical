# Note: To reduce repeated configurations a tool like Terragrunt can be used to abstract and consolidate. For this project I did not want to introduce 3rd party tools without knowing the evaluation process would also have to tools available.
variable "deployment_id" {
  default = "gpp0"
  description = "(required) 4 character string used to group related resources"
  type = string

  validation {
    condition = can(regex("^[^\\s]{4}$", var.deployment_id))
    error_message = "The deployment_id value must be a 4 character alphanumeric string"
  }
}

variable "root_domain" {
  default = "davidjeddy.com"
  description = "(required) 4 character string used to group related resources"
  type = string

  # TODO regex for TLDs
  # validation {
  #   condition = can(regex("^((?!-))(xn--)?[a-z0-9][a-z0-9-_]{0,61}[a-z0-9]{0,1}.(xn--)?([a-z0-9-]{1,61}|[a-z0-9-]{1,30}.[a-z]{2,})$", var.root_domain))
  #   error_message = "The root_domain value must be a alphanumeric string between 4 and 32 character in length"
  # }
}

variable "web_app_sub_domain" {
  default = "web-app"
  description = "(required) DNS sub-domain as a string"
  type = string

  validation {
    condition = can(regex("^([0-9A-Za-z]).{4,32}$", var.web_app_sub_domain))
    error_message = "The web_app_sub_domain value must be an alphanumeric string between 4 and 32 characters in length"
  }
}

variable "web_app_elb_arn" {
  default = "arn:aws:elasticloadbalancing:eu-west-1:530589290119:loadbalancer/app/k8s-webapp-ingressw-72770ac2d5/dee2887c69909610"
  description = "(required) ARN of the ELB used to front the service"
  type = string

  # TODO
  # validation {
  #   condition = can(regex("^arn:(?P[^:\\n]*):(?P[^:\\n]*):(?P[^:\\n]*):(?P[^:\\n]*):(?P(?:[^\\/\\n]*\\/[^\\/\\n]*)?(?P[^:\\/\\n]*)[:\\/])?(?P.*)$", var.elb_arn))
  #   error_message = "The elb_arn value must be an alphanumeric string between 4 and 32 characters in length"
  # } 
}