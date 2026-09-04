variable "name" {
  description = "EKS cluster name"
  type        = string
}

variable "environment" {
  description = "Environment name such as dev, stage, or prod"
  type        = string
}

variable "kubernetes_version" {
  description = "EKS Kubernetes version"
  type        = string
  default     = "1.33"
}

variable "subnet_ids" {
  description = "Subnet IDs where EKS control plane and managed node groups will run"
  type        = list(string)

  validation {
    condition     = length(var.subnet_ids) >= 2
    error_message = "At least two subnet IDs are required for EKS."
  }
}

variable "node_instance_types" {
  description = "EC2 instance types for EKS managed node group"
  type        = list(string)
  default     = ["c7i-flex.large"]
}

variable "capacity_type" {
  description = "EKS managed node group capacity type"
  type        = string
  default     = "ON_DEMAND"

  validation {
    condition     = contains(["ON_DEMAND", "SPOT"], var.capacity_type)
    error_message = "capacity_type must be ON_DEMAND or SPOT."
  }
}

variable "desired_nodes" {
  description = "Desired number of EKS worker nodes"
  type        = number
  default     = 2
}

variable "min_nodes" {
  description = "Minimum number of EKS worker nodes"
  type        = number
  default     = 2
}

variable "max_nodes" {
  description = "Maximum number of EKS worker nodes"
  type        = number
  default     = 4
}

variable "node_disk_size" {
  description = "EKS worker node root disk size in GB"
  type        = number
  default     = 30
}

variable "node_ami_type" {
  description = "AMI type for EKS managed node group"
  type        = string
  default     = "AL2023_x86_64_STANDARD"
}

variable "endpoint_private_access" {
  description = "Enable private access to EKS Kubernetes API endpoint"
  type        = bool
  default     = true
}

variable "endpoint_public_access" {
  description = "Enable public access to EKS Kubernetes API endpoint"
  type        = bool
  default     = true
}

variable "public_access_cidrs" {
  description = "CIDR blocks allowed to access the public EKS API endpoint"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "enabled_cluster_log_types" {
  description = "EKS control plane log types"
  type        = list(string)

  default = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]
}

variable "enable_irsa" {
  description = "Create IAM OIDC provider for IRSA"
  type        = bool
  default     = true
}

variable "addon_versions" {
  description = "Optional EKS addon versions. Empty values let AWS select the compatible default version."
  type        = map(string)

  default = {
    coredns                = ""
    kube-proxy             = ""
    vpc-cni                = ""
    eks-pod-identity-agent = ""
  }
}

variable "tags" {
  description = "Tags applied to EKS resources"
  type        = map(string)
  default     = {}
}



