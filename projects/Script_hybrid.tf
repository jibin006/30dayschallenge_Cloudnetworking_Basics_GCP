# Provider Configuration
provider "google" {
  project = var.project_id
  region  = var.region
}

# VPC for Cloud Network (Simulating Cloud Environment)
resource "google_compute_network" "cloud_network" {
  name                    = "cloud-network"
  auto_create_subnetworks = false
  routing_mode            = "GLOBAL"
}

# Subnet for Cloud Network
resource "google_compute_subnetwork" "cloud_subnet" {
  name          = "cloud-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = var.region
  network       = google_compute_network.cloud_network.id
}

# VPC for On-Premises Network (Simulated)
resource "google_compute_network" "onprem_network" {
  name                    = "onprem-network"
  auto_create_subnetworks = false
  routing_mode            = "GLOBAL"
}

# Subnet for On-Premises Network
resource "google_compute_subnetwork" "onprem_subnet" {
  name          = "onprem-subnet"
  ip_cidr_range = "192.168.1.0/24"
  region        = var.region
  network       = google_compute_network.onprem_network.id
}

# Firewall Rules for Cloud Network
resource "google_compute_firewall" "cloud_firewall" {
  name    = "cloud-network-allow-internal"
  network = google_compute_network.cloud_network.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "3389"]
  }

  source_ranges = ["10.0.1.0/24", "192.168.1.0/24"]
}

# Firewall Rules for On-Premises Network
resource "google_compute_firewall" "onprem_firewall" {
  name    = "onprem-network-allow-internal"
  network = google_compute_network.onprem_network.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "3389"]
  }

  source_ranges = ["10.0.1.0/24", "192.168.1.0/24"]
}

# External IP for VPN Gateway (Cloud Network)
resource "google_compute_address" "cloud_vpn_ip" {
  name   = "cloud-vpn-ip"
  region = var.region
}

# External IP for VPN Gateway (On-Premises Network)
resource "google_compute_address" "onprem_vpn_ip" {
  name   = "onprem-vpn-ip"
  region = var.region
}

# Cloud VPN Gateway
resource "google_compute_vpn_gateway" "cloud_vpn_gateway" {
  name    = "cloud-vpn-gateway"
  network = google_compute_network.cloud_network.id
  region  = var.region
}

# On-Premises VPN Gateway
resource "google_compute_vpn_gateway" "onprem_vpn_gateway" {
  name    = "onprem-vpn-gateway"
  network = google_compute_network.onprem_network.id
  region  = var.region
}

# Forwarding Rules for Cloud VPN
resource "google_compute_forwarding_rule" "cloud_esp" {
  name        = "cloud-vpn-esp"
  region      = var.region
  ip_protocol = "ESP"
  ip_address  = google_compute_address.cloud_vpn_ip.address
  target      = google_compute_vpn_gateway.cloud_vpn_gateway.id
}

resource "google_compute_forwarding_rule" "cloud_udp500" {
  name        = "cloud-vpn-udp500"
  region      = var.region
  ip_protocol = "UDP"
  port_range  = "500"
  ip_address  = google_compute_address.cloud_vpn_ip.address
  target      = google_compute_vpn_gateway.cloud_vpn_gateway.id
}

resource "google_compute_forwarding_rule" "cloud_udp4500" {
  name        = "cloud-vpn-udp4500"
  region      = var.region
  ip_protocol = "UDP"
  port_range  = "4500"
  ip_address  = google_compute_address.cloud_vpn_ip.address
  target      = google_compute_vpn_gateway.cloud_vpn_gateway.id
}

# Forwarding Rules for On-Premises VPN
resource "google_compute_forwarding_rule" "onprem_esp" {
  name        = "onprem-vpn-esp"
  region      = var.region
  ip_protocol = "ESP"
  ip_address  = google_compute_address.onprem_vpn_ip.address
  target      = google_compute_vpn_gateway.onprem_vpn_gateway.id
}

resource "google_compute_forwarding_rule" "onprem_udp500" {
  name        = "onprem-vpn-udp500"
  region      = var.region
  ip_protocol = "UDP"
  port_range  = "500"
  ip_address  = google_compute_address.onprem_vpn_ip.address
  target      = google_compute_vpn_gateway.onprem_vpn_gateway.id
}

resource "google_compute_forwarding_rule" "onprem_udp4500" {
  name        = "onprem-vpn-udp4500"
  region      = var.region
  ip_protocol = "UDP"
  port_range  = "4500"
  ip_address  = google_compute_address.onprem_vpn_ip.address
  target      = google_compute_vpn_gateway.onprem_vpn_gateway.id
}

# VPN Tunnels
resource "google_compute_vpn_tunnel" "cloud_to_onprem" {
  name          = "cloud-to-onprem-tunnel"
  peer_ip       = google_compute_address.onprem_vpn_ip.address
  shared_secret = var.vpn_shared_secret

  target_vpn_gateway = google_compute_vpn_gateway.cloud_vpn_gateway.id

  remote_traffic_selector = ["192.168.1.0/24"]
  local_traffic_selector  = ["10.0.1.0/24"]

  depends_on = [
    google_compute_forwarding_rule.cloud_esp,
    google_compute_forwarding_rule.cloud_udp500,
    google_compute_forwarding_rule.cloud_udp4500
  ]
}

resource "google_compute_vpn_tunnel" "onprem_to_cloud" {
  name          = "onprem-to-cloud-tunnel"
  peer_ip       = google_compute_address.cloud_vpn_ip.address
  shared_secret = var.vpn_shared_secret

  target_vpn_gateway = google_compute_vpn_gateway.onprem_vpn_gateway.id

  remote_traffic_selector = ["10.0.1.0/24"]
  local_traffic_selector  = ["192.168.1.0/24"]

  depends_on = [
    google_compute_forwarding_rule.onprem_esp,
    google_compute_forwarding_rule.onprem_udp500,
    google_compute_forwarding_rule.onprem_udp4500
  ]
}

# Routing for Cloud Network
resource "google_compute_route" "cloud_to_onprem" {
  name        = "cloud-to-onprem-route"
  network     = google_compute_network.cloud_network.name
  dest_range  = "192.168.1.0/24"
  next_hop_vpn_tunnel = google_compute_vpn_tunnel.cloud_to_onprem.id
  priority    = 1000
}

# Routing for On-Premises Network
resource "google_compute_route" "onprem_to_cloud" {
  name        = "onprem-to-cloud-route"
  network     = google_compute_network.onprem_network.name
  dest_range  = "10.0.1.0/24"
  next_hop_vpn_tunnel = google_compute_vpn_tunnel.onprem_to_cloud.id
  priority    = 1000
}

# Variables
variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "us-central1"
}

variable "vpn_shared_secret" {
  description = "Shared secret for VPN connection"
  type        = string
}

# Outputs
output "cloud_vpn_ip" {
  value = google_compute_address.cloud_vpn_ip.address
}

output "onprem_vpn_ip" {
  value = google_compute_address.onprem_vpn_ip.address
}
