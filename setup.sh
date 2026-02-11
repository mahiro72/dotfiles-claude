#!/bin/bash
#
# Claude Code 設定セットアップスクリプト
#
# このスクリプトは以下を行います:
# - ~/.claude/ 以下に設定ファイルのシンボリックリンクを作成
# - global gitignore に .claude/logs/ を追加
#
# 既存ファイルがある場合は .backup として退避します
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_HOME="${HOME}/.claude"

echo "=== Claude Code Setup ==="

# ~/.claude ディレクトリ作成
mkdir -p "${CLAUDE_HOME}"
mkdir -p "${CLAUDE_HOME}/hooks"
mkdir -p "${CLAUDE_HOME}/skills"

# シンボリックリンク作成関数
link_file() {
  local src="$1"
  local dest="$2"

  if [ -L "${dest}" ]; then
    echo "  [skip] ${dest} (already linked)"
  elif [ -e "${dest}" ]; then
    echo "  [backup] ${dest} -> ${dest}.backup"
    mv "${dest}" "${dest}.backup"
    ln -s "${src}" "${dest}"
    echo "  [link] ${src} -> ${dest}"
  else
    ln -s "${src}" "${dest}"
    echo "  [link] ${src} -> ${dest}"
  fi
}

echo ""
echo "Linking claude config files..."
link_file "${SCRIPT_DIR}/claude/CLAUDE.md" "${CLAUDE_HOME}/CLAUDE.md"
link_file "${SCRIPT_DIR}/claude/settings.json" "${CLAUDE_HOME}/settings.json"
link_file "${SCRIPT_DIR}/claude/hooks.json" "${CLAUDE_HOME}/hooks.json"

echo ""
echo "Linking hooks..."
link_file "${SCRIPT_DIR}/hooks/save-history.sh" "${CLAUDE_HOME}/hooks/save-history.sh"
chmod +x "${SCRIPT_DIR}/hooks/save-history.sh"

echo ""
echo "Linking skills..."
for skill_dir in "${SCRIPT_DIR}/claude/skills/"*/; do
  skill_name=$(basename "${skill_dir}")
  link_file "${skill_dir}" "${CLAUDE_HOME}/skills/${skill_name}"
done

echo ""
echo "=== Global gitignore setup ==="

# グローバルgitignoreのパスを取得
GLOBAL_GITIGNORE=$(git config --global core.excludesfile 2>/dev/null || echo "")

if [ -z "${GLOBAL_GITIGNORE}" ]; then
  GLOBAL_GITIGNORE="${HOME}/.config/git/ignore"
  echo "Setting global gitignore to: ${GLOBAL_GITIGNORE}"
  mkdir -p "$(dirname "${GLOBAL_GITIGNORE}")"
  git config --global core.excludesfile "${GLOBAL_GITIGNORE}"
fi

# 展開（~を実際のパスに）
GLOBAL_GITIGNORE="${GLOBAL_GITIGNORE/#\~/$HOME}"

# gitignore.d/claude の各行を追加（重複チェック付き）
added_count=0
while IFS= read -r line || [ -n "$line" ]; do
  # 空行・コメント行はスキップ
  [[ -z "$line" || "$line" =~ ^# ]] && continue

  if [ -f "${GLOBAL_GITIGNORE}" ] && grep -qF "$line" "${GLOBAL_GITIGNORE}" 2>/dev/null; then
    echo "  [skip] $line (already exists)"
  else
    echo "$line" >> "${GLOBAL_GITIGNORE}"
    echo "  [added] $line"
    ((added_count++))
  fi
done < "${SCRIPT_DIR}/gitignore.d/claude"

if [ $added_count -eq 0 ]; then
  echo "  All entries already in ${GLOBAL_GITIGNORE}"
fi

echo ""
echo "=== Setup complete! ==="
echo ""
