resource "aws_iam_role" "this" {
  assume_role_policy = data.aws_iam_policy_document.cluster_role_assume_role_policy.json
  name               = join(local.delimiter, [local.name, "cluster"])
}

resource "aws_iam_role" "node" {
  name = join(local.delimiter, [local.name, "node"])

  # TODO Move policy to data resource type
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = ["sts:AssumeRole"]
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}