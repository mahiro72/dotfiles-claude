#!/bin/bash
#
# CLAUDE.md リマインダー
#
# UserPromptSubmit 時に CLAUDE.md を出力
#

cat ~/.claude/CLAUDE.md 2>/dev/null || true
