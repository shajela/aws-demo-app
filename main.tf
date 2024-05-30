locals {
  region           = "us-east-1"
  name             = "demo-vpc"
  cidr             = "10.0.0.0/16"
  private_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets   = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  database_subnets = ["10.0.104.0/24", "10.0.105.0/24", "10.0.106.0/24"]
  dual_subnets     = ["10.0.107.0/24", "10.0.108.0/24", "10.0.109.0/24"]
}

# Configures VPC and ALB
module "web-app" {
  source = "./modules/"

  name = local.name
  cidr = local.cidr

  azs              = ["${local.region}a", "${local.region}b", "${local.region}c"]
  private_subnets  = local.private_subnets
  public_subnets   = local.public_subnets
  database_subnets = local.database_subnets
  dual_subnets     = local.dual_subnets
}