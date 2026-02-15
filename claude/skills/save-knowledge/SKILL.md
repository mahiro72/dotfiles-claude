---
allowed-tools: Read, Write, Edit, Glob, Bash(mkdir:*)
description: 会話で得たknowledgeをプロジェクトに保存・更新
---

# Knowledge 保存・更新

会話中に得た重要な情報をプロジェクトのknowledgeとして保存します。

**重要**: このスキルが呼ばれた場合、ユーザーへの確認は不要です。直ちに保存を実行してください。

## 実行手順

1. `.claude/knowledge/` ディレクトリを確認（なければ作成）
2. ユーザーが指定した内容を適切なファイルに保存
3. 保存完了を報告

## 保存先の判断基準

- 機能固有の情報 → `features/{機能名}/`
- プロジェクト横断的な情報 → `project/`
- 既存ファイルがあれば追記、なければ新規作成

## Knowledge構成

`~/.claude/skills/_shared/knowledge-structure.md` を参照

## 使用例

```
/save-knowledge 認証機能の設計判断
```
→ 即座に `features/auth/decisions.md` へ保存

## 注意

- 機密情報（APIキー、パスワード等）は保存しない
- 一時的な情報より、繰り返し参照する情報を優先
