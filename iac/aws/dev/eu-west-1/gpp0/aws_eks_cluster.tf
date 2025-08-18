resource "aws_eks_cluster" "cluster" {
  depends_on = [
    module.vpc
  ]

  bootstrap_self_managed_addons = false
  name     = local.name
  role_arn = aws_iam_role.cluster.arn

  version  = "1.33"

  vpc_config {
    endpoint_private_access = "true"
    endpoint_public_access  = "true"
    security_group_ids      = []
    subnet_ids              = module.vpc.private_subnets
  }

  access_config {
    authentication_mode                         = "API"
    bootstrap_cluster_creator_admin_permissions = false
  }

  zonal_shift_config {
    enabled = true
  }

  compute_config {
    enabled       = true
    node_pools    = ["general-purpose", "system"]
    node_role_arn = aws_iam_role.node.arn
  }

  kubernetes_network_config {
    elastic_load_balancing {
      enabled = true
    }
  }

  storage_config {
    block_storage {
      enabled = true
    }
  }
}
