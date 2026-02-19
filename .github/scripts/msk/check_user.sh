#!/bin/bash
set -e

USERNAME=$1
AWS_REGION=$2

echo "🔍 Checking user '$USERNAME' in Secrets Manager..."

aws secretsmanager get-secret-value \
  --secret-id "msk/users/$USERNAME" \
  --region "$AWS_REGION" \
  --query 'SecretString' \
  --output text > /dev/null 2>&1

if [ $? -ne 0 ]; then
  echo "❌ User '$USERNAME' NOT found in Secrets Manager!"
  exit 1
fi

echo "✅ User '$USERNAME' found in Secrets Manager!"