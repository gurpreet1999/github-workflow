#!/bin/bash

USERNAME=$1
AWS_REGION=$2
CLUSTER_ARN=$3

echo "🔍 Checking if '$USERNAME' is associated with MSK cluster..."

SECRET_ARN=$(aws secretsmanager describe-secret \
  --secret-id "msk/users/$USERNAME" \
  --region "$AWS_REGION" \
  --query 'ARN' \
  --output text 2>&1)

if [ $? -ne 0 ]; then
  echo "❌ Failed to get Secret ARN for user '$USERNAME'"
  exit 1
fi

ASSOCIATED=$(aws kafka list-scram-secrets \
  --cluster-arn "$CLUSTER_ARN" \
  --region "$AWS_REGION" \
  --query 'SecretArnList' \
  --output text 2>&1 | grep "$SECRET_ARN" || true)

if [ -z "$ASSOCIATED" ]; then
  echo "──────────────────────────────────────"
  echo "❌ User '$USERNAME' is NOT associated with MSK!"
  echo ""
  echo "👉 Next Steps:"
  echo "   Please contact Admin to associate user with MSK"
  echo "   Secret ARN: $SECRET_ARN"
  echo "──────────────────────────────────────"
  exit 1
fi

echo "✅ User '$USERNAME' is associated with MSK cluster!"