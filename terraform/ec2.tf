# get the latest Amazon Linux 2023 AMI ID from parameter store
# (see https://docs.aws.amazon.com/linux/al2023/ug/ec2.html#launch-via-aws-cli)
data "aws_ssm_parameter" "al2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

resource "aws_instance" "default" {
  instance_type = var.instance_type
  ami           = data.aws_ssm_parameter.al2023.value
  key_name      = "vockey"
  tags = {
    Name = "workhorse"
  }
  user_data                   = templatefile("userdata.sh", { "account_id" : data.aws_caller_identity.current.account_id, "region" : data.aws_region.current.name })
  user_data_replace_on_change = true
  vpc_security_group_ids      = [aws_security_group.instance.id]
  subnet_id                   = data.aws_subnets.default.ids[0]
  iam_instance_profile        = aws_iam_instance_profile.default.name
}

data "aws_vpc" "default" {
  default = true
}

# security group for instances
resource "aws_security_group" "instance" {
  name   = "webserver-${terraform.workspace}"
  vpc_id = data.aws_vpc.default.id
}

# allow all outbound traffic
resource "aws_security_group_rule" "egress" {
  security_group_id = aws_security_group.instance.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "allow all outbound traffic (${terraform.workspace})"
}

# allow incoming SSH from anywhere
resource "aws_security_group_rule" "ssh" {
  security_group_id = aws_security_group.instance.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "allow SSH connections from anywhere (${terraform.workspace})"
}

# allow port 5000 which is where the flask app listens
resource "aws_security_group_rule" "flask" {
  security_group_id = aws_security_group.instance.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 5000
  to_port           = 5000
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "allow connections from anywhere to port 5000 (${terraform.workspace})"
}

# create instance profile for lab role
resource "aws_iam_instance_profile" "default" {
  name = "LabRole"
  role = "LabRole"
}