variable "eks_cluster_name" {
  description                   = "Name of the EKS cluster"
  type = string
}

variable "node_group_name" {
  description                   = "Name of the Node Group"
  type = string
}

variable "environment" {
  type                          = string
  description                   = "Application enviroment"
}

variable "endpoint_private_access" {
  type                          = bool
  default                       = true
  description                   = "whether or not the Amazon EKS private API server endpoint is enabled."
}

variable "endpoint_public_access" {
  type                          = bool
  default                       = true
  description                   = "whether or not the Amazon EKS public API server endpoint is enabled."
}

#variable "eks_cluster_subnet_ids" {
#  type                          = list(string)
#  description                   = "List of subnet IDs. Must be in at least two different availability zones. Amazon EKS creates cross-account elastic network interfaces in these subnets to allow communication between your worker nodes and the Kubernetes control plane."
#}

variable "private_subnet_ids" {
  type                          = list(string)
  description                   = "List of private subnet IDs."
}

variable "public_subnet_ids" {
  type                          = list(string)
  description                   = "List of public subnet IDs."
}

variable "ami_type" {
  description                   = "Type of Amazon Machine Image (AMI) associated with the EKS Node Group. Defaults to AL2_x86_64. Valid values: AL2_x86_64, AL2_x86_64_GPU."
  type                          = string 
  default                       = "AL2_x86_64"
}

variable "disk_size" {
  description                   = "Disk size in GiB for worker nodes."
  type                          = number
  default                       = 30
}

variable "instance_types" {
  type                          = list(string)
  default                       = ["t3.medium"]
  description                   = "Set of instance types associated with the EKS Node Group."
}

variable "private_desired_size" {
  description                   = "Desired number of worker nodes in private subnet"
  default                       = 1
  type                          = number
}

variable "private_max_size" {
  description                   = "Maximum number of worker nodes in private subnet."
  default                       = 1
  type                          = number
}

variable "private_min_size" {
  description                   = "Minimum number of worker nodes in private subnet."
  default                       = 1
  type                          = number
}

variable "public_desired_size" {
  description                   = "Desired number of worker nodes in public subnet"
  default                       = 1
  type                          = number
}

variable "public_max_size" {
  description                   = "Maximum number of worker nodes in public subnet."
  default                       = 1
  type                          = number
}

variable "public_min_size" {
  description                   = "Minimum number of worker nodes in public subnet."
  default                       = 1
  type                          = number
}

variable cluster_sg_name {
  description                   = "Name of the EKS cluster Security Group"
  type                          = string
}

variable nodes_sg_name {
  description                   = "Name of the EKS node group Security Group"
  type                          = string
}

variable vpc_id {
  description                   = "VPC ID from which belogs the subnets"
  type                          = string
}

variable "role_arn" {
  description = "Role arn to be assumed by the kubeconfig"
  type        = string
}

variable "region" {
  description = "aws region to deploy to"
  type        = string
}
