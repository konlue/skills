#!/usr/bin/env bash
# Stoprule installer — 把「优化停止条件」skill 装到各个 AI 编程工具里
# 用法: ./install.sh [--all|--project|--codex|--cc|--cursor|--opencode|--pi|--dsh|--workbuddy|--zcode|--trae|--qoder|--uninstall]
set -euo pipefail

RAW_BASE="https://raw.githubusercontent.com/konlue/skills/main/stoprule"
MARK_START="<!-- stoprule:start -->"
MARK_END="<!-- stoprule:end -->"

# 用 curl ... | bash 这种方式运行时没有脚本文件，BASH_SOURCE 不可用，走下载分支
SCRIPT_DIR=""
if [ -n "${BASH_SOURCE[0]:-}" ] && [ -f "${BASH_SOURCE[0]}" ]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fi

TMP_SRC=""
cleanup() { [ -n "$TMP_SRC" ] && [ -f "$TMP_SRC" ] && rm -f "$TMP_SRC"; return 0; }
trap cleanup EXIT

SRC="$SCRIPT_DIR/SKILL.md"

if [ ! -f "$SRC" ]; then
  if command -v curl >/dev/null 2>&1; then
    TMP_SRC="$(mktemp 2>/dev/null || echo "${TMPDIR:-.}/stoprule-SKILL.md.$$")"
    echo "本地没有 SKILL.md，从 $RAW_BASE 下载..."
    curl -fsSL "$RAW_BASE/SKILL.md" -o "$TMP_SRC" || {
      echo "下载失败，检查网络或改用本地运行：./install.sh" >&2; exit 1; }
    SRC="$TMP_SRC"
  else
    echo "找不到 SKILL.md，请在 stoprule 目录下运行本脚本，或安装 curl" >&2
    exit 1
  fi
fi

usage() {
  cat <<'EOF'
Stoprule — 优化停止条件（知道什么时候该停）

用法:
  ./install.sh                 项目级安装（AGENTS.md + Trae 规则）
  ./install.sh --project       同上
  ./install.sh --codex         Codex:  追加到 ~/.codex/AGENTS.md
  ./install.sh --cc            Claude Code: CLAUDE.md + .claude/commands/stoprule.md
  ./install.sh --cursor        Cursor:  .cursor/rules/stoprule.mdc
  ./install.sh --opencode      OpenCode: 追加到 ~/.config/opencode/AGENTS.md
  ./install.sh --pi            Pi:      追加到 ~/.pi/agent/AGENTS.md
  ./install.sh --dsh           DSH:    ~/.dsh/skills/stoprule/SKILL.md
  ./install.sh --workbuddy     WorkBuddy: ~/.workbuddy/skills/stoprule/SKILL.md
  ./install.sh --zcode         Zcode:  ~/.zcode/skills/stoprule/SKILL.md
  ./install.sh --trae          Trae:   .trae/rules/stoprule.md
  ./install.sh --qoder         Qoder:  ~/.qoder/skills/stoprule/SKILL.md
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

# 从文件里剥掉旧的 stoprule 段落（幂等 + 可卸载，不动文件其余内容）
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

# 把 stoprule 段落追加到目标文件
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
  cp "$SRC" "$PWD/.claude/commands/stoprule.md"
  echo "  ✔ 安装到 .claude/commands/stoprule.md（对话里输入 /stoprule 触发）"
}

do_cursor() {
  echo "[Cursor] 项目规则"
  local file="$PWD/.cursor/rules/stoprule.mdc"
  mkdir -p "$(dirname "$file")"
  {
    echo "---"
    echo "description: 优化停止条件——先建基线、定目标与测量方法，收益超过成本阈值才实施，否则停止并记录取舍"
    echo "alwaysApply: true"
    echo "---"
    echo
    body
  } > "$file"
  echo "  ✔ 安装到 $file（对话里 @stoprule 可手动引用）"
}

do_opencode() {
  echo "[OpenCode] 全局指令"
  append_block "${OPENCODE_CONFIG_HOME:-$HOME/.config/opencode}/AGENTS.md"
}

do_pi() {
  echo "[Pi] 全局指令"
  append_block "$HOME/.pi/agent/AGENTS.md"
}

do_dsh() {
  echo "[DSH] 全局 skill"
  install_skill_dir "${DSH_HOME:-$HOME/.dsh}/skills/stoprule"
}

do_workbuddy() {
  echo "[WorkBuddy] 全局 skill"
  install_skill_dir "$HOME/.workbuddy/skills/stoprule"
}

do_zcode() {
  echo "[Zcode] 全局 skill"
  install_skill_dir "$HOME/.zcode/skills/stoprule"
}

do_trae() {
  echo "[Trae] 项目规则"
  local file="$PWD/.trae/rules/stoprule.md"
  mkdir -p "$(dirname "$file")"
  {
    echo "---"
    echo "description: 优化停止条件——先建基线、定目标与测量方法，收益超过成本阈值才实施，否则停止并记录取舍"
    echo "alwaysApply: true"
    echo "---"
    echo
    body
  } > "$file"
  echo "  ✔ 安装到 $file"
}

do_qoder() {
  echo "[Qoder] 全局 skill"
  install_skill_dir "$HOME/.qoder/skills/stoprule"
}

# 只剩空行说明这个文件是我们安装时新建的，连文件一起删掉，不留空壳
prune_if_empty() {
  local file="$1"
  [ -f "$file" ] || return 0
  grep -qE '[^[:space:]]' "$file" && return 0
  rm -f "$file"
  rmdir "$(dirname "$file")" 2>/dev/null || true
  echo "  ✔ 删除空文件 $file"
}

do_uninstall() {
  echo "移除 stoprule..."
  for f in "$PWD/AGENTS.md" "$PWD/CLAUDE.md" \
           "${CODEX_HOME:-$HOME/.codex}/AGENTS.md" \
           "${DSH_HOME:-$HOME/.dsh}/AGENTS.md" \
           "${OPENCODE_CONFIG_HOME:-$HOME/.config/opencode}/AGENTS.md" \
           "$HOME/.pi/agent/AGENTS.md"; do
    if [ -f "$f" ] && grep -qF "$MARK_START" "$f"; then
      strip_block "$f"
      echo "  ✔ 清理 $f"
      prune_if_empty "$f"
    fi
  done
  for p in "$PWD/.trae/rules/stoprule.md" "$PWD/.cursor/rules/stoprule.mdc" \
           "$PWD/.claude/commands/stoprule.md" \
           "${DSH_HOME:-$HOME/.dsh}/skills/stoprule" \
           "$HOME/.workbuddy/skills/stoprule" \
           "$HOME/.zcode/skills/stoprule" \
           "$HOME/.qoder/skills/stoprule"; do
    if [ -e "$p" ]; then
      rm -rf "$p"
      echo "  ✔ 删除 $p"
    fi
  done
  echo "完成。"
}

# 支持多个参数：./install.sh --cc --cursor --trae
if [ "$#" -eq 0 ]; then
  set -- --project
fi

ran_uninstall=0
for arg in "$@"; do
  case "$arg" in
    -h|--help)    usage; exit 0 ;;
    --uninstall)  do_uninstall; ran_uninstall=1 ;;
    --all)        do_project; do_codex; do_cc; do_cursor; do_opencode; do_pi; do_dsh; do_workbuddy; do_zcode; do_qoder ;;
    --project)    do_project ;;
    --codex)      do_codex ;;
    --cc)         do_cc ;;
    --cursor)     do_cursor ;;
    --opencode)   do_opencode ;;
    --pi)         do_pi ;;
    --dsh)        do_dsh ;;
    --workbuddy)  do_workbuddy ;;
    --zcode)      do_zcode ;;
    --trae)       do_trae ;;
    --qoder)      do_qoder ;;
    "")           do_project ;;
    *)            echo "未知参数: $arg"; usage; exit 1 ;;
  esac
done

[ "$ran_uninstall" -eq 1 ] || echo "装好了。新开一个会话即可生效。"
