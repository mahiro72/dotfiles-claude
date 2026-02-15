---
allowed-tools: Read, Glob, Grep
description: プロジェクト初期化時にknowledgeを整理・読み込み
---

# プロジェクト Knowledge 整理

プロジェクトのナレッジベースを即座にスキャンして報告します。

**重要**: このスキルが呼ばれた場合、確認は不要です。直ちにスキャンを実行し結果を出力してください。

## 実行手順

1. CLAUDE.md、README.md、.claude/knowledge/ を読み取り
2. 以下の形式で即座に出力

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
