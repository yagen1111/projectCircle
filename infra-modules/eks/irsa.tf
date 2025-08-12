#irsa = iam roles for service accounts
data "tls_certificate" "this" {
    # if condition
    count = var.enable_irsa ? 1 : 0
    #verify the authenticity of your EKS cluster's OIDC provider.
    url = aws_eks_cluster.eks.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "connect" {
    count = var.enable_irsa ? 1 : 0

    url = aws_eks_cluster.eks.identity[0].oidc[0].issuer

    client_id_list = ["sts.amazonaws.com"]

    thumbprint_list = [data.tls_certificate.this[0].certificates[0].sha1_fingerprint]
}