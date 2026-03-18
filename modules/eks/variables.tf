variable "env" {
  description = "Environment name"
  type        = string
}

variable "kubernetes_version" {
  description = "K8s version"
  type        = string
  default     = "1.28"
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for EKS"
  type        = list(string)
}

variable "cluster_sg_id" {
  description = "Security group ID for EKS cluster"
  type        = string
}

variable "node_instance_type" {
  description = "EC2 instance type for nodes"
  type        = string
  default     = "t3.medium"
}

variable "desired_nodes" {
  description = "Desired number of nodes"
  type        = number
  default     = 2
}

variable "min_nodes" {
  description = "Minimum number of nodes"
  type        = number
  default     = 1
}

variable "max_nodes" {
  description = "Maximum number of nodes"
  type        = number
  default     = 5
}

variable "common_tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}
