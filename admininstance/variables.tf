variable "region" {
}

variable "remote_state_bucket_name" {
  description = "Terraform remote state bucket name"
}

variable "environment_type" {
  description = "environment"
}

variable "cloudwatch_log_retention" {
  description = "How ling to retain cloudwatch logs for BFS instances"
  default     = 7
}

variable "bfs_instance_type" {
  description = "Instance type for BFS instances"
  default     = "t2.xlarge"
}

variable "bfs_root_size" {
  description = "BFS Instance root volume size in GiB"
  default     = "75"
}

variable "bfs_server_count" {
  description = "Number of BFS Servers to deploy"
  default     = 1
}

variable "ebs_backup" {
  type = map(string)

  default = {
    schedule     = "cron(0 01 * * ? *)"
    delete_after = 15
  }
}

variable "environment_name" {
  type = string
}

variable "snap_tag" {
  default = "CreateSnapshotBFS"
}
