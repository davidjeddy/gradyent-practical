# resource "aws_eks_cluster" "cluster" {
#   depends_on = [
#     module.vpc
#   ]

#   name     = local.name
#   role_arn = aws_iam_role.cluster.arn
#   version  = var.kubernetes_version
#   bootstrap_self_managed_addons = var.bootstrap_self_managed_addons_enabled

#   vpc_config {
#     subnet_ids              = module.vpc.private_subnets
#     security_group_ids      = []
#     endpoint_private_access = "true"
#     endpoint_public_access  = "true"
#   }

#   access_config {
#     authentication_mode                         = "API"
#     bootstrap_cluster_creator_admin_permissions = false
#   }

#   zonal_shift_config {
#     enabled = var.zonal_shift_config
#   }

#   compute_config {
#     enabled       = true
#     node_pools    = ["general-purpose", "system"]
#     node_role_arn = aws_iam_role.node.arn
#   }

#   kubernetes_network_config {
#     elastic_load_balancing {
#       enabled = true
#     }
#   }

#   storage_config {
#     block_storage {
#       enabled = true
#     }
#   }