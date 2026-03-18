#!/bin/bash
# ═══════════════════════════════════════════════════════════════
#  CentOS 7 — Terraform Deploy Script
#  Usage: ./deploy.sh [dev|staging|prod] [plan|apply|destroy]
#  Author: Prakhar Shukla
# ═══════════════════════════════════════════════════════════════

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

ENVIRONMENT=$1
ACTION=$2

# ─────────────────────────────────────────
# Validate inputs
# ─────────────────────────────────────────
if [[ -z "$ENVIRONMENT" || -z "$ACTION" ]]; then
    echo -e "${RED}Usage: ./deploy.sh [dev|staging|prod] [plan|apply|destroy]${NC}"
    echo ""
    echo "Examples:"
    echo "  ./deploy.sh dev plan"
    echo "  ./deploy.sh dev apply"
    echo "  ./deploy.sh staging apply"
    echo "  ./deploy.sh prod plan"
    exit 1
fi

if [[ "$ENVIRONMENT" != "dev" && "$ENVIRONMENT" != "staging" && "$ENVIRONMENT" != "prod" ]]; then
    echo -e "${RED}❌ Invalid environment: $ENVIRONMENT${NC}"
    echo "Valid: dev | staging | prod"
    exit 1
fi

if [[ "$ACTION" != "plan" && "$ACTION" != "apply" && "$ACTION" != "destroy" ]]; then
    echo -e "${RED}❌ Invalid action: $ACTION${NC}"
    echo "Valid: plan | apply | destroy"
    exit 1
fi

# ─────────────────────────────────────────
# Safety check — no destroy on prod
# ─────────────────────────────────────────
if [[ "$ENVIRONMENT" == "prod" && "$ACTION" == "destroy" ]]; then
    echo -e "${RED}❌ PROD pe DESTROY allowed nahi hai!${NC}"
    exit 1
fi

# ─────────────────────────────────────────
# Prod approval gate
# ─────────────────────────────────────────
if [[ "$ENVIRONMENT" == "prod" && "$ACTION" == "apply" ]]; then
    echo -e "${YELLOW}⚠️  PRODUCTION pe deploy karne wale ho!${NC}"
    echo -e "${YELLOW}Kya aap sure ho? (yes/no):${NC}"
    read CONFIRM
    if [[ "$CONFIRM" != "yes" ]]; then
        echo -e "${RED}Deploy cancelled!${NC}"
        exit 0
    fi
fi

# ─────────────────────────────────────────
# Run Terraform
# ─────────────────────────────────────────
TF_DIR="terraform-multienv-aws/environments/${ENVIRONMENT}"

echo -e "${BLUE}"
echo "╔══════════════════════════════════════╗"
echo "║  Environment : ${ENVIRONMENT^^}"
echo "║  Action      : ${ACTION^^}"
echo "╚══════════════════════════════════════╝"
echo -e "${NC}"

echo -e "${YELLOW}📁 Moving to: ${TF_DIR}${NC}"
cd $TF_DIR

echo -e "${YELLOW}⚙️  terraform init...${NC}"
terraform init

echo -e "${YELLOW}✅ terraform validate...${NC}"
terraform validate

if [[ "$ACTION" == "plan" ]]; then
    echo -e "${YELLOW}📋 terraform plan...${NC}"
    terraform plan -var-file=terraform.tfvars

elif [[ "$ACTION" == "apply" ]]; then
    echo -e "${YELLOW}🚀 terraform apply...${NC}"
    terraform apply -var-file=terraform.tfvars -auto-approve
    echo ""
    echo -e "${GREEN}📤 Outputs:${NC}"
    terraform output

elif [[ "$ACTION" == "destroy" ]]; then
    echo -e "${YELLOW}💥 terraform destroy...${NC}"
    terraform destroy -var-file=terraform.tfvars -auto-approve
fi

echo -e "${GREEN}✅ Done! ${ENVIRONMENT} ${ACTION} complete!${NC}"
