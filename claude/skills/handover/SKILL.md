---
name: handover
description: タスクの引き継ぎを行う。セッション終了時にユーザーからの引き継ぎ要求に応じて実行する。セッションリミットが近づいたらユーザーに実行を提案する。takeoverスキルと対をなす。
user-invocable: true
---

後任者に向けて作業の引き継ぎを行え。
引き継ぎ用の文書が $ARGUMENTS で与えられる。与えられなければ `<workspaceRootDir>/task.local.md` を参照しろ。
引き継ぎ文書を読み、現在の状態とのギャップを把握しろ。
最新の状況に基づいて、引き継ぎ文書を修正しろ。
後任者がスムーズに引き継げるように、必要な情報を正確に記載しろ。
後続タスクに不要なノイズとなる情報は圧縮し、重要な事実だけを残せ
タスクの根本的な目的、未解決の課題、注意すべきポイントを明確にしろ。
仮説と事実を区別して記載しろ。仮説には蓋然性を示せ。事実には根拠を示せ。
ネクストアクションを具体的に示せ。

わからないことは質問しろ。推測による思い込みは何よりも罪深い。

## Format 

引き継ぎ文書はMarkdown形式で記載しろ。以下のテンプレートに従え。

```markdown
# Handover Document

Written at: YYYY-MM-DD

## Goals

- [x] Goal item 1
- [ ] Goal item 2
- [ ] Goal item 3

## Current State

## Tasks

## Facts

## Hypotheses

## Issues

## Plans

## Notes
```

