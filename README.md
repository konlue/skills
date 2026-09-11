# 🧩 Skills

给 AI 编程工具用的小技能包。纯 Markdown，复制即用，不装任何依赖。

## 为什么会有这个仓库

用 AI 写代码，坑往往不在「它写不出来」，而在这些反复出现的地方：

- **会话一断，上下文全丢。** 新会话什么都不记得，你又得把项目背景、已经做了什么、踩过哪些坑重新讲一遍 → [handover](handover/)
- **让它改一处，它顺手改一片。** 修一个 bug 顺带重构三个文件、格式化整个目录、还把依赖升了一版，diff 从 20 行变 800 行 → [minipatch](minipatch/)
- **同一条规则要配 N 遍。** Codex 读 `AGENTS.md`、Claude Code 读 `CLAUDE.md`、Trae 读 `.trae/rules/`、Qoder 读 skills 目录……同一个诉求得按每个工具的格式各写一份

这个仓库把这些应对方法沉淀成可以直接复制的 Markdown，装一次就不用每次重复交代。

## 技能清单

| Skill | 一句话定位 | 适用平台 |
|-------|-----------|----------|
| [🔄 handover](handover/) | 长会话结束前写一份交接文档，新会话读文档就能接着干 | Claude Code、Codex |
| [🩹 minipatch](minipatch/) | 最小改动原则：先报变更计划再动手，只改该改的文件，不重构、不升级依赖 | 全平台（Codex / Claude Code / DSH / WorkBuddy / Zcode / Trae / Qoder） |

## 30 秒上手

### 🔄 handover

装：把 `handover/SKILL.md` 复制到你的项目里。

```bash
mkdir -p .claude && cp handover/SKILL.md .claude/session-handoff.md   # Claude Code
mkdir -p codex-instructions && cp handover/SKILL.md codex-instructions/session-handoff.md  # Codex
```

用：

```text
会话结束前说 → 请写一份交接文档存到 CONTINUE.md
新会话第一句 → 先读 CONTINUE.md
```

### 🩹 minipatch

装：用它自带的一键脚本，或手动复制到对应平台目录。

```bash
cd minipatch && ./install.sh --all      # 全平台
cd minipatch && ./install.sh --cc       # 只装 Claude Code
cd minipatch && ./install.sh --trae     # 只装 Trae
```

用：改代码前加一句，AI 会先给变更计划等你确认。

```text
/minipatch 修一下 src/api/user.ts 里 id 为空时的崩溃
```

> Claude Code / Qoder 里输入 `/minipatch`；Trae 里用 `#Rule minipatch`；其他平台直接说「按 minipatch 的原则改」。

## 适配的平台

这些 skill 都是纯 Markdown，靠各 AI 工具自己的规则机制生效，不绑定任何特定工具：

| 平台 | 规则 / 技能放哪 |
|------|----------------|
| Codex | `AGENTS.md` |
| Claude Code | `CLAUDE.md`、`.claude/commands/` |
| DSH | `AGENTS.md`、`~/.dsh/skills/` |
| WorkBuddy | `~/.workbuddy/skills/` |
| Zcode | `AGENTS.md`、`~/.zcode/skills/` |
| Trae | `.trae/rules/` |
| Qoder | `AGENTS.md`、`~/.qoder/skills/` |

每个 skill 目录下的 README 里有更详细的安装说明和关闭方式。

## License

MIT
