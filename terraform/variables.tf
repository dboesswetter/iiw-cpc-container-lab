variable "ecs_cluster_name" {
    type = string
    default = "test-cluster"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type to use for webservers"
  default     = "t3.micro"
}
