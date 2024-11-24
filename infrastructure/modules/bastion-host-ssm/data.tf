# This image contains SSM Agent which is necessary for the SSM Bastion Host Secure Connection.
# Otherwise, you need to make sure that the relevant AMI has SSM Agent installed on it.
data "aws_ami" "amazon_linux_2023" {
  most_recent      = true

  filter {
    name   = "name"
    values = ["al2023-ami-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "platform"
    values = ["amazon"]
  }
}