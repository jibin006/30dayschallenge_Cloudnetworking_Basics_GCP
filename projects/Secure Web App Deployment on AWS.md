# 🚀 Secure Web App Deployment on AWS

## 📌 Overview
This project involves deploying a secure web application on AWS using EC2 instances in private subnets, an Application Load Balancer (ALB), and AWS Systems Manager (SSM) for remote management. The setup ensures security by restricting direct internet access and allowing traffic only through the ALB.

---

## 🏗️ Project Steps

### **Project: Secure Cloud Infrastructure for a 3-Tier Web Application on AWS**  
Objective: Deploy a secure 3-tier architecture using AWS services, ensuring proper security with IAM policies, VPC segmentation, and security groups.  

---

## **📌 Step 1: Plan the Architecture**  
The 3-tier architecture consists of:  
1. **Presentation Layer (Frontend)**
   - A static website hosted in an **S3 bucket with CloudFront** for security and performance.
2. **Application Layer (Backend)**
   - Hosted on **AWS EC2 instances** in a private subnet, behind a load balancer.
3. **Data Layer (Database)**
   - A **RDS database** (PostgreSQL/MySQL) deployed in a separate private subnet.

🔹 **Security Measures:**  
✅ Use **VPC with public and private subnets**  
✅ Restrict direct access to backend and database layers  
✅ **IAM policies** to enforce least privilege access  
✅ **Security groups & NACLs** to control traffic  

---

## **📌 Step 2: Set Up the VPC (Networking Layer)**  
A Virtual Private Cloud (VPC) will allow us to isolate our resources securely.  

### **1️⃣ Create a VPC**  
- Login to **AWS Console** → **VPC Dashboard** → **Create VPC**  
- Name: `SecureVPC`  
- CIDR: `10.0.0.0/16`  

### **2️⃣ Create Subnets**  
- **Public Subnet** (for Load Balancer, NAT Gateway)  
  - CIDR: `10.0.1.0/24`  
- **Private Subnet 1** (for Backend EC2 Instances)  
  - CIDR: `10.0.2.0/24`  
- **Private Subnet 2** (for RDS Database)  
  - CIDR: `10.0.3.0/24`  

### **3️⃣ Set Up Internet Gateway & Route Tables**  
- Attach an **Internet Gateway (IGW)** to allow internet access for the public subnet.  
- Create **NAT Gateway** in the public subnet to allow private subnets to reach the internet.  
- Configure **Route Tables**:  
  - Public subnet → Routes to IGW  
  - Private subnet → Routes to NAT Gateway  

---

## **📌 Step 3: Deploy a Static Website on S3 with CloudFront**  
We will use **Amazon S3** to host the frontend.  

### **1️⃣ Create an S3 Bucket**  
- Go to **S3 Console** → **Create Bucket**  
- Name: `my-secure-website`  
- Disable public access (enable only via CloudFront).  

### **2️⃣ Enable Static Website Hosting**  
- Upload your HTML, CSS, and JS files.  
- Enable **static website hosting** under bucket properties.  

### **3️⃣ Set Up CloudFront (CDN) for Security**  
- Go to **CloudFront Console** → **Create Distribution**  
- Select **S3 Bucket** as origin  
- Restrict bucket access using an **Origin Access Control (OAC)**  
- Enable **HTTPS** and **WAF (Web Application Firewall)** for security  

---

## **📌 Step 4: Deploy EC2 Instances for Backend**  
We will launch EC2 instances in private subnets.  

### **1️⃣ Create a Security Group for EC2**
- Allow **only traffic from ALB (Application Load Balancer)**  
- Deny all direct internet access  

### **2️⃣ Launch EC2 Instance**  
- **Amazon Linux 2** as AMI  
- Private Subnet: `10.0.2.0/24`  
- Attach the security group  

### **3️⃣ Configure EC2 to Run a Web App**
```bash
sudo yum update -y
sudo yum install httpd -y
sudo systemctl start httpd
sudo systemctl enable httpd
echo "Welcome to Secure Web App" | sudo tee /var/www/html/index.html
```

---

## **📌 Step 5: Set Up RDS Database in Private Subnet**  
We will create an **Amazon RDS instance** for secure database storage.  

### **1️⃣ Create a Security Group for RDS**
- Allow **only EC2 instances in backend subnet** to access the database  
- Block all public access  

### **2️⃣ Launch an RDS Instance**  
- Go to **RDS Console** → **Create Database**  
- Engine: **PostgreSQL/MySQL**  
- Subnet Group: Select **private subnets**  
- Set up a **strong password**  

### **3️⃣ Connect Backend to Database**  
```bash
mysql -h <rds-endpoint> -u admin -p
```

---

## **📌 Step 6: Secure Everything with IAM**  
We will use **IAM roles and policies** to enforce security.  

### **1️⃣ Create an IAM Role for EC2**  
- Attach **AmazonS3ReadOnlyAccess** to allow EC2 to fetch frontend assets.  
- Attach **CloudWatchAgentServerPolicy** for monitoring.  

### **2️⃣ Create IAM Policies for Least Privilege**  
- Allow **S3 access only via CloudFront**  
- Restrict **RDS access to EC2 backend only**  

---

## **📌 Step 7: Automate Deployment Using Terraform (Optional)**  
To make the setup repeatable, use **Terraform** to deploy resources.  

Example Terraform Code for VPC:  
```hcl
resource "aws_vpc" "secure_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.secure_vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
}
```
---

## **📌 Step 8: Test the Deployment**
✅ **Test Website on CloudFront**  
✅ **Verify EC2 Application Access**  
✅ **Confirm RDS Connection**  
✅ **Check Security Groups & IAM Policies**  

---

## **📌 Step 9: Monitor and Improve Security**
🔹 Enable **AWS CloudTrail** to log all activity.  
🔹 Enable **AWS GuardDuty** for threat detection.  
🔹 Apply **AWS WAF** to CloudFront for security.  

---

### 🎯 **Outcome**  
✅ Securely deployed a **3-tier web application**  
✅ Implemented **IAM, VPC segmentation, security groups**  
✅ Enforced **best security practices** in AWS  

Let me know if you need help with any step! 🚀

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

❌ Issue 5: Access Denied when Accessing CloudFront URL
✅ Fix:
Ensure the OAC policy is correctly set (see bucket policy above).
Check CloudFront logs:
---
aws cloudfront get-distribution --id E2ASCAVMELXWUA
---

❌ Issue 6: https://d2vsgg3c1ktpks.cloudfront.net/ Shows Access Denied
✅ Fix: Set a Default Root Object
Go to CloudFront → Distribution → Edit Behavior
Set Default Root Object to website.html.

❌ Issue 7: aws s3api put-bucket-acl Fails Due to BlockPublicAcls
✅ Fix:
AWS blocks public ACLs by default. Instead, use OAC and update the bucket policy.

---

## 📚 Key Learnings
- **VPC Networking**: Configuring subnets, route tables, and NAT gateways.
- **EC2 Security Best Practices**: Restricting direct SSH and using SSM.
- **Application Load Balancer (ALB)**: Managing traffic securely.
- **AWS IAM Roles & Policies**: Granting least-privilege access.
- **Troubleshooting AWS Issues**: Debugging SSM connectivity and ALB routing problems.


---

## 📌 Next Steps
- Automate the entire deployment with **Terraform**.
- Implement **HTTPS with ACM** (AWS Certificate Manager).
- Add **Auto Scaling** to handle high traffic loads.

---

🎯 **This project helped me understand AWS networking, security best practices, and infrastructure automation.** 🚀
