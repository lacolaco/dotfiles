#!/usr/bin/env bash
set -euo pipefail

# Usage: ./fetch-unresolved-threads.sh <PR_NUMBER>
# Fetches unresolved review threads from a GitHub PR via GraphQL API.
# Requires: gh (authenticated), jq

PR_NUMBER="${1:?Usage: $0 <PR_NUMBER>}"

OWNER="$(gh repo view --json owner -q '.owner.login')"
REPO="$(gh repo view --json name -q '.name')"

RESPONSE="$(gh api graphql -f query='
query($owner: String!, $repo: String!, $number: Int!) {
  repository(owner: $owner, name: $repo) {
    pullRequest(number: $number) {
      reviewThreads(first: 100) {
        nodes {
          id
          isResolved
          isOutdated
          path
          line
          comments(first: 10) {
            nodes {
              id
              databaseId
              author { login }
              body
              createdAt
            }
          }
        }
      }
    }
  }
}' -f owner="$OWNER" -f repo="$REPO" -F number="$PR_NUMBER")"

# Check for GraphQL errors
if echo "$RESPONSE" | jq -e '.errors' > /dev/null 2>&1; then
  echo "GraphQL error:" >&2
  echo "$RESPONSE" | jq '.errors' >&2
  exit 1
fi

echo "$RESPONSE" | jq '[
  .data.repository.pullRequest.reviewThreads.nodes[]
  | select(.isResolved == false)
  | {
      threadId: .id,
      outdated: .isOutdated,
      path: .path,
      line: .line,
      firstComment: {
        databaseId: .comments.nodes[0].databaseId,
        author: .comments.nodes[0].author.login,
        body: .comments.nodes[0].body
      },
      replies: [.comments.nodes[1:][] | {author: .author.login, body: .body}]
    }
]'
