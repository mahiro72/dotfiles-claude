# dotfiles-claude

Claude Code の設定ファイル管理用リポジトリ

## 主な機能

- **会話履歴の自動保存**: セッション終了時・コンテキスト圧縮時に履歴を自動保存
- **過去の会話の参照**: 保存した履歴から過去の会話を思い出せる
- **プロジェクト知識の蓄積**: 会話で得た知識を `.claude/knowledge/` に体系的に保存
- **メモ・学習資料の保存**: 後で参照したい情報を `.claude/notes/` に保存
- **PRドラフト作成**: 作業内容からPRタイトルと概要を生成
- **コードレビュー**: git差分ベースのレビュー

## 構成

```
dotfiles-claude/
├── setup.sh          # セットアップ
├── reset.sh          # リセット（リンク解除）
├── claude/
│   ├── CLAUDE.md     # グローバルプロンプト
│   ├── settings.json # ツール許可設定・フック定義
│   └── skills/
│       ├── init-knowledge/  # /init-knowledge
│       ├── save-knowledge/  # /save-knowledge
│       ├── save-note/       # /save-note
│       ├── draft-pr/        # /draft-pr
│       └── review/          # /review
├── hooks/
│   └── save-history.sh      # 履歴保存スクリプト
└── gitignore.d/
    └── claude
```

## セットアップ

```bash
./setup.sh
```

以下が実行されます:
- `~/.claude/` 以下へシンボリックリンク作成
- global gitignore に `.claude/logs/` 等を追加

## リセット（元に戻す）

```bash
./reset.sh
```

シンボリックリンクを削除し、バックアップがあれば復元します。

## スキル

| コマンド | 説明 |
|----------|------|
| `/init-knowledge` | プロジェクト初期化時にknowledgeを整理・読み込み |
| `/save-knowledge` | 会話で得たknowledgeをプロジェクトに保存・更新 |
| `/save-note` | メモや学習資料を `.claude/notes/` に保存 |
| `/draft-pr` | 会話内容からPRタイトルと概要を作成 |
| `/review` | git差分ベースのコードレビュー |

## 履歴保存

PreCompact / Stop フックにより、各プロジェクトの `.claude/logs/` へ JSON 形式で履歴が自動保存されます。

| タイミング | フック |
|-----------|--------|
| コンテキスト圧縮時 | PreCompact |
| 会話終了時 | Stop |

## Knowledge ディレクトリ構成

各プロジェクトで以下の構成を推奨:

```
.claude/
└── knowledge/
    ├── README.md                 # 概要・インデックス
    │
    ├── project/                  # プロジェクト全体
    │   ├── architecture.md       # アーキテクチャ
    │   ├── conventions.md        # コーディング規約
    │   ├── dependencies.md       # 依存関係
    │   └── troubleshooting.md    # トラブルシューティング
    │
    ├── features/                 # 機能別
    │   ├── README.md             # 機能一覧
    │   └── {feature-name}/
    │       ├── overview.md       # 概要・仕様
    │       ├── decisions.md      # 設計判断
    │       └── issues.md         # 注意点
    │
    ├── guides/                   # ガイドライン
    │
    └── external/                 # 外部リポジトリ参照
```

## 読み取り除外（セキュリティ）

以下はClaudeが読み取らないように設定済み:

| カテゴリ | パターン |
|----------|----------|
| 環境変数 | `.env`, `.env.*` |
| シークレット | `secrets/**`, `*.key`, `*.pem`, `*.p12` |
| クラウド認証 | `~/.aws/**`, `~/.ssh/**`, `~/.config/gcloud/**` |
| 依存・ビルド | `node_modules`, `vendor`, `build`, `dist`, `.next`, `__pycache__` |
| VCS | `.git` |

## global gitignore

以下がgitignoreに追加されます:
- `.claude/logs/`
- `.claude/knowledge/`
- `.claude/notes/`
- `.claude/CLAUDE.local.md`
- `.claude/settings.local.json`
