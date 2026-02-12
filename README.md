# dotfiles-ai

Claude Code の設定ファイル管理用リポジトリ

## 構成

```
dotfiles-ai/
├── setup.sh          # セットアップ
├── reset.sh          # リセット（リンク解除）
├── claude/
│   ├── CLAUDE.md     # グローバルプロンプト
│   ├── settings.json # ツール許可設定
│   └── skills/
│       ├── init-knowledge/  # /init-knowledge
│       └── review/          # /review
├── hooks/
│   └── save-history.sh
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
| `/review` | git差分ベースのコードレビュー |

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

## 履歴保存

Compact / Stop 時に各プロジェクトの `.claude/logs/` へ JSON 形式で履歴が保存されます。

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
- `.claude/CLAUDE.local.md`
- `.claude/settings.local.json`
