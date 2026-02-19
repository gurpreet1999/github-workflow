#!/bin/bash
set -e

AWS_REGION=$1
ADMIN_SECRET_ID=$2   # e.g. msk/users/admin

echo "🔍 Fetching admin credentials from Secrets Manager..."

# Fetch secret
SECRET=$(aws secretsmanager get-secret-value \
  --secret-id "$ADMIN_SECRET_ID" \
  --region "$AWS_REGION" \
  --query 'SecretString' \
  --output text)

if [ $? -ne 0 ]; then
  echo "❌ Failed to fetch admin credentials!"
  exit 1
fi

# Parse username and password
ADMIN_USER=$(echo "$SECRET" | python3 -c "import sys,json; print(json.load(sys.stdin)['username'])")
ADMIN_PASS=$(echo "$SECRET" | python3 -c "import sys,json; print(json.load(sys.stdin)['password'])")

echo "✅ Admin credentials fetched!"

# Create client.properties
cat > ~/client.properties << EOF
security.protocol=SASL_SSL
sasl.mechanism=SCRAM-SHA-512
sasl.jaas.config=org.apache.kafka.common.security.scram.ScramLoginModule required \
  username="$ADMIN_USER" \
  password="$ADMIN_PASS";
EOF

echo "✅ client.properties created!"