#!/bin/bash
#
# Claude Code 設定リセットスクリプト
# setup.sh で作成したシンボリックリンクを削除し、
# バックアップがあれば復元する
#

set -euo pipefail

CLAUDE_HOME="${HOME}/.claude"

echo "=== Claude Code Reset ==="

# シンボリックリンク削除関数
unlink_file() {
  local dest="$1"
  local backup="${dest}.backup"

  if [ -L "${dest}" ]; then
    rm "${dest}"
    echo "  [removed] ${dest}"

    if [ -e "${backup}" ]; then
      mv "${backup}" "${dest}"
      echo "  [restored] ${backup} -> ${dest}"
    fi
  elif [ -e "${dest}" ]; then
    echo "  [skip] ${dest} (not a symlink)"
  else
    echo "  [skip] ${dest} (does not exist)"
  fi
}

echo ""
echo "Removing symlinks..."
unlink_file "${CLAUDE_HOME}/CLAUDE.md"
unlink_file "${CLAUDE_HOME}/settings.json"
unlink_file "${CLAUDE_HOME}/hooks.json"
unlink_file "${CLAUDE_HOME}/hooks/save-history.sh"

echo ""
echo "Removing skill symlinks..."
for skill in "${CLAUDE_HOME}/skills/"*/; do
  if [ -L "${skill%/}" ]; then
    unlink_file "${skill%/}"
  fi
done

echo ""
echo "=== Reset complete! ==="
echo ""
echo "Note: Global gitignore entries were NOT removed."
echo "To remove manually, edit: $(git config --global core.excludesfile 2>/dev/null || echo '~/.config/git/ignore')"
