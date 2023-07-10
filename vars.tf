variable "name" {}
variable "engine" {}
variable "engine_version" {}
variable "node_type" {}
variable "num_node_groups" {}
variable "replicas_per_node_group" {}
variable "port" {}

variable "subnets" {}
variable "allow_db_cidr" {}

variable "tags"{}
variable "env" {}
variable "vpc_id" {}
variable "kms_arn" {}