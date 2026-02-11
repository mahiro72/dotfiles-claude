#!/bin/bash
#
# Claude Code セッション履歴保存スクリプト
#
# PostCompact / Stop hook から呼び出され、セッションデータを
# 各プロジェクトの .claude/logs/{session_id}_{date}.json に保存します
# 同一セッションの場合は追記（上書き）
#
# 使用方法: save-history.sh <event>
#   event: PostCompact | Stop
#

set -euo pipefail

# jqが必須
if ! command -v jq &> /dev/null; then
  echo "Error: jq is required but not installed." >&2
  echo "Install with: brew install jq" >&2
  exit 1
fi

HOOK_EVENT="${1:-unknown}"
DATE=$(date +"%y%m%d")
PROJECT_ROOT=$(pwd)
LOGS_DIR="${PROJECT_ROOT}/.claude/logs"

# ログディレクトリ作成
mkdir -p "${LOGS_DIR}"

# 標準入力からセッションデータを読み取り
SESSION_DATA=$(cat)

# セッションデータが空の場合はスキップ
if [ -z "${SESSION_DATA}" ]; then
  exit 0
fi

# セッションIDを取得
SESSION_ID=$(echo "${SESSION_DATA}" | jq -r '.session_id // empty' 2>/dev/null || true)

# セッションIDがない場合はエラー
if [ -z "${SESSION_ID}" ]; then
  echo "Error: session_id not found in hook data" >&2
  exit 1
fi

# 履歴ファイルのパス（セッションID + 日付）
HISTORY_FILE="${LOGS_DIR}/${SESSION_ID}_${DATE}.json"

# jqで整形して保存
echo "${SESSION_DATA}" | jq --arg event "${HOOK_EVENT}" --arg date "${DATE}" '{
  metadata: {
    session_id: (.session_id // "unknown"),
    date: $date,
    trigger: $event,
    project: env.PWD
  },
  session: .
}' > "${HISTORY_FILE}"

echo "History saved: ${HISTORY_FILE}" >&2
