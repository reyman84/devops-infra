resource "aws_instance" "this" {
  count                  = var.instance_count
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.subnet_ids[count.index % length(var.subnet_ids)]
  vpc_security_group_ids = var.security_group_ids
  associate_public_ip_address = true

  # Only set IAM instance profile if provided
  iam_instance_profile = var.iam_instance_profile != null ? var.iam_instance_profile : null

  tags = merge(
    {
      Name = "${var.name}-${count.index + 1}"
    },
    var.tags
  )

  user_data = var.user_data

  dynamic "root_block_device" {
    for_each = var.root_block_device != null ? [var.root_block_device] : []
    content {
      volume_size           = root_block_device.value.volume_size
      volume_type           = root_block_device.value.volume_type
      delete_on_termination = true
    }
  }

  dynamic "ebs_block_device" {
    for_each = var.ebs_block_devices
    content {
      device_name           = ebs_block_device.value.device_name
      volume_size           = ebs_block_device.value.volume_size
      volume_type           = ebs_block_device.value.volume_type
      delete_on_termination = true
    }
  }
}
