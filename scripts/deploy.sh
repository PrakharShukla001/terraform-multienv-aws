#!/bin/bash
# ═══════════════════════════════════════════════════════════════
#  CentOS 7 — Complete DevOps Tools Setup Script (FIXED)
#  Terraform binary install (HashiCorp repo CentOS 7 pe kaam nahi karta)
#  Author: Prakhar Shukla | prakharshuklatech@gmail.com
# ═══════════════════════════════════════════════════════════════

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}"
echo "╔══════════════════════════════════════════════════╗"
echo "║   CentOS 7 DevOps Tools Installer (FIXED)        ║"
echo "║   Terraform + AWS CLI + kubectl + Git            ║"
echo "╚══════════════════════════════════════════════════╝"
echo -e "${NC}"

# ─────────────────────────────────────────
# Step 1: Remove broken HashiCorp repo
# ─────────────────────────────────────────
echo -e "${YELLOW}[1/7] Broken HashiCorp repo hata raha hoon...${NC}"
yum-config-manager --disable hashicorp 2>/dev/null || true
rm -f /etc/yum.repos.d/hashicorp.repo
echo -e "${GREEN}✅ Broken repo removed!${NC}"

# ─────────────────────────────────────────
# Step 2: System Update + Basic Packages
# ─────────────────────────────────────────
echo -e "${YELLOW}[2/7] Basic packages install ho rahe hain...${NC}"
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
    bash-completion \
    openssl

echo -e "${GREEN}✅ Basic packages installed!${NC}"

# ─────────────────────────────────────────
# Step 3: Terraform — Binary Install
# (HashiCorp repo CentOS 7 support band ho gaya)
# ─────────────────────────────────────────
echo -e "${YELLOW}[3/7] Terraform binary download ho raha hai...${NC}"

TERRAFORM_VERSION="1.6.6"
cd /tmp

wget -q --show-progress \
    https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    -O terraform.zip

unzip -q terraform.zip
mv terraform /usr/local/bin/terraform
chmod +x /usr/local/bin/terraform
rm -f terraform.zip

terraform --version
echo -e "${GREEN}✅ Terraform ${TERRAFORM_VERSION} installed!${NC}"

# ─────────────────────────────────────────
# Step 4: AWS CLI v2
# ─────────────────────────────────────────
echo -e "${YELLOW}[4/7] AWS CLI v2 install ho raha hai...${NC}"

cd /tmp
curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -q awscliv2.zip
./aws/install --update
rm -rf awscliv2.zip aws/

aws --version
echo -e "${GREEN}✅ AWS CLI v2 installed!${NC}"

# ─────────────────────────────────────────
# Step 5: kubectl
# ─────────────────────────────────────────
echo -e "${YELLOW}[5/7] kubectl install ho raha hai...${NC}"

cd /tmp
KUBECTL_VERSION="v1.28.0"
curl -sLO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
chmod +x kubectl
mv kubectl /usr/local/bin/kubectl

kubectl version --client
echo -e "${GREEN}✅ kubectl installed!${NC}"

# ─────────────────────────────────────────
# Step 6: Git Config
# ─────────────────────────────────────────
echo -e "${YELLOW}[6/7] Git configure ho raha hai...${NC}"

git config --global user.name "Prakhar Shukla"
git config --global user.email "prakharshuklatech@gmail.com"
git config --global init.defaultBranch main
git config --global color.ui auto
git config --global core.editor vim

git --version
echo -e "${GREEN}✅ Git configured!${NC}"

# ─────────────────────────────────────────
# Step 7: Verify All
# ─────────────────────────────────────────
echo -e "${YELLOW}[7/7] Sab verify ho raha hai...${NC}"
echo ""
echo -e "${BLUE}════════ INSTALLED VERSIONS ════════${NC}"
echo -e "Git       : $(git --version)"
echo -e "Terraform : $(terraform --version | head -1)"
echo -e "AWS CLI   : $(aws --version 2>&1)"
echo -e "kubectl   : $(kubectl version --client --short 2>/dev/null || kubectl version --client)"
echo -e "${BLUE}════════════════════════════════════${NC}"

echo ""
echo -e "${GREEN}"
echo "╔══════════════════════════════════════════════════╗"
echo "║   ✅ Sab tools install ho gaye!                  ║"
echo "║                                                  ║"
echo "║   Ab yeh steps follow karo:                      ║"
echo "║                                                  ║"
echo "║   1. aws configure                               ║"
echo "║   2. ./scripts/setup-backend.sh                  ║"
echo "║   3. ./scripts/deploy.sh dev plan                ║"
echo "╚══════════════════════════════════════════════════╝"
echo -e "${NC}"
