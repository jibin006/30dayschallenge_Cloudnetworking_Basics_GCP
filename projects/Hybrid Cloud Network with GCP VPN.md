# Hybrid Cloud Network with GCP VPN using terraform

## 🌐 Project Overview

This project demonstrates a robust hybrid cloud networking solution using Google Cloud Platform (GCP) and Terraform, simulating a secure connection between a cloud network and an on-premises network.

### 🎯 Project Objectives
- Implement a Cloud VPN between two simulated networks
- Demonstrate hybrid cloud connectivity
- Use Infrastructure as Code (Terraform) for deployment
- Showcase network security and routing configurations

## 🛠 Technologies Used
- Google Cloud Platform (GCP)
- Terraform
- IPsec VPN
- Network Routing
- Firewall Configuration

## 📐 Network Architecture

### Network Details
- **Cloud Network**: 
  - CIDR: 10.0.1.0/24
  - Region: us-central1

- **On-Premises Network**:
  - CIDR: 192.168.1.0/24
  - Region: us-central1

## 🚀 Key Features
- Bi-directional VPN tunnel
- Secure IPsec connection
- Dynamic routing configuration
- Firewall rule management
- Infrastructure as Code deployment

## 📦 Prerequisites
- Google Cloud Platform account
- Terraform (>= 0.13)
- GCloud CLI
- Google Cloud SDK

## 🔧 Installation and Setup

### 1. Script



```

### 2. Configure Variables
Create a `terraform.tfvars` file:
```hcl
project_id        = "your-gcp-project-id"
region            = "us-central1"
vpn_shared_secret = "your-secure-vpn-shared-secret"
```

### 3. Initialize Terraform
```bash
terraform init
```

### 4. Plan the Deployment
```bash
terraform plan
```

### 5. Apply the Configuration
```bash
terraform apply
```

## 🧪 Connectivity Testing
After deployment, verify the VPN tunnel:
1. Create test VMs in each network
2. Use `ping` or `traceroute`
3. Verify traffic between networks

## 🔒 Security Considerations
- Used shared secret for VPN authentication
- Implemented network-level firewall rules
- Restricted traffic using traffic selectors
- Used minimal necessary open ports

## 📊 Network Topology
```
[Cloud Network: 10.0.1.0/24]  <--VPN Tunnel-->  [On-Premises Network: 192.168.1.0/24]
        |                                               |
    VPN Gateway                                   VPN Gateway
        |                                               |
    Firewall Rules                              Firewall Rules
```

## 🚧 Potential Improvements
- Implement more granular firewall rules
- Add network logging
- Create a bastion host
- Explore VPC peering alternatives

## 📝 Lessons Learned
- Importance of secure network design
- Challenges in hybrid cloud connectivity
- Infrastructure as Code best practices

## 📌 Troubleshooting
- Verify GCP credentials
- Check network connectivity
- Ensure firewall rules are correctly configured
- Validate Terraform state

## 🤝 Contributing
1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a new Pull Request

## 📜 License
This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## 📚 References
- [Terraform GCP Provider Documentation](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
- [GCP VPN Documentation](https://cloud.google.com/network-connectivity/docs/vpn)

---

**Disclaimer**: This is a simulated hybrid network setup for learning purposes.
