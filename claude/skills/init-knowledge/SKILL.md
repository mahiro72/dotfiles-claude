---
allowed-tools: Read, Glob, Grep, Bash(ls:*, find:*, cat:*)
description: プロジェクト初期化時にknowledgeを整理・読み込み
---

# プロジェクト Knowledge 整理

プロジェクトのナレッジベースを整理し、重要なドキュメントを把握します。

**Knowledge構成は `~/.claude/skills/_shared/knowledge-structure.md` を参照**

## 実行内容

1. **プロジェクト構造の確認**
   - CLAUDE.md の有無と内容確認
   - .claude/knowledge/ ディレクトリの確認
   - README.md の確認

2. **関連ドキュメントの探索**
   - Cross-Repo Context（CLAUDE.mdで指定されている場合）
   - docs/ ディレクトリ
   - 要件定義・設計書

3. **ガイドラインの優先度整理**
   - 実装ガイドライン > 設計書 > 要件定義 の優先順位を確認
   - 矛盾がある場合は報告

## 出力形式

```
## プロジェクト概要
- 名前: xxx
- 技術スタック: xxx

## Knowledge
### Project
- .claude/knowledge/project/architecture.md
- .claude/knowledge/project/conventions.md

### Features
- auth: .claude/knowledge/features/auth/
- payment: .claude/knowledge/features/payment/

## 重要ドキュメント
- [優先度高] path/to/guideline.md
- [設計] path/to/design.md

## 注意事項
- 特記すべき制約やルール
```
