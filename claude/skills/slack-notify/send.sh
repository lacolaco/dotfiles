#!/usr/bin/env bash
set -euo pipefail

# Usage: send.sh <message>
# Env: CLAUDE_SLACK_NOTIFY_WEBHOOK_URL

if [[ -z "${CLAUDE_SLACK_NOTIFY_WEBHOOK_URL:-}" ]]; then
  exit 0
fi

MESSAGE="${1:?Usage: send.sh <message>}"

HTTP_STATUS=$(jq -n --arg text "$MESSAGE" '{"text": $text}' | \
  curl -s -o /dev/null -w "%{http_code}" -X POST "$CLAUDE_SLACK_NOTIFY_WEBHOOK_URL" \
    -H "Content-Type: application/json" -d @-)

if [[ "$HTTP_STATUS" != "200" ]]; then
  echo "Error: Slack webhook returned HTTP $HTTP_STATUS" >&2
  exit 1
fi
