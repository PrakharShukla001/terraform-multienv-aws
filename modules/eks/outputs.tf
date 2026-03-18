output "cluster_name" {
  description = "EKS Cluster name"
  value       = aws_eks_cluster.main.name
}

output "cluster_endpoint" {
  description = "EKS Cluster endpoint"
  value       = aws_eks_cluster.main.endpoint
}

output "cluster_ca" {
  description = "EKS Cluster certificate authority"
  value       = aws_eks_cluster.main.certificate_authority[0].data
}

output "node_group_name" {
  description = "Node group name"
  value       = aws_eks_node_group.main.node_group_name
}
