# **Project: Implement VPC Peering and Cloud Router**

---

## **Objective**
Set up VPC peering between two VPCs and use Cloud Router for dynamic route advertisement, enabling seamless cross-VPC communication. Configure appropriate firewall rules to control traffic and test connectivity between resources in both VPCs.

---

## **Steps to Implement**

---

### **Step 1: Create Two VPCs**
1. Navigate to **VPC Networks** in the **Google Cloud Console**.
2. **Create VPC 1**:
   - **Name**: `vpc-1`.
   - **Subnets**: Choose **Custom**.
   - Add a subnet:
     - Name: `subnet-1`.
     - Region: `us-central1`.
     - IP Range: `10.1.0.0/16`.
       
3. **Create VPC 2**:
   - **Name**: `vpc-2`.
   - **Subnets**: Choose **Custom**.
   - Add a subnet:
     - Name: `subnet-2`.
     - Region: `europe-west1`.
     - IP Range: `10.2.0.0/16`.

<img width="710" alt="image" src="https://github.com/user-attachments/assets/8162c89e-7612-4a21-9118-586832c03458">

---

### **Step 2: Set Up VPC Peering**
1. Go to **VPC Network Peering** → **Create Connection**.
2. **Create a Peering Connection for VPC 1**:
   - **Name**: `peering-1-to-2`.
   - **Network**: `vpc-1`.
   - **Peered Network**: Select `vpc-2`.
   - **Auto-Create Routes**: Enabled.
3. **Create a Peering Connection for VPC 2**:
   - **Name**: `peering-2-to-1`.
   - **Network**: `vpc-2`.
   - **Peered Network**: Select `vpc-1`.
   - **Auto-Create Routes**: Enabled.

Verify the status of the peering connections. They should show as **Active**.

<img width="734" alt="image" src="https://github.com/user-attachments/assets/7d19ae5a-d434-484d-8b51-f1aa698cdec9">


---

### **Step 3: Set Up Cloud Router for Dynamic Routing**
1. Navigate to **Cloud Router** → **Create Router**.
2. **Create a Router for VPC 1**:
   - **Name**: `router-1`.
   - **Network**: `vpc-1`.
   - **Region**: `us-central1`.
3. **Create a Router for VPC 2**:
   - **Name**: `router-2`.
   - **Network**: `vpc-2`.
   - **Region**: `europe-west1`.

<img width="745" alt="image" src="https://github.com/user-attachments/assets/51181e37-01f8-4d4f-95bf-d3bf35f26147">


---

### **Step 4: Configure Firewall Rules**
1. Go to **Firewall Rules** → **Create Firewall Rule**.
2. **Allow Traffic Between VPCs**:
   - **Name**: `allow-vpc-traffic`.
   - **Network**: Select each VPC (`vpc-1` and `vpc-2`) and create identical rules.
   - **Source Filter**: `IP ranges`.
   - **Source IP Ranges**: `10.0.0.0/8` (or specify the IP ranges of each VPC).
   - **Protocols and Ports**: Allow **TCP, UDP, ICMP**.

<img width="661" alt="image" src="https://github.com/user-attachments/assets/04bef179-717a-4f46-93b0-414c4808ff39">

---

### **Step 5: Launch VMs in Each VPC**
1. Navigate to **Compute Engine** → **VM Instances** → **Create Instance**.
2. **VM in VPC 1**:
   - Name: `vm-vpc-1`.
   - Region: `us-central1`.
   - Subnet: `subnet-1`.
   - Assign a **static internal IP**: `10.1.0.2'.
3. **VM in VPC 2**:
   - Name: `vm-vpc-2`.
   - Region: `europe-west1`.
   - Subnet: `subnet-2`.
   - Assign a **static internal IP**: `10.2.0.10`.

<img width="724" alt="image" src="https://github.com/user-attachments/assets/2bd612e0-0693-4ba1-9643-34f8e7e0607a">

---

### **Step 6: Test Connectivity**
1. SSH into the VM in **VPC 1**:
   ```bash
   gcloud compute ssh vm-vpc-1
   ```
2. Test connectivity to the VM in **VPC 2**:
   - **Ping**:
     ```bash
     ping 10.2.0.10
     ```
   - **SSH**:
     ```bash
     ssh <username>@10.2.0.10
     ```
<img width="410" alt="image" src="https://github.com/user-attachments/assets/9d199829-2f08-4223-8cba-50693c4afc67">
<img width="469" alt="image" src="https://github.com/user-attachments/assets/a9d8835b-3c32-4efd-9203-a86e145f1ac2">

     
3. If connectivity fails, verify:
   - Firewall rules.
   - Route tables in both VPCs.

---

## **Results**
- Successfully set up VPC peering and enabled communication between two VPCs.
- Dynamic routing is handled by Cloud Router.
- Verified connectivity using `ping` and `ssh`.

---

## **Skills Demonstrated**
- **VPC Peering**: Connected two VPCs for seamless communication. Understand that vpc cannot communicate without peering.
- **Cloud Router**: Configured dynamic route advertisement.
- **Firewall Rules**: Controlled and secured inter-VPC traffic.
- **Cross-VPC Communication**: Verified connectivity between resources.

---

## **Future Enhancements**
- Automate VPC and resource creation using **Terraform** or **Deployment Manager**.
- Use **Cloud VPN** or **Cloud Interconnect** for hybrid cloud scenarios.
- Implement more granular firewall rules for better security.

## **Conclusion**
This project demonstrates a practical implementation of **VPC peering** and **Cloud Router** for dynamic routing. It highlights core networking and security concepts in GCP.

