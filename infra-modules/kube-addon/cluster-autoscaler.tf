data "aws_iam_openid_connect_provider" "connect" {
  arn = var.openid_provider_arn
}

data "aws_iam_policy_document" "cluster_autoscaler" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect = "Allow"
  condition {
    test     = "StringEquals"
    variable = "${replace(data.aws_iam_openid_connect_provider.connect.url, "https://", "")}:sub"
    values   = ["system:serviceaccount:kube-system:cluster-autoscaler"]
  }

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "cluster_autoscaler" {
  count= var.enable_cluster_autoscaler ? 1 : 0

  name               = "${var.eks_name}-cluster-autoscaler"
  assume_role_policy = data.aws_iam_policy_document.cluster_autoscaler.json
}

resource "aws_iam_policy" "cluster_autoscaler" {
    count = var.enable_cluster_autoscaler ? 1 : 0
    name = "${var.eks_name}-cluster-autoscaler"
    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Action = [
                    "autoscaling:DescribeAutoScalingGroups",
                    "autoscaling:DescribeAutoScalingInstances",
                    "autoscaling:DescribeLaunchConfigurations",
                    "autoscaling:DescribeAutoScalingActivities",
                    "ec2:DescribeInstancesTypes",
                    "ec2:DescribeTemplateVersions"
                ]
                Effect = "Allow"
                Resource = "*"
            },
            {
                Effect = "Allow"
                Action = [
                    "autoscaling:SetDesiredCapacity",
                    "autoscaling:TerminateInstanceInAutoScalingGroup"
                ]
                Effect = "Allow"
                Resource = "*"
            }
        ]
    })
}
resource "aws_iam_role_policy_attachment" "cluster_autoscaler" {
    count = var.enable_cluster_autoscaler ? 1 : 0

    role       = aws_iam_role.cluster_autoscaler[0].name
    policy_arn = aws_iam_policy.cluster_autoscaler[0].arn
}

resource "helm_release" "cluster_autoscaler" {
    count = var.enable_cluster_autoscaler ? 1 : 0

    name       = "autoscaler"
    repository = "https://kubernetes.github.io/autoscaler"
    chart      = "cluster-autoscaler"
    version    = var.cluster_autoscaler_helm_version
    namespace  = "kube-system"

    set = [
        {
            name  = "rbac.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
            value = aws_iam_role.cluster_autoscaler[0].arn
        },
        {
            name  = "autoDiscovery.clusterName"
            value = var.eks_name
        },
        {
            name  = "rbac.serviceAccount.name"
            value = "cluster-autoscaler"
        }
    ]

    depends_on = [
        aws_iam_role_policy_attachment.cluster_autoscaler
    ]
}