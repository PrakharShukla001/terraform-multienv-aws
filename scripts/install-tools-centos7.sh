#!/bin/bash
# ═══════════════════════════════════════════════════════════════
#  CentOS 7 — Complete DevOps Tools Setup Script
#  Project 1: Terraform Multi-Environment AWS
#  Author: Prakhar Shukla | prakharshuklatech@gmail.com
# ═══════════════════════════════════════════════════════════════

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}"
echo "╔══════════════════════════════════════════════════╗"
echo "║   CentOS 7 DevOps Tools Installer                ║"
echo "║   Terraform + AWS CLI + kubectl + Git            ║"
echo "╚══════════════════════════════════════════════════╝"
echo -e "${NC}"

# ─────────────────────────────────────────
# Step 1: System Update + Basic Packages
# ─────────────────────────────────────────
echo -e "${YELLOW}[1/6] System update aur basic packages install ho rahe hain...${NC}"
yum update -y
yum install -y \
    git \
    wget \
    curl \
    unzip \
    vim \
    nano \
    python3 \
    python3-pip \
    yum-utils \
    bash-completion

echo -e "${GREEN}✅ Basic packages installed!${NC}"

# ─────────────────────────────────────────
# Step 2: Terraform Install
# ─────────────────────────────────────────
echo -e "${YELLOW}[2/6] Terraform install ho raha hai...${NC}"

yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
yum install -y terraform

terraform --version
echo -e "${GREEN}✅ Terraform installed!${NC}"

# ─────────────────────────────────────────
# Step 3: AWS CLI v2 Install
# ─────────────────────────────────────────
echo -e "${YELLOW}[3/6] AWS CLI v2 install ho raha hai...${NC}"

cd /tmp
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -q awscliv2.zip
./aws/install --update
rm -rf awscliv2.zip aws/

aws --version
echo -e "${GREEN}✅ AWS CLI v2 installed!${NC}"

# ─────────────────────────────────────────
# Step 4: kubectl Install
# ─────────────────────────────────────────
echo -e "${YELLOW}[4/6] kubectl install ho raha hai...${NC}"

KUBECTL_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt)
curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
chmod +x kubectl
mv kubectl /usr/local/bin/kubectl

kubectl version --client
echo -e "${GREEN}✅ kubectl installed!${NC}"

# ─────────────────────────────────────────
# Step 5: Git Config
# ─────────────────────────────────────────
echo -e "${YELLOW}[5/6] Git configure ho raha hai...${NC}"

git config --global user.name "Prakhar Shukla"
git config --global user.email "prakharshuklatech@gmail.com"
git config --global init.defaultBranch main
git config --global color.ui auto

git --version
echo -e "${GREEN}✅ Git configured!${NC}"

# ─────────────────────────────────────────
# Step 6: Verify All Tools
# ─────────────────────────────────────────
echo -e "${YELLOW}[6/6] Sab kuch verify ho raha hai...${NC}"
echo ""
echo -e "${BLUE}════════ INSTALLED VERSIONS ════════${NC}"
echo -e "Git:       $(git --version)"
echo -e "Terraform: $(terraform --version | head -1)"
echo -e "AWS CLI:   $(aws --version)"
echo -e "kubectl:   $(kubectl version --client --short 2>/dev/null || kubectl version --client)"
echo -e "${BLUE}════════════════════════════════════${NC}"

echo ""
echo -e "${GREEN}"
echo "╔══════════════════════════════════════════════════╗"
echo "║   ✅ Sab tools install ho gaye!                  ║"
echo "║                                                  ║"
echo "║   Ab yeh run karo:                               ║"
echo "║   $ aws configure                                ║"
echo "║   $ cd terraform-multienv-aws/environments/dev  ║"
echo "║   $ terraform init                               ║"
echo "║   $ terraform plan -var-file=terraform.tfvars   ║"
echo "╚══════════════════════════════════════════════════╝"
echo -e "${NC}"
