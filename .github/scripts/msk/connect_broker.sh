#!/bin/bash

BOOTSTRAP_BROKER=$1

echo "🔍 Trying to connect to MSK broker..."
echo "   Broker: $BOOTSTRAP_BROKER"

# Test connection by listing topics
RESULT=$(kafka-topics.sh \
  --bootstrap-server "$BOOTSTRAP_BROKER" \
  --command-config ~/client.properties \
  --list 2>&1)

EXIT_CODE=$?

if [ $EXIT_CODE -ne 0 ]; then
  echo "❌ Failed to connect to MSK broker!"
  echo "──────────────────────────────────"
  echo "Error Details:"
  echo "$RESULT"
  echo "──────────────────────────────────"
  echo "Possible reasons:"
  echo "  1. Wrong bootstrap broker URL"
  echo "  2. Security group not allowing port 9096"
  echo "  3. client.properties not created yet"
  echo "  4. Wrong admin credentials"
  exit 1
fi

echo "✅ Successfully connected to MSK broker!"
echo "──────────────────────────────────"
echo "📋 Topics found:"
echo "$RESULT"
echo "──────────────────────────────────"
echo "Total topics: $(echo "$RESULT" | wc -l)"