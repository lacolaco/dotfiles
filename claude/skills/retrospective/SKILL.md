---
name: retrospective
description: コルブの経験学習モデルに基づく振り返り。具体的経験→省察→概念化→実践の4段階で、再利用可能な原則を抽出し改善を反映する。
---

# Retrospective

コミット・PR作成前に実施する。

コルブの経験学習サイクルの4段階を順に実行する。Phase 3（概念化）が最重要。

## Phase 1: Concrete Experience

事実のみ記録する。解釈・評価を混ぜない。

- **Goal**: 要件 / 完了した成果物 / 未完了・ブロッカー
- **Efficiency**: 実行したアクション / やり直し箇所 / 遭遇した障害
- **User Satisfaction**: ユーザーの反応 / 不満を示した場面 / 満足を示した場面

## Phase 2: Reflective Observation

Phase 1の事実からパターンを見出す。「何が起きたか」ではなく「なぜそうなったか」を問う。

- 成功と失敗の構造的な差は何か
- ユーザーの不満は何の欠如を示しているか
- やり直しの原因はどの判断時点に遡るか
- 同じパターンが過去にもあったか
- Implementer / Reviewer の使い分けは適切だったか
- 暗黙知に依存していなかったか（CLAUDE.mdに書かれていない前提）

## Phase 3: Abstract Conceptualization

省察から再利用可能な原則を抽出する。最重要ステップ。

原則の品質基準:

- 今回固有でなく、同類の問題全般に適用できる
- 「Xを検証する」でなく「検証なしに前提を置かない」のレベルで抽象化されている
- 原則を読んだだけで未経験の状況でも正しい判断ができる

悪い例: 「Gemini APIの `oneOf` サポート状況を事前に検証する」
良い例: 「二次情報を因果推論の根拠にしない。実機検証か一次ソースで裏付ける」

## Phase 4: Active Experimentation

Phase 3の原則を改善として反映する。非決定論的な対策は常に劣後する。

優先順位:

1. アーキテクチャリファクタリング → Issue起票→実装
2. 決定論的ガードレール → eslint, tsconfig, CI, hooks
3. スキル → `.claude/skills/*/SKILL.md`
4. エージェントプロンプト → `.claude/agents/*.md`
5. CLAUDE.md → `.claude/CLAUDE.md`

## 提出

Phase 1〜4の結果をユーザーに提示し、改善を反映する。反映後、未コミットの変更があればコミット→pushまで自律実行する。
