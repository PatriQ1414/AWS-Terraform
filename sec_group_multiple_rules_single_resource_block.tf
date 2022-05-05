################################################
# Create ingress rule for multiple IP addresses
################################################

resource "aws_security_group" "main" {
  name     = "Main_SG"
  vpc_id   = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#########################
# multiple IP
#########################

variable "client_ip" {
  type    = list(string)
  default = ["10.10.10.1/16", "10.10.10.2/32", "10.10.10.3/16", "10.10.10.10.4/32"]
}

resource "aws_security_group_rule" "client_ip" {
  for_each          = toset(var.client_ip)
  type              = "ingress"
  from_port         = 123
  to_port           = 123
  protocol          = "tcp"
  cidr_blocks       = [each.value]
  security_group_id = aws_security_group.main.id
  description       = "Test multiple IP address ingress"

}


###########################################################
# for different to and from ports and different CIDR blocks
##########################################################

locals {
  sg_rule = [
    {
      from_port                = 123
      to_port                  = 456
      cidr_blocks              = ["10.10.10.1/16"]
      description              = "SecurityGroup Rule 1"
    },
    {
      from_port                = 789
      to_port                  = 112
      cidr_blocks              = ["10.10.10.2/16"]
      description              = "SecurityGroup Rule 1"
    },
    {
      from_port                = 131
      to_port                  = 415
      cidr_blocks              = ["10.10.10.3/16"]
      description              = "SecurityGroup Rule 1"
    }
    ]
    
    }
    
  resource "aws_security_group_rule" "client_ip" {
    for_each          = { for index, from_port in local.sg_rule : index => from_port }
    type              = "ingress"
    from_port         = each.value.from_port
    to_port           = each.value.to_port
    protocol          = "tcp"
    cidr_blocks       = each.value.cidr_blocks
    security_group_id = aws_security_group.main.id
    description       = each.value.description

}
    
    
