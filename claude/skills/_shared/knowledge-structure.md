# Knowledge ディレクトリ構成

プロジェクトの知見は `.claude/knowledge/` に蓄積します。

```
.claude/
└── knowledge/
    ├── README.md                 # 概要・インデックス
    │
    ├── project/                  # プロジェクト全体
    │   ├── architecture.md       # アーキテクチャ・設計判断
    │   ├── conventions.md        # コーディング規約・命名規則
    │   ├── dependencies.md       # 依存関係・ライブラリ選定理由
    │   └── troubleshooting.md    # トラブルシューティング
    │
    ├── features/                 # 機能別の詳細
    │   ├── README.md             # 機能一覧・インデックス
    │   └── {feature-name}/
    │       ├── overview.md       # 概要・仕様
    │       ├── decisions.md      # 設計判断・経緯
    │       └── issues.md         # 既知の問題・注意点
    │
    ├── guides/                   # ガイドライン（外部参照含む）
    │   └── README.md
    │
    └── external/                 # 外部リポジトリからの参照メモ
        └── {repo-name}.md
```

## 保存先の選び方

| 内容 | 保存先 |
|------|--------|
| プロジェクト全体の設計判断 | `project/architecture.md` |
| コーディング規約 | `project/conventions.md` |
| ライブラリ選定理由 | `project/dependencies.md` |
| バグ・ワークアラウンド | `project/troubleshooting.md` |
| 特定機能の仕様 | `features/{name}/overview.md` |
| 特定機能の設計経緯 | `features/{name}/decisions.md` |
| 特定機能の注意点 | `features/{name}/issues.md` |
| 外部リポジトリの情報 | `external/{repo-name}.md` |

## 判断基準

- 機能固有 → `features/{name}/`
- プロジェクト横断 → `project/`
- 外部情報 → `external/`
