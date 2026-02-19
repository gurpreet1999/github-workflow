#!/bin/bash

ADMIN_SECRET_ID=$1
AWS_REGION=$2

echo "🔍 Fetching admin credentials from Secrets Manager..."

SECRET=$(aws secretsmanager get-secret-value \
  --secret-id "$ADMIN_SECRET_ID" \
  --region "$AWS_REGION" \
  --query 'SecretString' \
  --output text 2>&1)

if [ $? -ne 0 ]; then
  echo "──────────────────────────────────────"
  echo "❌ Failed to fetch admin credentials!"
  echo "   Secret ID : $ADMIN_SECRET_ID"
  echo "   Error     : $SECRET"
  echo ""
  echo "👉 Possible reasons:"
  echo "   1. Wrong ADMIN_SECRET_ID"
  echo "   2. EC2 missing IAM permission for Secrets Manager"
  echo "──────────────────────────────────────"
  exit 1
fi

ADMIN_USER=$(echo "$SECRET" | python3 -c "import sys,json; print(json.load(sys.stdin)['username'])")
ADMIN_PASS=$(echo "$SECRET" | python3 -c "import sys,json; print(json.load(sys.stdin)['password'])")

if [ -z "$ADMIN_USER" ] || [ -z "$ADMIN_PASS" ]; then
  echo "❌ Failed to parse admin credentials!"
  echo "👉 Make sure secret has 'username' and 'password' keys"
  exit 1
fi

cat > ~/client.properties << EOF
security.protocol=SASL_SSL
sasl.mechanism=SCRAM-SHA-512
sasl.jaas.config=org.apache.kafka.common.security.scram.ScramLoginModule required username="$ADMIN_USER" password="$ADMIN_PASS";
EOF

echo "✅ Admin credentials fetched and client.properties created!"