#--------------------------------------------------------------------------------------------
# Creating EKS Cluster
#--------------------------------------------------------------------------------------------
resource "aws_eks_cluster" "eks_cluster_main" {
  name                        = var.eks_cluster_name
  role_arn                    = aws_iam_role.eks_cluster.arn
  enabled_cluster_log_types   = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  vpc_config {
    security_group_ids        = [aws_security_group.eks_cluster_sg.id, aws_security_group.eks_nodes_sg.id]
    endpoint_private_access   = var.endpoint_private_access
    endpoint_public_access    = var.endpoint_public_access
    subnet_ids                = concat(var.private_subnet_ids, var.public_subnet_ids)
  }

  depends_on = [
    aws_iam_role_policy_attachment.aws_eks_cluster_policy,
    aws_iam_role_policy_attachment.aws_eks_service_policy,
	aws_cloudwatch_log_group.eks_cluster_logs
  ]
}

#--------------------------------------------------------------------------------------------
# Creating Cluster IAM Role
#--------------------------------------------------------------------------------------------

resource "aws_cloudwatch_log_group" "eks_cluster_logs" {
  name              = "/aws/eks/var.eks_cluster_name/cluster"
  retention_in_days = 7
}

#--------------------------------------------------------------------------------------------
# Creating Cluster IAM Role
#--------------------------------------------------------------------------------------------

resource "aws_iam_role" "eks_cluster" {
  name = "${var.eks_cluster_name}-cluster-${var.environment}"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "aws_eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}

resource "aws_iam_role_policy_attachment" "aws_eks_service_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_cluster.name
}

#--------------------------------------------------------------------------------------------
# Creating Cluster Security Group
#--------------------------------------------------------------------------------------------

resource "aws_security_group" "eks_cluster_sg" {
  name                          = var.cluster_sg_name
  description                   = "Cluster communication with worker nodes"
  vpc_id                        = var.vpc_id

  tags = {
    Name                        = var.cluster_sg_name
  }
}

resource "aws_security_group_rule" "cluster_inbound" {
  description                   = "Allow worker nodes to communicate with the cluster API Server"
  from_port                     = 443
  protocol                      = "tcp"
  security_group_id             = aws_security_group.eks_cluster_sg.id
  source_security_group_id      = aws_security_group.eks_nodes_sg.id
  to_port                       = 443
  type                          = "ingress"
}

resource "aws_security_group_rule" "cluster_outbound" {
  description                   = "Allow cluster API Server to communicate with the worker nodes"
  from_port                     = 1024
  protocol                      = "tcp"
  security_group_id             = aws_security_group.eks_cluster_sg.id
  source_security_group_id      = aws_security_group.eks_nodes_sg.id
  to_port                       = 65535
  type                          = "egress"
}

resource "null_resource" "generate_kubeconfig" {

  provisioner "local-exec" {
    command              = "aws eks update-kubeconfig --name ${var.eks_cluster_name} --region ${var.region} --role-arn ${var.role_arn}"
  }

  depends_on             = [aws_eks_cluster.eks_cluster_main]
}