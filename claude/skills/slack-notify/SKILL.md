---
name: slack-notify
description: "WHEN: PROACTIVELY after completing a substantial task (PR merge, feature implementation, bug fix, investigation)—invoke WITHOUT waiting for user request. SKIP for trivial/instant tasks (typo fix, single-line change, quick question answer, config tweak). Also invokable manually via /slack-notify. Sends a completion notification to Slack via Incoming Webhook. Does nothing if CLAUDE_SLACK_NOTIFY_WEBHOOK_URL is not set."
user-invocable: true
allowed-tools: "Bash(~/.claude/skills/slack-notify/send.sh)"
---

# Slack Notify

作業内容を要約し、SlackのIncoming Webhookで完了報告を送信する。

## 前提条件

環境変数 `CLAUDE_SLACK_NOTIFY_WEBHOOK_URL` が設定されていること。

## 実行手順

### 1. 環境変数の確認

`CLAUDE_SLACK_NOTIFY_WEBHOOK_URL` が未設定または空の場合、何もせずに終了する。エラーメッセージもユーザーへの報告も出さない。即座にセッションに戻る。

### 2. メッセージ送信

スキルディレクトリ内の `send.sh` を実行する。メッセージはスクリプト内に固定されている。

```bash
~/.claude/skills/slack-notify/send.sh
```

送信失敗時（非ゼロ終了）のみ、ユーザーに報告する。

## 制約

- Block Kitは使わない。`text`フィールドのみ使用する。
- メッセージは日本語で構成する。
- 秘密情報（トークン、パスワード、APIキー等）をメッセージに含めない。
