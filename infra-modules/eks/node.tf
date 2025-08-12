resource "aws_eks_node_group" "node-group" {
    for_each = var.node_group

    cluster_name    = aws_eks_cluster.eks.name
    node_role_arn   = aws_iam_role.nodes.arn
    node_group_name = each.key

    subnet_ids      = var.subnet_ids
    capacity_type   = each.value.capacity_type
    instance_types  = each.value.instance_types

    scaling_config {
        desired_size = each.value.scaling_config.desired_size
        max_size     = each.value.scaling_config.max_size
        min_size     = each.value.scaling_config.min_size
    }
#the desired unwork worker during update
    update_config {
        max_unavailable = 1
    }

    labels = {
        role =each.key
    }

    depends_on = [aws_iam_role_policy_attachment.nodes]

}