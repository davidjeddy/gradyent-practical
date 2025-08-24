data "aws_route53_zone" "this" {
  name         = var.root_domain
  private_zone = false
}

data "aws_lb" "web_app" {
  tags = {
    "eks:eks-cluster-name" = join("-", [local.env, local.application, var.deployment_id])
    "ingress.eks.amazonaws.com/resource" = "LoadBalancer"
    "ingress.eks.amazonaws.com/stack" = join("/", [var.web_app_sub_domain, join("-", ["ingress", var.web_app_sub_domain, "public"]) ])
  }
}
