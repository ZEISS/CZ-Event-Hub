variable "resource_group" {
  type        = string
  description = "Resource group where to deploy the resources"
}

variable "aks_name" {
  type        = string
  description = "Name of the aks cluster"
}

variable "law_name" {
  type        = string
  description = "Name of the log analytics workspace"
}

variable "tags" {
  type        = map(string)
  description = "Map of additional tags to set to the resources"
}