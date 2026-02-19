#!/bin/bash
set -e

TOPIC_NAME=$1
BOOTSTRAP_BROKER=$2

echo "🔍 Checking topic '$TOPIC_NAME' in MSK..."

TOPIC_EXISTS=$(kafka-topics.sh \
  --bootstrap-server "$BOOTSTRAP_BROKER" \
  --command-config ~/client.properties \
  --list | grep -w "$TOPIC_NAME" || true)

if [ -z "$TOPIC_EXISTS" ]; then
  echo "❌ Topic '$TOPIC_NAME' does NOT exist in MSK!"
  exit 1
fi

echo "✅ Topic '$TOPIC_NAME' found in MSK!"