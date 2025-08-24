module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.0.1"

  enable_dns_hostnames               = true
  enable_dns_support                 = true
  enable_nat_gateway                 = true
  enable_vpn_gateway                 = false
  name                               = local.name
  one_nat_gateway_per_az             = false
  propagate_private_route_tables_vgw = true
  propagate_public_route_tables_vgw  = true
  single_nat_gateway                 = true

  cidr            = "10.20.0.0/19"

  azs = [
    "eu-west-1a",
    "eu-west-1b",
    "eu-west-1c"
  ]
  private_subnets = [
    "10.20.0.0/21", 
    "10.20.8.0/21", 
    "10.20.16.0/21"
  ]
  public_subnets  = [
    "10.20.24.0/23",
    "10.20.26.0/23",
    "10.20.28.0/23"
  ]

  private_subnet_tags = {
    "karpenter.sh/discovery"          = local.name
    "kubernetes.io/role/cni"          = "1"
    "kubernetes.io/role/internal-elb" = "1",
    "mapPublicIpOnLaunch"             = "FALSE"
  }

  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1",
    "mapPublicIpOnLaunch"    = "TRUE"
  }

  tags = {
    "kubernetes.io/cluster/${local.name}" = "shared"
  }
}
