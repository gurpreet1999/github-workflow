#!/bin/bash

USERNAME=$1
TOPIC_NAME=$2
PERMISSION=$3
BOOTSTRAP_BROKER=$4

echo "⚙️ Applying ACL on topic..."

kafka-acls.sh \
  --bootstrap-server "$BOOTSTRAP_BROKER" \
  --command-config ~/client.properties \
  --add \
  --allow-principal "User:$USERNAME" \
  --operation "$PERMISSION" \
  --topic "$TOPIC_NAME" 2>&1

if [ $? -ne 0 ]; then
  echo "──────────────────────────────────────"
  echo "❌ Failed to apply ACL!"
  echo "──────────────────────────────────────"
  exit 1
fi

echo "──────────────────────────────────────"
echo "✅ ACL Applied Successfully!"
echo "   User       : $USERNAME"
echo "   Topic      : $TOPIC_NAME"
echo "   Permission : $PERMISSION"
echo "──────────────────────────────────────"