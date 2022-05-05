locals {
  customer_onprem_ip = "10.10.10.1"
  customer_azure_ip  = "10.10.10.2"
  main_cidr          = "20.20.20.1"

}

resource "aws_vpn_gateway" "vpn_gateway" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Test-VPN-Gateway"
  }
}

resource "aws_customer_gateway" "customer_gateway_onprem" {
  bgp_asn    = 65000
  ip_address = local.customer_onprem_ip
  type       = "ipsec.1"

  tags = {
    Name = "Test-Onprem-Gateway"
  }
}

resource "aws_customer_gateway" "customer_gateway_azure" {
  bgp_asn    = 65000
  ip_address = local.customer_azure_ip
  type       = "ipsec.1"

  tags = {
    Name = "Test-Azure-Gateway"
  }
}

resource "aws_vpn_connection" "onprem" {
  vpn_gateway_id                       = aws_vpn_gateway.vpn_gateway.id
  customer_gateway_id                  = aws_customer_gateway.customer_gateway_onprem.id
  type                                 = "ipsec.1"
  static_routes_only                   = true
  remote_ipv4_network_cidr             = local.main_cidr
  tunnel1_ike_versions                 = ["ikev2"]
  tunnel1_phase1_dh_group_numbers      = ["19", "20", "21"]
  tunnel1_phase1_encryption_algorithms = ["AES256", "AES256-GCM-16"]
  tunnel1_phase1_integrity_algorithms  = ["SHA2-256", "SHA2-384", "SHA2-512"]
  tunnel1_phase2_dh_group_numbers      = ["19", "20", "21"]
  tunnel1_phase2_encryption_algorithms = ["AES256", "AES256-GCM-16"]
  tunnel1_phase2_integrity_algorithms  = ["SHA2-256", "SHA2-384", "SHA2-512"]
  tunnel2_ike_versions                 = ["ikev2"]
  tunnel2_phase1_dh_group_numbers      = ["19", "20", "21"]
  tunnel2_phase1_encryption_algorithms = ["AES256", "AES256-GCM-16"]
  tunnel2_phase1_integrity_algorithms  = ["SHA2-256", "SHA2-384", "SHA2-512"]
  tunnel2_phase2_dh_group_numbers      = ["19", "20", "21"]
  tunnel2_phase2_encryption_algorithms = ["AES256", "AES256-GCM-16"]
  tunnel2_phase2_integrity_algorithms  = ["SHA2-256", "SHA2-384", "SHA2-512"]

  tags = {
    Name = "Test-Onprem-Connection"
  }
}

resource "aws_vpn_connection" "azure" {
  vpn_gateway_id                       = aws_vpn_gateway.vpn_gateway.id
  customer_gateway_id                  = aws_customer_gateway.customer_gateway_azure.id
  type                                 = "ipsec.1"
  static_routes_only                   = true
  remote_ipv4_network_cidr             = local.main_cidr
  tunnel1_ike_versions                 = ["ikev2"]
  tunnel1_phase1_dh_group_numbers      = ["19", "20", "21"]
  tunnel1_phase1_encryption_algorithms = ["AES256", "AES256-GCM-16"]
  tunnel1_phase1_integrity_algorithms  = ["SHA2-256", "SHA2-384", "SHA2-512"]
  tunnel1_phase2_dh_group_numbers      = ["19", "20", "21"]
  tunnel1_phase2_encryption_algorithms = ["AES256", "AES256-GCM-16"]
  tunnel1_phase2_integrity_algorithms  = ["SHA2-256", "SHA2-384", "SHA2-512"]
  tunnel2_ike_versions                 = ["ikev2"]
  tunnel2_phase1_dh_group_numbers      = ["19", "20", "21"]
  tunnel2_phase1_encryption_algorithms = ["AES256", "AES256-GCM-16"]
  tunnel2_phase1_integrity_algorithms  = ["SHA2-256", "SHA2-384", "SHA2-512"]
  tunnel2_phase2_dh_group_numbers      = ["19", "20", "21"]
  tunnel2_phase2_encryption_algorithms = ["AES256", "AES256-GCM-16"]
  tunnel2_phase2_integrity_algorithms  = ["SHA2-256", "SHA2-384", "SHA2-512"]

  tags = {
    Name = "Test-Azure-Coonnection"
  }
}

##OnPrem VPN Routes

variable "onprem_ip" {
  type = list(string)
  default = ["12.13.14.15/24", "10.11.12.0/24", "13.14.15.16.0/24", "17.18.19.9.0/24", "21.22.23.1.0/22"
  ]
}

resource "aws_vpn_connection_route" "onprem" {
  for_each          = toset(var.onprem_ip)
  destination_cidr_block = each.value
  vpn_connection_id      = aws_vpn_connection.onprem.id
}


##Azure VPN Routes

variable "azure_ip" {
  type = list(string)
  default = ["11.12.13.14.0/25", "16.17.16.19/32"
  ]
}

resource "aws_vpn_connection_route" "azure" {
  for_each          = toset(var.azure_ip)
  destination_cidr_block = each.value
  vpn_connection_id      = aws_vpn_connection.azure.id
}
