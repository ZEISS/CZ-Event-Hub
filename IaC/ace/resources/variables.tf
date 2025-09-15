variable "resource_group" {
  type        = string
  description = "Resource group where to deploy the resources"
}

variable "tags" {
  type        = map(string)
  description = "Map of additional tags to set to the resources"
}