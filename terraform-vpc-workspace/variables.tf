// Variables that can be overriden on the command line, or in .tfvars files.

variable "aws_region" {
  default     = "eu-west-1"
  description = "The AWS Region to build the VPC in.  Only one region is supported right now."
}

variable "availability_zones" {
  default     = ["eu-west-1a", "eu-west-1b"]
  description = "The availability zones the we should create subnets in, launch instances in, and configure for ELB and ASG"
}

variable "availability_zones_tag" {
  default     = ["EU-WEST-1A", "EU-WEST-1B"]
  description = "The availability zones the we should create subnets in, launch instances in, and configure for ELB and ASG"
}

variable "vpc_cidr" {
  default     = ""
  description = "The range of IP addresses that we use in this VPC"
}

variable "ae_subnet_cidr" {
  default     = ["", ""]
  description = "CIDR blocks for application subnets. Number of entries must match 'availability_zones'."
}


variable "public_subnet_cidr" {
  default     = ["", ""]
  description = "CIDR blocks for public subnets. Number of entries must match 'availability_zones'."
}

variable "private_subnet_cidr" {
  default = ["", ""]

  description = "CIDR blocks for private subnets. Number of entries must match 'availability_zones'."
}

variable "database_subnet_cidr" {
  default = ["", ""]

  description = "CIDR blocks for database subnets. Number of entries must match 'availability_zones'."
}

variable "OTAP" {
  default     = "T"
  description = "OTAP Environment for resource T-TEST"
}

variable "application" {
  default     = "BUSINESS_SERVICE"
  description = "application tag for this resource"
}

variable "envr" {
  default     = ""
  description = "Environment resource belongs to. Value of this tag is used inside Chef configuration to fetch required config"
}

variable "environment" {
  default     = "test"
  description = "Environment resource belongs to. Value of this tag is used inside Chef configuration to fetch required config"
}

variable "ZONE" {
  default     = ""
  description = "ZONE it belongs to as Management/Workspace.."
}

variable "cost_center" {
  default     = "GENERIC_UNSPECIFIED"
  description = "Cost Center"
}

variable "peeringid" {
  default     = ""
  description = "peering id for accounts"
}

variable "peeringdest" {
  default = ""
}


variable "owner" {
  description = "This should be an email of a person or a group that is responsible for the resource."
}

variable "type" {
  description = "Type of VPC. Use either 'central' or 'island'. 'central' if VPC is peered to BCG network, otherwise 'island'."
  default     = "workspace"
}

variable "customer" {
  default     = ""
  description = "name of the product resource belongs to."
}


variable "landingzone" {
  default     = "no"
}
