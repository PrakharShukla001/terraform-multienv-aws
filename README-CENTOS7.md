# 🚀 Terraform Multi-Env AWS — CentOS 7 Setup Guide
**By Prakhar Shukla | DevOps Engineer | 3.2 Years Experience**

---

## 📦 Package Contents

```
terraform-centos7/
├── 📁 terraform-multienv-aws/     ← Saara Terraform code
│   ├── modules/
│   │   ├── vpc/                   ← VPC, Subnets, NAT, Routes
│   │   ├── eks/                   ← EKS Cluster + IAM
│   │   ├── rds/                   ← RDS MySQL
│   │   ├── alb/                   ← Load Balancer
│   │   └── security-groups/       ← All Security Groups
│   ├── environments/
│   │   ├── dev/                   ← Dev (t3.small, cheap)
│   │   ├── staging/               ← Staging (t3.medium)
│   │   └── prod/                  ← Prod (t3.large, HA)
│   ├── jenkins/
│   │   └── Jenkinsfile            ← Jenkins pipeline
│   └── .github/workflows/
│       └── terraform.yml          ← GitHub Actions
├── 📁 docs/
│   └── terraform-architecture.html ← Architecture diagram (open in browser)
└── 📁 scripts/
    ├── install-tools-centos7.sh   ← Saare tools ek saath install
    ├── setup-backend.sh           ← S3 + DynamoDB setup
    └── deploy.sh                  ← Easy deploy script
```

---

## ⚡ Quick Start — CentOS 7

### Step 1: Tools Install Karo
```bash
chmod +x scripts/install-tools-centos7.sh
sudo ./scripts/install-tools-centos7.sh
```

### Step 2: AWS Configure Karo
```bash
aws configure
# AWS Access Key ID:     AKIA...
# AWS Secret Access Key: xxxx...
# Default region:        ap-south-1
# Output format:         json
```

### Step 3: S3 Backend Setup (Sirf ek baar)
```bash
chmod +x scripts/setup-backend.sh
./scripts/setup-backend.sh
```

### Step 4: Deploy Karo!
```bash
chmod +x scripts/deploy.sh

# Dev plan (preview)
./scripts/deploy.sh dev plan

# Dev apply (create)
./scripts/deploy.sh dev apply

# Staging apply
./scripts/deploy.sh staging apply

# Prod (manual approval required)
./scripts/deploy.sh prod apply
```

---

## 🔧 Manual Commands (bina script ke)

```bash
cd terraform-multienv-aws/environments/dev

# Init
terraform init

# Plan
terraform plan -var-file=terraform.tfvars

# Apply
terraform apply -var-file=terraform.tfvars

# Destroy
terraform destroy -var-file=terraform.tfvars
```

---

## ✏️ Kya Update Karna Hai

### 1. DB Password Change Karo (environments/*/terraform.tfvars)
```hcl
db_password = "YourStrongPassword@123!"
```

### 2. AWS Account ID (environments/staging + prod)
```hcl
aws_account_id = "123456789012"   # aapka AWS account ID
acm_cert_arn   = "arn:aws:acm:ap-south-1:123456789012:certificate/xxxx"
```

### 3. S3 Bucket Name (environments/*/main.tf)
```hcl
backend "s3" {
  bucket = "your-unique-bucket-name"   # globally unique hona chahiye
}
```

---

## 🌍 Environment Details

| | Dev | Staging | Prod |
|---|---|---|---|
| VPC | 10.0.0.0/16 | 10.1.0.0/16 | 10.2.0.0/16 |
| EKS Node | t3.small x1 | t3.medium x2 | t3.large x3 |
| RDS | db.t3.micro | db.t3.small | db.t3.medium |
| Multi-AZ | ❌ | ❌ | ✅ |
| Cost/mo | ~$45 | ~$110 | ~$270 |

---

## 📊 Architecture Diagram

```
docs/terraform-architecture.html
```
👆 **Browser mein open karo** — poora AWS architecture dikh jayega!

---

## ⚠️ CentOS 7 Notes

```
✅ Terraform   — yum se install hoga (HashiCorp repo)
✅ AWS CLI v2  — curl se download hoga
✅ kubectl     — curl se download hoga
✅ Git         — yum se install hoga
⚠️ CentOS 7 EOL June 2024 — production ke liye Rocky Linux 9 better hai
```

---

## 🔁 Git Push Karo

```bash
cd terraform-multienv-aws

git init
git add .
git commit -m "feat: terraform multi-env IaC — dev/staging/prod"

# GitHub pe repo banao phir:
git remote add origin https://github.com/PrakharShukla001/terraform-multienv-aws.git
git branch -M main
git push -u origin main
```

---

## 👨‍💻 Author
**Prakhar Shukla** | prakharshuklatech@gmail.com
GitHub: [PrakharShukla001](https://github.com/PrakharShukla001)
