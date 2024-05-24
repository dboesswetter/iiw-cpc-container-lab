resource "aws_security_group" "http" {
  name   = "http_for_alb"
  vpc_id = data.aws_vpc.default.id
}

resource "aws_security_group_rule" "http" {
  security_group_id = aws_security_group.http.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "allow HTTP from everywhere"
}
