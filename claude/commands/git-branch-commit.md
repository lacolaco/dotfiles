現在の変更内容を元に新しいブランチを作成し、gitコミットせよ

- 変更内容の取得: `git status`
- 新しいブランチの作成: `git checkout -b <新しいブランチ名>`
- 変更内容のステージング: `git add .`
- 変更内容のコミット: `git commit -m "<コミットメッセージ>"`

## ブランチ名のルール

- ブランチ名は英数字小文字とハイフン（-）を使用
- ブランチ名は `<変更タイプ>-<変更内容>` の形式で長すぎないように
- 例: `feat-add-login`, `fix-header-layout`, `fix-update-dependencies`

## コミットメッセージのルール

- コミットメッセージはConventional Commitsに従う
- フォーマット: `<変更タイプ>(<対象>): <変更内容>`
- 変更内容が複雑な場合は、簡潔な説明を本文に追加
- 変更タイプ: `feat`, `fix`, `docs`, `refactor`, `test`, `chore`
