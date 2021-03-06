# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "cluster_id" {
  description = "The ECS cluster id that should run this service"
  type        = string
}

variable "container_definitions" {
  # Full documentation here: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/create-task-definition.html
  description = "JSON container definition."
  type        = string
}

variable "container_port" {
  description = "The port used by the web app within the container"
  type        = number
}

variable "service_name" {
  description = "The service name. Will also be used as Route53 DNS entry."
  type        = string
}

variable "vpc_id" {
  description = "VPC id where the load balancer and other resources will be deployed."
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "assign_public_ip" {
  default     = false
  description = "This services will be placed in a public subnet and be assigned a public routable IP."
  type        = bool
}

variable "container_name" {
  default     = ""
  description = "Defaults to var.service_name, can be overridden if it differs. Used as a target for LB."
  type        = string
}

/*
Supported task CPU and memory values for Fargate tasks are as follows.

CPU value 	    | Memory value (MiB)
-----------------------------------------------------------------------------------------------------
256 (.25 vCPU) 	| 512 (0.5GB), 1024 (1GB), 2048 (2GB)
512 (.5 vCPU) 	| 1024 (1GB), 2048 (2GB), 3072 (3GB), 4096 (4GB)
1024 (1 vCPU) 	| 2048 (2GB), 3072 (3GB), 4096 (4GB), 5120 (5GB), 6144 (6GB), 7168 (7GB), 8192 (8GB)
2048 (2 vCPU) 	| Between 4096 (4GB) and 16384 (16GB) in increments of 1024 (1GB)
4096 (4 vCPU) 	| Between 8192 (8GB) and 30720 (30GB) in increments of 1024 (1GB)
*/

variable "cpu" {
  default     = 256
  description = "Amount of CPU required by this service. 1024 == 1 vCPU"
  type        = number
}

variable "desired_count" {
  default     = 0
  description = "Desired count of services to be started/running."
  type        = number
}

variable "force_new_deployment" {
  default     = false
  description = "Enable to force a new task deployment of the service. This can be used to update tasks to use a newer Docker image with same image/tag combination (e.g. myimage:latest), roll Fargate tasks onto a newer platform version, or immediately deploy ordered_placement_strategy and placement_constraints updates."
  type        = bool
}

variable "health_check" {
  description = "A health block containing health check settings for the ALB target groups. See https://www.terraform.io/docs/providers/aws/r/lb_target_group.html#health_check for defaults."
  default     = {}
  type        = map(string)
}

variable "https_listener_rules" {
  description = "A list of maps describing the Listener Rules for this ALB. Required key/values: actions, conditions. Optional key/values: priority, https_listener_index (default to https_listeners[count.index])"
  type        = any
  default     = []
}

variable "memory" {
  default     = 512
  description = "Amount of memory [MB] is required by this service."
  type        = number
}

variable "platform_version" {
  default     = "LATEST"
  description = "The platform version on which to run your service. Defaults to LATEST."
  type        = string
}

variable "policy_document" {
  default     = ""
  description = "AWS Policy JSON describing the permissions required for this service."
  type        = string
}

variable "requires_compatibilities" {
  default     = ["EC2", "FARGATE"]
  description = "The launch type the task is using. This enables a check to ensure that all of the parameters used in the task definition meet the requirements of the launch type."
  type        = set(string)
}

variable "requires_internet_access" {
  default     = false
  description = "As Fargate does not support IPv6 yet, this is the only way to enable internet access for the service by placing it in a public subnet (but not assigning a public IP)."
  type        = bool
}

variable "target_groups" {
  description = "A list of maps containing key/value pairs that define the target groups to be created. Order of these maps is important and the index of these are to be referenced in listener definitions. Required key/values: name, backend_protocol, backend_port"
  type        = any
  default     = []
}

variable "subnet_ids" {
  default = []
}

variable "task_execution_role_arn" {
  default = ""
}

variable "sg_for_fargate" {
  default = ""
}

variable "env" {}

