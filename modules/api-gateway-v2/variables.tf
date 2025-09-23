#---- modules/api-gateway-v2/variables.tf ------
variable "params" {
  type        = map(any)
  description = "Map of configuration for the API and custom domain name to be created"
}