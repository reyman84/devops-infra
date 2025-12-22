resource "aws_key_pair" "dev" {
  key_name   = "devops_project"
  public_key = file("${path.module}/devops_project.pub")

  tags = {
    Name = "dev_key"
    Scope = "global"
  }
}

