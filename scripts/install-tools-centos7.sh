
#!/bin/bash
# ═══════════════════════════════════════════════════════════════
#  CentOS 7 — Complete DevOps Tools Setup Script 
#  Author: Prakhar Shukla | prakharshuklatech@gmail.com
#  Fix: wget --show-progress removed (CentOS 7 old wget)
#  Fix: HashiCorp repo removed (CentOS 7 not supported)
# ═══════════════════════════════════════════════════════════════

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}"
echo "╔══════════════════════════════════════════════════╗"
echo "║   CentOS 7 DevOps Tools Installer                ║"
echo "║   Terraform + AWS CLI + kubectl + Git            ║"
echo "╚══════════════════════════════════════════════════╝"
echo -e "${NC}"

# Step 1: Remove Broken HashiCorp Repo
echo -e "${YELLOW}[1/7] Broken HashiCorp repo is removing....${NC}"
yum-config-manager --disable hashicorp 2>/dev/null || true
rm -f /etc/yum.repos.d/hashicorp.repo
echo -e "${GREEN}✅ Broken repo removed!${NC}"

# Step 2: Basic Packages
echo -e "${YELLOW}[2/7] Basic packages are installing ....${NC}"
yum install -y \
    git wget curl unzip vim nano \
    python3 python3-pip yum-utils \
    bash-completion openssl
echo -e "${GREEN}✅ Basic packages are installed!${NC}"

# Step 3: Terraform Binary Install
echo -e "${YELLOW}[3/7] Terraform binary is downloading...${NC}"
echo "Please wait, ~25MB download is going on..."

TERRAFORM_VERSION="1.6.6"
cd /tmp

wget -q \
    https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    -O terraform.zip

echo "Download complete! Extracting..."
unzip -q terraform.zip
mv terraform /usr/local/bin/terraform
chmod +x /usr/local/bin/terraform
rm -f terraform.zip

terraform --version
echo -e "${GREEN}✅ Terraform ${TERRAFORM_VERSION} installed!${NC}"

# Step 4: AWS CLI v2
echo -e "${YELLOW}[4/7] AWS CLI v2 is installing .....${NC}"
echo "Please wait, ~50MB downloading ....."

cd /tmp
curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" \
    -o "awscliv2.zip"

echo "Download complete! Installing..."
unzip -q awscliv2.zip
./aws/install --update
rm -rf awscliv2.zip aws/

aws --version
echo -e "${GREEN}✅ AWS CLI v2 installed!${NC}"

# Step 5: kubectl
echo -e "${YELLOW}[5/7] kubectl is installing...${NC}"

cd /tmp
KUBECTL_VERSION="v1.28.0"
wget -q \
    "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" \
    -O kubectl

chmod +x kubectl
mv kubectl /usr/local/bin/kubectl

kubectl version --client
echo -e "${GREEN}✅ kubectl installed!${NC}"

# Step 6: Git Global Config
echo -e "${YELLOW}[6/7] Git configure ho raha hai...${NC}"

git config --global user.name "Prakhar Shukla"
git config --global user.email "prakharshuklatech@gmail.com"
git config --global init.defaultBranch main
git config --global color.ui auto
git config --global core.editor vim

git --version
echo -e "${GREEN}✅ Git configured!${NC}"

# Step 7: Final Verify
echo -e "${YELLOW}[7/7] All things are getting verified please wait .....${NC}"
echo ""
echo -e "${BLUE}════════════ INSTALLED VERSIONS ════════════${NC}"
echo -e "Git       : $(git --version)"
echo -e "Terraform : $(terraform --version | head -1)"
echo -e "AWS CLI   : $(aws --version 2>&1)"
echo -e "kubectl   : $(kubectl version --client --short 2>/dev/null || kubectl version --client)"
echo -e "${BLUE}════════════════════════════════════════════${NC}"

echo ""
echo -e "${GREEN}"
echo "╔══════════════════════════════════════════════════╗"
echo "║   ✅ All tools are installed !                   ║"
echo "║                                                  ║"
echo "║   NEXT STEPS:                                    ║"
echo "║   1.  aws configure                              ║"
echo "║   2.  ./scripts/setup-backend.sh                 ║"
echo "║   3.  ./scripts/deploy.sh dev plan               ║"
echo "╚══════════════════════════════════════════════════╝"
echo -e "${NC}"
