---
name: slack-notify
description: "作業完了時にSlackのIncoming Webhookで完了報告を送る。環境変数CLAUDE_SLACK_NOTIFY_WEBHOOK_URLが未設定なら何もしない。「Slack通知」「完了報告」で発動。"
user-invocable: true
allowed-tools: "Bash(~/.claude/skills/slack-notify/send.sh:*)"
---

# Slack Notify

作業内容を要約し、SlackのIncoming Webhookで完了報告を送信する。

## 前提条件

環境変数 `CLAUDE_SLACK_NOTIFY_WEBHOOK_URL` が設定されていること。

## 実行手順

### 1. 環境変数の確認

`CLAUDE_SLACK_NOTIFY_WEBHOOK_URL` が未設定または空の場合、何もせずに終了する。エラーメッセージもユーザーへの報告も出さない。即座にセッションに戻る。

### 2. 作業内容の要約

現在のセッションで行った作業を要約する。`$ARGUMENTS` が与えられている場合は、その内容をコンテキストとして使用する。

### 3. メッセージ組み立て

ヘッダ行は固定。本文は呼び出しコンテキストに応じて自由に構成する。

- ヘッダ: `:white_check_mark: *Claude Code 作業完了*`
- 本文: エージェントが状況に応じて構成する（何のタスクが完了したのか、結果がどうだったのかを完結にまとめる）
- 形式: Slack mrkdwn

### 4. メッセージ送信

スキルディレクトリ内の `send.sh` を使って送信する。

```bash
~/.claude/skills/slack-notify/send.sh "<組み立てたメッセージ>"
```

送信失敗時（非ゼロ終了）のみ、ユーザーに報告する。

## 制約

- Block Kitは使わない。`text`フィールドのみ使用する。
- メッセージは日本語で構成する。
- 秘密情報（トークン、パスワード、APIキー等）をメッセージに含めない。
