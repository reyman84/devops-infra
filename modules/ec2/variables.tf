variable "name" {
  type = string
}

variable "instance_count" {
  type    = number
  default = 1
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "key_name" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "security_group_ids" {
  type = list(string)
}

variable "iam_instance_profile" {
  type    = string
  default = null
}

variable "user_data" {
  type    = string
  default = null
}

variable "root_block_device" {
  type = object({
    volume_size = number
    volume_type = string
  })
  default = null
}

variable "ebs_block_devices" {
  type = list(object({
    device_name = string
    volume_size = number
    volume_type = string
  }))
  default = []
}

variable "root_volume_size" {
  type    = number
  default = 8
}

variable "tags" {
  type    = map(string)
  default = {}
}
