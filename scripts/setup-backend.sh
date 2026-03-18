#!/bin/bash
# ═══════════════════════════════════════════════════════════════
#  S3 Backend + DynamoDB Lock Table Setup
#  Run this ONCE before terraform init
#  Author: Prakhar Shukla
# ═══════════════════════════════════════════════════════════════

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

BUCKET_NAME="prakhar-terraform-state"
TABLE_NAME="terraform-state-lock"
REGION="ap-south-1"

echo -e "${BLUE}[1/2] S3 bucket bana raha hoon: ${BUCKET_NAME}${NC}"

aws s3 mb s3://${BUCKET_NAME} --region ${REGION} 2>/dev/null || \
    echo "Bucket already exists, skipping..."

# Enable versioning
aws s3api put-bucket-versioning \
    --bucket ${BUCKET_NAME} \
    --versioning-configuration Status=Enabled

# Enable encryption
aws s3api put-bucket-encryption \
    --bucket ${BUCKET_NAME} \
    --server-side-encryption-configuration '{
        "Rules": [{
            "ApplyServerSideEncryptionByDefault": {
                "SSEAlgorithm": "AES256"
            }
        }]
    }'

echo -e "${GREEN}✅ S3 bucket ready!${NC}"

echo -e "${BLUE}[2/2] DynamoDB lock table bana raha hoon: ${TABLE_NAME}${NC}"

aws dynamodb create-table \
    --table-name ${TABLE_NAME} \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST \
    --region ${REGION} 2>/dev/null || \
    echo "Table already exists, skipping..."

echo -e "${GREEN}✅ DynamoDB table ready!${NC}"

echo ""
echo -e "${GREEN}"
echo "╔══════════════════════════════════════════════╗"
echo "║  ✅ Backend setup complete!                  ║"
echo "║                                              ║"
echo "║  Ab deploy karo:                             ║"
echo "║  $ ./scripts/deploy.sh dev plan              ║"
echo "║  $ ./scripts/deploy.sh dev apply             ║"
echo "╚══════════════════════════════════════════════╝"
echo -e "${NC}"
