variable "key_name" {
  description = "Enter ssh key name to access the worker nodes"   // *
}
variable "sg_vpc_id" {
  description = "vpc id for security group"                       // * 
} 
variable "controller_subnet_ids" {
  description = "subnets where controller created"
  type = list(string)                                            // *
}
variable "worker_subnet_ids" {
  description = "subnets where worker nodes get created"
  type = list(string)                                           // *
}

variable "scaling_config" {
  description = "Scaling configuration for the auto-scaling group"
  default = {
    desired_size = 2
    max_size     = 5
    min_size     = 1
  }
}
variable "instance_types" {
  description = "Type of Instance specs ex: t2.micro, t2.medium. t2.large in list format"
  type = list(string)
  default = ["t2.medium"]
}
variable "disk_size" {
  default = 20
}
variable "endpoint_public_access" {
  description = "all public access for cluster"
  default = true
}
