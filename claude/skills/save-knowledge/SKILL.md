---
allowed-tools: Read, Write, Edit, Glob, Bash(mkdir:*)
description: 会話で得たknowledgeをプロジェクトに保存・更新
---

# Knowledge 保存・更新

会話中に得た重要な情報をプロジェクトのknowledgeとして保存します。

**Knowledge構成は `~/.claude/skills/_shared/knowledge-structure.md` を参照**

## 実行内容

1. **保存対象の確認**
   - ユーザーに何を保存するか確認
   - 既存のknowledgeとの重複チェック

2. **適切なファイルの選択**
   - 機能別か、プロジェクト全体か判断
   - 既存ファイルへの追記 or 新規ファイル作成
   - README.mdのインデックス更新

3. **保存実行**
   - マークダウン形式で整理して保存
   - 日付・コンテキストを付与

## 使い方

```
/save-knowledge
```

その後、何を保存するか指示してください：
- 「認証機能の設計判断を保存して」→ `features/auth/decisions.md`
- 「このバグの対処法を保存」→ `project/troubleshooting.md`
- 「決済APIの仕様をまとめて」→ `features/payment/overview.md`

## 注意

- 機密情報（APIキー、パスワード等）は保存しない
- 一時的な情報より、繰り返し参照する情報を優先
- 機能が明確なら `features/` 、横断的なら `project/` へ
