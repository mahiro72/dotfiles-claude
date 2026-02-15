#!/bin/bash
#
# Claude Code セッション履歴保存スクリプト
#
# セッションデータを .claude/logs/{date}_{session_id}.json に保存
# 会話履歴（transcript）も含め、重複保存はスキップ
#
# 呼び出し元:
#   - PreCompact フック（コンテキスト圧縮時）
#   - Stop フック（会話終了時）
#

set -euo pipefail

# jqが必須
if ! command -v jq &> /dev/null; then
  echo "Error: jq is required but not installed." >&2
  echo "Install with: brew install jq" >&2
  exit 1
fi

HOOK_EVENT="${1:-unknown}"
DATE=$(date +"%Y%m%d")
TIMESTAMP=$(date +"%Y-%m-%dT%H:%M:%S")
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

# transcript_pathを取得
TRANSCRIPT_PATH=$(echo "${SESSION_DATA}" | jq -r '.transcript_path // empty' 2>/dev/null || true)

# 履歴ファイルのパス（日付 + セッションID）
HISTORY_FILE="${LOGS_DIR}/${DATE}_${SESSION_ID}.json"

# 重複チェック用: transcript の行数を取得
CURRENT_TRANSCRIPT_LINES=0
if [ -n "${TRANSCRIPT_PATH}" ] && [ -f "${TRANSCRIPT_PATH}" ]; then
  CURRENT_TRANSCRIPT_LINES=$(wc -l < "${TRANSCRIPT_PATH}" | tr -d ' ')
fi

# 既存ファイルがある場合、前回の行数と比較して重複をスキップ
if [ -f "${HISTORY_FILE}" ]; then
  LAST_TRANSCRIPT_LINES=$(jq -r '.metadata.transcript_lines // 0' "${HISTORY_FILE}" 2>/dev/null || echo "0")
  # 空文字列や非数値の場合は0として扱う
  if ! [[ "${LAST_TRANSCRIPT_LINES}" =~ ^[0-9]+$ ]]; then
    LAST_TRANSCRIPT_LINES=0
  fi
  if [ "${CURRENT_TRANSCRIPT_LINES}" -eq "${LAST_TRANSCRIPT_LINES}" ]; then
    echo "Skipped: No new transcript content (lines: ${CURRENT_TRANSCRIPT_LINES})" >&2
    exit 0
  fi
fi

# 一時ファイルを使用してtranscriptを処理（引数長制限を回避）
TEMP_FILE=$(mktemp)
trap "rm -f '${TEMP_FILE}'" EXIT

# transcript内容を一時ファイルに書き込む（必要な情報のみ抽出）
if [ -n "${TRANSCRIPT_PATH}" ] && [ -f "${TRANSCRIPT_PATH}" ]; then
  # JSONL形式を配列に変換し、user/assistantのみ抽出して軽量化
  jq -s '[.[] | select(.type == "user" or .type == "assistant") | {
    type,
    timestamp,
    content: .message.content
  }]' "${TRANSCRIPT_PATH}" > "${TEMP_FILE}" 2>/dev/null || echo "[]" > "${TEMP_FILE}"
else
  echo "[]" > "${TEMP_FILE}"
fi

# jqで整形して保存（transcriptはslurpfileで読み込み）
echo "${SESSION_DATA}" | jq \
  --arg event "${HOOK_EVENT}" \
  --arg date "${DATE}" \
  --arg timestamp "${TIMESTAMP}" \
  --argjson transcript_lines "${CURRENT_TRANSCRIPT_LINES}" \
  --slurpfile transcript "${TEMP_FILE}" \
'{
  metadata: {
    date: $date,
    timestamp: $timestamp,
    session_id: (.session_id // "unknown"),
    trigger: $event,
    project: env.PWD,
    transcript_lines: $transcript_lines
  },
  session: .,
  transcript: $transcript[0]
}' > "${HISTORY_FILE}"

echo "History saved: ${HISTORY_FILE} (transcript lines: ${CURRENT_TRANSCRIPT_LINES})" >&2
