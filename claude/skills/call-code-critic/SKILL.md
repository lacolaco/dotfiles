---
name: call-code-critic
description: "WHEN: ユーザーが現在のコード変更・PR・ファイルに対して code-critic agent による批判的レビューを起動したいとき。`/call-code-critic` で呼ぶ。INPUT: レビュー対象 (コードのパス / diff / PR番号 等) + 変更意図 + レビュー対象レイヤー (design / implementation / both / unspecified)。OUTPUT: code-critic agent を Agent ツールで起動し、返ってきた critical findings を構造のまま提示。"
user-invocable: true
---

## 役割

`code-critic` agent を起動するための **エントリポイント**。`code-critic` は Invocation Contract により precondition（レビュー対象コード / 変更意図 / レビュー対象レイヤー）を要求する。本 skill はその precondition を満たした形で agent を呼び出すことだけに責務を持つ。

レビューロジック（Review Layering、High Cohesion / Loose Coupling、OCP、DbC、SbD、Test Smell as Design Signal、`critic-design-review` / `critic-implementation-review` の使い分け）は **すべて agent 側** にある。本 skill は判断しない。

## 手順

### 1. precondition の充足を確認

`code-critic` の Invocation Contract に従い、以下3点が揃っているか確認する。揃っていなければ **agent を起動せず**、`AskUserQuestion` で不足項目を要求してから進む（partial invocation は agent 側でも refuse される）。

- **レビュー対象**: ファイルパス / ディレクトリ / diff / PR 番号 / 貼り付けコードのいずれか、識別可能なスコープ付き
- **変更意図**: この変更が何を達成しようとしているか。design review なら設計意図と制約、implementation review なら実装が満たすべき contract / signature / invariants
- **レビュー対象レイヤー**: `design` / `implementation` / `both` / `unspecified` のいずれか。`unspecified` の場合、agent が Review Layering で判断する（両方触るなら design review 先行）

precondition が揃わないまま agent を起動するな。「足りない部分は agent が自分で判断する」と推定して起動するのは Invocation Contract 違反。

### 2. Agent ツールで code-critic を起動

`Agent` ツールを `subagent_type: code-critic` で呼び出す。プロンプトには precondition の3項目を以下の構造で含める:

```
## Review target
<file paths / diff / PR number / pasted code、識別可能なスコープ>

## Intent of the change
<変更が何を達成しようとしているか。design review なら設計意図と制約、
 implementation review なら満たすべき contract / signature / invariants>

## Layer in scope
design | implementation | both | unspecified
```

`description` には `Critical review via code-critic` 等、タスクが識別可能な短い文字列を渡す。

### 3. agent の出力をそのまま提示

agent が返す critical findings（`Issue` / `Root Cause` / `Impact` / `Fix` の構造と末尾の `Priority Assessment`）は **要約・取捨選択・トーン緩和をせず**、構造を保ったままユーザーに提示する。`code-critic` の brutal-honest トーンを薄めない。

## 制約

- 本 skill は **agent を起動するだけ** が責務。critique 内容を skill 内で生成するな
- precondition が不足したまま agent を起動するな。partial invocation は agent の Invocation Contract に refuse される
- agent の出力を「やわらかく」言い換えるな
- レビュー対象レイヤーの判断を skill 内で勝手に決めるな。`unspecified` で渡し、agent の Review Layering に委ねるのが既定
