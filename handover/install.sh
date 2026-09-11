#!/usr/bin/env bash
# Handover installer — 把会话交接 skill 装到各个 AI 编程工具里
# 用法: ./install.sh [--all|--project|--codex|--cc|--dsh|--workbuddy|--zcode|--trae|--qoder|--uninstall]
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="$SCRIPT_DIR/SKILL.md"
MARK_START="<!-- handover:start -->"
MARK_END="<!-- handover:end -->"

if [ ! -f "$SRC" ]; then
  echo "找不到 $SRC，请在 handover 目录下运行本脚本" >&2
  exit 1
fi

usage() {
  cat <<'EOF'
Handover — 会话交接（长会话结束前写 CONTINUE.md）

用法:
  ./install.sh                 项目级安装（AGENTS.md + Trae 规则）
  ./install.sh --project       同上
  ./install.sh --codex         Codex:  追加到 ~/.codex/AGENTS.md
  ./install.sh --cc            Claude Code: CLAUDE.md + .claude/commands/handover.md
  ./install.sh --dsh           DSH:    ~/.dsh/skills/handover/SKILL.md
  ./install.sh --workbuddy     WorkBuddy: ~/.workbuddy/skills/handover/SKILL.md
  ./install.sh --zcode         Zcode:  ~/.zcode/skills/handover/SKILL.md
  ./install.sh --trae          Trae:   .trae/rules/handover.md
  ./install.sh --qoder         Qoder:  ~/.qoder/skills/handover/SKILL.md
  ./install.sh --all           全部平台
  ./install.sh --uninstall     移除本脚本安装过的所有内容
EOF
}

# 去掉 SKILL.md 的 YAML frontmatter 和开头空行，只留正文
body() {
  awk '
    NR == 1 && $0 == "---" { f = 1; next }
    f && $0 == "---"       { f = 0; next }
    !f { if (!started && $0 ~ /^[[:space:]]*$/) next; started = 1; print }
  ' "$SRC"
}

# 从文件里剥掉旧的 handover 段落（幂等 + 可卸载，不动文件其余内容）
strip_block() {
  local file="$1"
  [ -f "$file" ] || return 0
  grep -qF "$MARK_START" "$file" || return 0
  awk -v s="$MARK_START" -v e="$MARK_END" '
    index($0, s) { skip = 1; next }
    skip         { if (index($0, e)) skip = 0; next }
                 { buf[n++] = $0 }
    END          { for (i = 0; i < n; i++) print buf[i] }
  ' "$file" > "$file.mp.tmp"
  mv "$file.mp.tmp" "$file"
}

# 把 handover 段落追加到目标文件
append_block() {
  local file="$1"
  mkdir -p "$(dirname "$file")"
  strip_block "$file"
  # 原文件末尾没有换行时补一个，绝不改动已有内容
  if [ -f "$file" ] && [ -s "$file" ] && [ -n "$(tail -c 1 "$file")" ]; then
    printf '\n' >> "$file"
  fi
  # 分隔符空行放在标记块内部，卸载时随块一起移除
  {
    echo "$MARK_START"
    echo
    body
    echo "$MARK_END"
  } >> "$file"
  echo "  ✔ 追加到 $file"
}

# 复制一份独立 SKILL.md 到某平台的 skills 目录
install_skill_dir() {
  local dir="$1"
  mkdir -p "$dir"
  cp "$SRC" "$dir/SKILL.md"
  echo "  ✔ 安装到 $dir/SKILL.md"
}

do_project() {
  echo "[项目级] AGENTS.md（Codex / DSH / Zcode / Qoder 通用）"
  append_block "$PWD/AGENTS.md"
  do_trae
}

do_codex() {
  echo "[Codex] 全局指令"
  append_block "${CODEX_HOME:-$HOME/.codex}/AGENTS.md"
}

do_cc() {
  echo "[Claude Code] 项目指令 + 斜杠命令"
  append_block "$PWD/CLAUDE.md"
  mkdir -p "$PWD/.claude/commands"
  cp "$SRC" "$PWD/.claude/commands/handover.md"
  echo "  ✔ 安装到 .claude/commands/handover.md（对话里输入 /handover 触发）"
}

do_dsh() {
  echo "[DSH] 全局 skill"
  install_skill_dir "${DSH_HOME:-$HOME/.dsh}/skills/handover"
}

do_workbuddy() {
  echo "[WorkBuddy] 全局 skill"
  install_skill_dir "$HOME/.workbuddy/skills/handover"
}

do_zcode() {
  echo "[Zcode] 全局 skill"
  install_skill_dir "$HOME/.zcode/skills/handover"
}

do_trae() {
  echo "[Trae] 项目规则"
  local file="$PWD/.trae/rules/handover.md"
  mkdir -p "$(dirname "$file")"
  {
    echo "---"
    echo "description: 会话交接——长会话结束前把进度与踩坑记录写进 CONTINUE.md，新会话读它接着干"
    echo "alwaysApply: true"
    echo "---"
    echo
    body
  } > "$file"
  echo "  ✔ 安装到 $file"
}

do_qoder() {
  echo "[Qoder] 全局 skill"
  install_skill_dir "$HOME/.qoder/skills/handover"
}

do_uninstall() {
  echo "移除 handover..."
  for f in "$PWD/AGENTS.md" "$PWD/CLAUDE.md" \
           "${CODEX_HOME:-$HOME/.codex}/AGENTS.md" \
           "${DSH_HOME:-$HOME/.dsh}/AGENTS.md"; do
    if [ -f "$f" ] && grep -qF "$MARK_START" "$f"; then
      strip_block "$f"
      echo "  ✔ 清理 $f"
    fi
  done
  for p in "$PWD/.trae/rules/handover.md" "$PWD/.claude/commands/handover.md" \
           "${DSH_HOME:-$HOME/.dsh}/skills/handover" \
           "$HOME/.workbuddy/skills/handover" \
           "$HOME/.zcode/skills/handover" \
           "$HOME/.qoder/skills/handover"; do
    if [ -e "$p" ]; then
      rm -rf "$p"
      echo "  ✔ 删除 $p"
    fi
  done
  echo "完成。"
}

case "${1:-}" in
  -h|--help)    usage ;;
  --uninstall)  do_uninstall ;;
  --all)        do_project; do_codex; do_cc; do_dsh; do_workbuddy; do_zcode; do_qoder ;;
  --project)    do_project ;;
  --codex)      do_codex ;;
  --cc)         do_cc ;;
  --dsh)        do_dsh ;;
  --workbuddy)  do_workbuddy ;;
  --zcode)      do_zcode ;;
  --trae)       do_trae ;;
  --qoder)      do_qoder ;;
  "")           do_project ;;
  *)            echo "未知参数: $1"; usage; exit 1 ;;
esac

[ "${1:-}" = "--uninstall" ] || echo "装好了。新开一个会话即可生效。"
