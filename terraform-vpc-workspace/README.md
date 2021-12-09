---
layout: page
permalink: /AWS/Terraform/GenericVPCTerraformmodule/
icon: Amazon-VPC.svg
description: Generic VPC Terraform module
status: under review
type: S04 Connectivity
automation: TerraformModule
onlineTemplateReference: 
onlineServiceDescription: 
packageId: unknown
buildName: unknown
name: Generic VPC Terraform module
title: Generic VPC Terraform module
tags:
- AWS community
---

{%- include template_terraform_aws.html -%}


#### Example usage

```
module "main" {
  source              = ""
  aws_region          = "eu-central-1"
  availability_zones  = ["eu-central-1a", "eu-central-1b"]
  vpc_cidr            = ""
  public_subnet_cidr  = [""]
  private_subnet_cidr = [""]
  product             = "devops"
  environment         = "prod"
  cost_center         = ""
  owner               = ""
}
```
