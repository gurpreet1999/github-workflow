#!/bin/bash

TOPIC_NAME=$1
BOOTSTRAP_BROKER=$2

echo "🔍 Verifying ACL on topic '$TOPIC_NAME'..."

RESULT=$(kafka-acls.sh \
  --bootstrap-server "$BOOTSTRAP_BROKER" \
  --command-config ~/client.properties \
  --list \
  --topic "$TOPIC_NAME" 2>&1)

echo "──────────────────────────────────────"
echo "📋 ACLs on topic '$TOPIC_NAME':"
echo "$RESULT"
echo "──────────────────────────────────────"
echo "✅ Verification Complete!"