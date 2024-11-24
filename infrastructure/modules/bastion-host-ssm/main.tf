resource "aws_instance" "this" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = "t2.micro"
  subnet_id              = var.subnet_id
  security_groups        = var.security_groups
  iam_instance_profile   = aws_iam_instance_profile.this.id
  associate_public_ip_address = false
}


resource "aws_iam_instance_profile" "this" {
  name = "${var.resource_name_prefix}-bastion-profile-${var.environment}"
  role = aws_iam_role.this.name
}

resource "aws_iam_role" "this" {
  name = "${var.resource_name_prefix}-bastion-role-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy_attachment" "this" {
  name       = "${var.resource_name_prefix}-bastion-ssm-policy-${var.environment}"
  roles      = [aws_iam_role.this.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
}