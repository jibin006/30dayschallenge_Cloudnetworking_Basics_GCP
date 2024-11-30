# **Multi-Region VPC Setup in Google Cloud**

## **Project Objective**
This project demonstrates how to set up a multi-region Virtual Private Cloud (VPC) in Google Cloud Platform (GCP). It includes creating subnets across different regions, setting up firewall rules, launching VM instances, and testing cross-region communication.

---

## **Project Architecture**

### **High-Level Overview**
- **VPC**: A single Virtual Private Cloud spans multiple regions.
- **Subnets**:
  - **US Region**: `us-central1`, IP range `10.0.1.0/24`.
  - **Europe Region**: `europe-west1`, IP range `10.0.2.0/24`.
- **VM Instances**:
  - VM in the US region with static IP `10.0.1.10`.
  - VM in the Europe region with static IP `10.0.2.10`.
- **Firewall Rules**: Allow internal communication between resources.

---

## **Steps to Implement**

### **1. Create the VPC**
1. Navigate to **VPC Networks** in the Google Cloud Console.
2. Click **Create VPC network** and configure:
   - Name: `multi-region-vpc`.
  <img width="773" alt="image" src="https://github.com/user-attachments/assets/bfde60c4-ecb8-4eee-af5d-b17d1d2b916d">

   - Subnets: **Custom**.
3. Add subnets:
   - **Subnet 1**:
     - Name: `us-subnet`.
     - Region: `us-central1`.
     - IP Range: `10.0.1.0/24`.
   - **Subnet 2**:
     - Name: `europe-subnet`.
     - Region: `europe-west1`.
     - IP Range: `10.0.2.0/24`.
<img width="536" alt="image" src="https://github.com/user-attachments/assets/0b36e4c9-15a8-46ae-8145-5e91b969a850">

---

### **2. Configure Firewall Rules**
1. Go to **VPC Network** → **Firewall Rules** → **Create Firewall Rule**.
2. Create a rule to allow internal communication:
   - **Name**: `allow-internal-traffic`.
   - **VPC**: `multi-region-vpc`.
   - **Targets**: All instances in the network.
   - **Source Filter**: `IP ranges`.
   - **Source IP Ranges**: `10.0.0.0/16`.
   - **Protocols and Ports**: Allow **TCP, UDP, ICMP**.
<img width="704" alt="image" src="https://github.com/user-attachments/assets/98244abf-5abc-4649-8981-c7833cc7c7fa">


---

### **3. Launch VM Instances**
1. Navigate to **Compute Engine** → **VM Instances** → **Create Instance**.
2. Create two VM instances:
   - **VM 1 (US Region)**:
     - Name: `vm-us`.
     - Region: `us-central1`.
     - Subnet: `us-subnet`.
     - Static IP: `10.0.1.10`.
   - **VM 2 (Europe Region)**:
     - Name: `vm-europe`.
     - Region: `europe-west1`.
     - Subnet: `europe-subnet`.
     - Static IP: `10.0.2.10`.
<img width="748" alt="image" src="https://github.com/user-attachments/assets/b097d472-8fbc-4280-b16f-dabb4e45bf82">

---

### **4. Test Connectivity**
1. SSH into one of the VMs:
   ```bash
   gcloud compute ssh vm-us
   ```
2. Test connectivity to the other VM using `ping`:
   ```bash
   ping 10.0.2.10
   ```
3. Verify SSH connectivity:
   ```bash
   ssh <username>@10.0.2.10
   ```
<img width="445" alt="image" src="https://github.com/user-attachments/assets/34c423c0-ad82-4887-b91d-12651b1c8dac">
<img width="410" alt="image" src="https://github.com/user-attachments/assets/b62e78d5-a133-4d9d-874b-61085c528a14">

---

## **Results**
- Successfully established a multi-region VPC with subnets in different regions.
- Verified connectivity between VM instances using `ping` and `ssh`.
- Ensured secure internal communication with firewall rules.

---

## **Key Learnings**
- **VPC Setup**: Configuring custom VPCs and subnets.
- **Cross-Region Networking**: Enabling seamless communication between geographically dispersed resources.
- **Firewall Rules**: Managing security at the network layer.
- **Static IP Configuration**: Assigning and managing static IPs for consistent communication.

---

## **Future Enhancements**
- Automate VPC and VM creation using **Terraform** or **GCP SDK**.
- Add more regions and subnets for scalability.
- Explore using **Cloud Router** for dynamic routing between regions.

```

## **Conclusion**
This project showcases the foundational skills needed to set up a scalable, multi-region network in Google Cloud. It provides a strong understanding of subnetting, cross-region networking, and firewall configurations.

---
