# 🚀 Secure Web App Deployment on AWS

## 📌 Overview
This project involves deploying a secure web application on AWS using EC2 instances in private subnets, an Application Load Balancer (ALB), and AWS Systems Manager (SSM) for remote management. The setup ensures security by restricting direct internet access and allowing traffic only through the ALB.

---

## 🏗️ Project Steps

### **Step 1: Setup VPC and Networking**
- Created a **VPC** with public and private subnets.
- Configured an **Internet Gateway** for public access.
- Set up **NAT Gateway** for private instances to access the internet.
- Defined **Route Tables** to control traffic flow.

### **Step 2: Deploy ALB (Application Load Balancer)**
- Created a **Target Group** for backend EC2 instances.
- Configured an **ALB Security Group** to allow inbound HTTP (port 80) traffic.
- Set up **Listeners & Rules** to route traffic to the backend.

### **Step 3: Deploy EC2 Instances for Backend**
- Created an **EC2 Security Group** to allow traffic only from the ALB.
- Launched an **Amazon Linux 2** EC2 instance in a private subnet.
- Installed and configured **Apache Web Server** (`httpd`).

```bash
sudo yum update -y
sudo yum install httpd -y
sudo systemctl start httpd
sudo systemctl enable httpd
echo "Welcome to Secure Web App" | sudo tee /var/www/html/index.html
```

### **Step 4: Secure Access using AWS Systems Manager (SSM)**
- Verified **SSM Agent** installation on EC2 (Amazon Linux 2 has it by default).
- Attached an **IAM Role** with the `AmazonSSMManagedInstanceCore` policy to the instance.
- Used **SSM Session Manager** to connect to the EC2 instance securely (instead of SSH).

```bash
aws ssm start-session --target <Instance-ID>
```

### **Step 5: Verify Application Access**
- **From EC2 instance:**
  ```bash
  curl http://localhost
  ```
- **From another instance in the same VPC:**
  ```bash
  curl http://<Private-IP>
  ```
- **From ALB:**
  ```bash
  curl http://<ALB-DNS-Name>
  ```
- **From Browser:** Open `http://<ALB-DNS-Name>`

---

## 🛠 Challenges Faced & Solutions

### **1️⃣ Issue: SSH Access to Private EC2 Failed**
**Cause:** The instance was in a private subnet without direct internet access.
**Solution:** Used AWS Systems Manager Session Manager (SSM) for remote access instead of SSH.

### **2️⃣ Issue: SSM Agent Not Connecting**
**Cause:** Missing IAM Role with required permissions.
**Solution:** Attached `AmazonSSMManagedInstanceCore` policy to the EC2 instance IAM role.

### **3️⃣ Issue: ALB Not Routing Traffic to EC2**
**Cause:** Security group restrictions or missing target group registration.
**Solution:** Ensured EC2 security group allows traffic from ALB and registered the EC2 instance in the target group.

### **4️⃣ Issue: "Access Denied" on CloudFront URL**
**Cause:** Missing bucket policy for public access.
**Solution:** Updated S3 bucket policy to allow read access.

---

## 📚 Key Learnings
- **VPC Networking**: Configuring subnets, route tables, and NAT gateways.
- **EC2 Security Best Practices**: Restricting direct SSH and using SSM.
- **Application Load Balancer (ALB)**: Managing traffic securely.
- **AWS IAM Roles & Policies**: Granting least-privilege access.
- **Troubleshooting AWS Issues**: Debugging SSM connectivity and ALB routing problems.

---

## 📂 Directory Structure
```
aws-web-app/
├── terraform/        # Terraform code for infrastructure provisioning
├── scripts/          # Shell scripts for EC2 setup
├── docs/             # Documentation & architecture diagrams
├── README.md         # Project Documentation (This file)
```

---

## 📌 Next Steps
- Automate the entire deployment with **Terraform**.
- Implement **HTTPS with ACM** (AWS Certificate Manager).
- Add **Auto Scaling** to handle high traffic loads.

---

🎯 **This project helped me understand AWS networking, security best practices, and infrastructure automation.** 🚀
