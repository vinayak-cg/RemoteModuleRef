variable "name" {
  type        = string
  description = "(Optional) The name of the The resource group. When this value is left empty the resource group name is a concatenation of: <customer>-<category>-<application name>-<environment>"
  default     = ""
}

variable "customer" {
  type        = string
  description = "The customer name of the project."
}

variable "category" {
  type        = string
  description = " The category the cloud resource group belongs to. There are three categories to the cloud resource groups: platform, core, app."
}

variable "applicationname" {
  type        = string
  description = "The application name of the The resource group."
}

variable "environment" {
  type        = string
  description = "The environment of the system in the resource group, can be t(team - the environment the team can use) d(development), t(test), a(acceptance), p(production) or any other the team usess."
}

variable "location" {
  type        = string
  description = "The location of the The resource group."
  default     = "West US"
}

variable "tags" {
  type        = map(any)
  description = "A mapping of tags to assign to the resources."
  default     = {}
}
