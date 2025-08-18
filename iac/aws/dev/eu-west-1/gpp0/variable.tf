# Vars should be used for configurations that change between each deployment. Such as ID, CIDR ranges, bucket names, sub-domains
# Repeat, but not configurable data sources should be defined in `locals.tf`

variable "deployment_id" {
  type = string
  default = "gpp0"
  description = "(required) 4 character string used to group related resources"
}
