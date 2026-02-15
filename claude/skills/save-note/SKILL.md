---
allowed-tools: Read, Write, Edit, Glob, Bash(mkdir:*)
description: 雑多なメモや学習資料を保存
---

# メモ保存

後で参照したい情報、学習資料、調査メモなどを `.claude/notes/` に保存します。

**重要**: このスキルが呼ばれた場合、確認は不要です。直ちに保存を実行してください。

## 実行手順

1. `.claude/notes/` ディレクトリを確認（なければ作成）
2. `{YYYYMMDD}_{タイトル}.md` 形式でファイルを作成
3. 保存完了を報告

## ファイル名の例

- `20250215_react-hooks-guide.md`
- `20250215_kubernetes-networking.md`
- `20250215_go-error-handling.md`

## 内容の書き方

- 体系的にキャッチアップできるよう構造化
- 見出し、箇条書き、コード例を活用
- 参考リンクがあれば含める

## 使用例

```
/save-note React Hooksの基礎をまとめて
```
→ 即座に `.claude/notes/20250215_react-hooks.md` へ保存
