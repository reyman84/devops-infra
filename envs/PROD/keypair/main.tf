# Create a production key pair
resource "aws_key_pair" "prod" {
  key_name   = "prod_key"
  public_key = file("${path.module}/prod_key.pub")

  tags = {
    Name  = "prod_key"
    Scope = "production"
  }
}

