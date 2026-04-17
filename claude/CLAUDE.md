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
- 知らない情報（URL, ID, credentials等）は即座にユーザーに聞け。推測・探索で時間を浪費するな。ドメイン知識が不足している領域で推測を重ねるな。
- テストの期待値・定数など正解が一意に決まる値は、記憶や推測ではなく必ずデータソース（生成ファイル、API、DB等）から取得しろ。「知っているつもり」で検証を省略するな。
- 複雑な解決策を設計する前に、より単純な代替手段がないか問え。入力データに安定した識別子（ID, 番号等）があるなら、不安定な名前マッチングよりID検索を優先しろ。
- 破壊的操作（削除、上書き）の前に復元手段を確保しろ。バックアップなしに一括削除するな。
- スキル・設定ファイルの指示を引用する前に、一次ソースを読め。読んでいないドキュメントの内容を推測で語るな。
- ツール（formatter, linter等）が生成した差分を手動で巻き戻すな。再現可能な差分を捨てる行為は問題の先送りであり解決ではない。スコープを狭めたいなら別コミットに分けろ。
- 実行環境の制約（permissionシステム、sandbox、CI等がコマンドをどう解釈するか）をインターフェース設計の入力にせよ。制約を確認してから呼び出し形式を決定しろ。実装後に制約に気づく手戻りを防げ。

## Workflow

- 予期しない状態（CIチェックなし、空の応答、想定外のエラー等）を検出した場合、そのまま報告するな。原因を調査してから報告しろ。
- 指定されたworktreeで作業しろ。ファイル変更前に正しいworktreeにいることを確認しろ。
- 確立されたワークフローは自律的に実行しろ。既知の次ステップで確認を求めるな。実行しろ。
- コード変更完了後のワークフロー（テスト→ブランチ作成→コミット→PR作成→CI監視→レビュー対応→マージ承認要求→デプロイ確認）は一連の自律タスクとして中断せず実行しろ。ブロッカー発生時のみ報告しろ。
- PRマージ後のワークフロー（ブランチ削除、retrospective、handover文書更新）は完全に実行しろ。ステップを飛ばすな。実行するか確認を求めるな。
- デプロイ・本番環境操作はユーザーの明示的な承認なしに実行するな。それ以外のコード変更は自律的に進めろ。
- コード変更完了時に、ユーザー視点での影響（何が変わるか）を報告せよ。技術的な差分だけでは不十分。
- 調査で得たドメイン知識は、即座にCLAUDE.mdに永続化せよ。指摘される前に行え。
- フックやガードレールでブロックされた場合、原因が明確なら確認なしに代替手段を即座に実行しろ（例: mainブランチ保護 → ブランチ作成して続行）。
- ユーザーが入力したコマンドやサブコマンド（例: `git switch`）は好みの表明として扱い、以降同じ操作ではそのコマンドを使え。

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

**pinact**: Pinact CLI for pinning GitHub Actions SHA versions.
- When: Pinning GitHub Actions in workflows
- Usage: `pinact --help`

**jq**: JSON processor CLI.
- When: Parsing/manipulating JSON data in shell scripts
- Ex: `cat data.json | jq '.key'`
