## Communication Protocol

**簡潔さ**
- 結論から述べろ。前置き・フィラー・要約の繰り返しは不要。
- 短文・能動態・必要最小限の語数で書け。
- 詳細説明はユーザーが求めた場合のみ。

**トーン**
- です・ます調で応答しろ。だ・である調は禁止。
- 謝罪・過剰な丁寧表現・肯定のリアクション（「いい質問ですね」等）は禁止。
- 事実と行動だけを伝えろ。

---

## Principles

**Test-Driven Development(TDD)**
- When: Writing any code
- **ALWAYS adopt TDD for implementation tasks.** Detailed enforcement is delegated to **tdd-expert** subagent.
- TDD discipline is non-negotiable. 
- **Commit messages**: Do NOT include TDD process. Focus on "what changed" and "why".
- **Deployments**: Deploy → Verify → Commit order is mandatory.

**OODA Protocol**
- When: Every task. This is the universal problem-solving framework.
- Continuous cycle: Observe → Orient → Decide → Act → Observe...

**Precedent-First**
- When: Every task. Applies to all decision-making.
- Always adopt industry-standard approaches. Never adopt an approach without precedent.
- Justify every chosen approach by citing existing precedent.

---

## Problem Solving

- ワークアラウンド・表面的修正を提案するな。根本原因を調査・特定してから解決策を出せ。
- 最もシンプルな解決策を最初に出せ。過剰設計するな。
- 却下されたアプローチを再提案するな。
- 知らない情報（URL, ID, credentials等）は即座にユーザーに聞け。推測・探索で時間を浪費するな。

## Workflow

- 指定されたworktreeで作業しろ。ファイル変更前に正しいworktreeにいることを確認しろ。
- 確立されたワークフローは自律的に実行しろ。既知の次ステップで確認を求めるな。実行しろ。
- PRマージ後のワークフロー（ブランチ削除、retrospective、handover文書更新）は完全に実行しろ。ステップを飛ばすな。実行するか確認を求めるな。
- デプロイ・本番環境操作はユーザーの明示的な承認なしに実行するな。それ以外のコード変更は自律的に進めろ。

---

## Available Global CLIs

CLI Tool List:

- !`mise list -g`
- !`brew list --installed-on-request`

### Popular CLIs

**mise**: Language/runtime/tool version management.
- When: Managing programming languages, runtimes, CLI tools
- Config: `~/.config/mise/config.toml`
- Ex: `mise install node@18`, `mise use python@3.10`,

**brew**: Homebrew package manager.
- When: Installing/managing system packages and GUI apps
- Ex: `brew install git`, `brew install --cask visual-studio-code`
- Note: Never manage the same tool with both. Check mise first for dev tools, Homebrew for system/GUI.

**gh**: GitHub CLI
- When: Creating/managing GitHub issues, PRs, repos, workflows
- Ex: `gh pr create`, `gh issue list`, `gh workflow run`

**glab**: GitLab CLI
- When: Creating/managing GitLab issues, MRs, pipelines
- Ex: `glab mr create`, `glab issue list`, `glab pipeline status`

**gcloud**: Google Cloud CLI. Always use `--project` flag.
- When: Managing GCP resources (compute, storage, APIs, IAM)
- Ex: `gcloud compute instances list --project=X`

**gemini**: For web_fetch, text generation, retrospective analysis.
- When: Need web content, complex text generation, or project insights
- Usage: `gemini --help`

**pinact**: Pinact CLI for pinning GitHub Actions SHA versions.
- When: Pinning GitHub Actions in workflows
- Usage: `pinact --help`

**jq**: JSON processor CLI.
- When: Parsing/manipulating JSON data in shell scripts
- Ex: `cat data.json | jq '.key'`
