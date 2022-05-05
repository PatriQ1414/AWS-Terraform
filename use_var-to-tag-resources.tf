###############################
# Declare variables
##############################

variable "test_suffix" {
  description = "Suffix to append to Test resources"
  type        = string
  default     = "Test"
}

variable "vpn_suffix" {
  description = "VPN tag suffix"
  type        = string
  default     = "VPN"
}

variable "cnx_suffix" {
  description = "Connection Suffix to append to Test resources"
  type        = string
  default     = "Connection"
}

variable "gateway_suffix" {
  description = "Gateway Suffix to append to Test resources"
  type        = string
  default     = "Gateway"
}


resource "aws_vpn_gateway" "vpn_gateway" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = format("%s-%s-%s-%s", var.test_suffix, var.vpn_suffix, var.cnx_suffix, var.gateways_suffix)
  }
}

######################################################
# This will append the following tags on the resource
# "Test-VPN-Connection-Gateway"
#####################################################