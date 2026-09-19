# 🧩 Skills

我的 AI 编程工具skill包。复制即用，不装任何依赖。

## 为什么会有这个仓库

用 AI 写代码，坑往往不在「它写不出来」，而在这些反复出现的地方：

- **会话一断，上下文全丢。** 新会话什么都不记得，你又得把项目背景、已经做了什么、踩过哪些坑重新讲一遍 → [handover](handover/)
- **让它改一处，它顺手改一片。** 修一个 bug 顺带重构三个文件、格式化整个目录、还把依赖升了一版，diff 从 20 行变 800 行 → [minipatch](minipatch/)
- **自己审自己，等于没审。** 说一句「检查一下代码」，它回你「整体结构清晰，建议补充测试」，看着挺认真，什么也没查出来 → [coldreview](coldreview/)
- **同一条规则要配 N 遍。** Codex 读 `AGENTS.md`、Claude Code 读 `CLAUDE.md`、Trae 读 `.trae/rules/`、Qoder 读 skills 目录……同一个诉求得按每个工具的格式各写一份

这个仓库把这些应对方法沉淀成可以直接复制的 Markdown，装一次就不用每次重复交代。

## 技能清单

| Skill | 一句话定位 | 适用平台 |
|-------|-----------|----------|
| [🔄 handover](handover/) | 长会话结束前写一份交接文档，新会话读文档就能接着干 | 全平台 |
| [🩹 minipatch](minipatch/) | 最小改动原则：先报变更计划再动手，只改该改的文件，不重构、不升级依赖 | 全平台 |
| [🔍 coldreview](coldreview/) | 代码自审：切换成 Reviewer 角色，只查边界条件、异常处理、性能瓶颈、安全风险，出清单不改代码 | 全平台 |

## ⚡ 最快：让 AI 自己装

不用 clone 仓库，也不用记每个工具的规则目录在哪。**把下面这段话粘给你在用的任意 AI 编程工具**，它会自己下载、自己放对位置。

```text
帮我装这几个 skill，内容在下面这些链接里：
- https://raw.githubusercontent.com/konlue/skills/main/minipatch/SKILL.md
- https://raw.githubusercontent.com/konlue/skills/main/handover/SKILL.md
- https://raw.githubusercontent.com/konlue/skills/main/coldreview/SKILL.md

每个链接按下面的规则落位，只追加、不要覆盖目标文件里已有的内容：
- Codex / Cursor / OpenCode / Pi / DSH / Zcode / Qoder → 项目根目录的 AGENTS.md
- Claude Code → CLAUDE.md，再复制一份到 .claude/commands/<skill 名>.md
- Trae → .trae/rules/<skill 名>.md
- WorkBuddy → .workbuddy/skills/<skill 名>/SKILL.md

装完告诉我你改了哪些文件。
```

只装一个的话，删掉多余链接就行；工具够聪明时一句话也够：

```text
帮我装这个 skill：https://raw.githubusercontent.com/konlue/skills/main/minipatch/SKILL.md
```

> 链接规律：`https://raw.githubusercontent.com/konlue/skills/main/<skill 名>/SKILL.md`
> 访问不稳时，把 `raw.githubusercontent.com/konlue/skills/main/` 换成 `cdn.jsdelivr.net/gh/konlue/skills@main/` 即可。

## 30 秒上手

想省事就用上一节的方式。这里给的是命令行装法。

### 🔄 handover

安装：用它自带的一键脚本，或手动复制到对应平台目录。

```bash
cd handover && ./install.sh --all      # 全平台
cd handover && ./install.sh --cc       # 只装 Claude Code
cd handover && ./install.sh --trae     # 只装 Trae
```

使用：

```text
会话结束前说 → 请写一份交接文档存到 CONTINUE.md
新会话第一句 → 先读 CONTINUE.md
```

### 🩹 minipatch

安装：用它自带的一键脚本，或手动复制到对应平台目录。

```bash
cd minipatch && ./install.sh --all      # 全平台
cd minipatch && ./install.sh --cc       # 只装 Claude Code
cd minipatch && ./install.sh --trae     # 只装 Trae
```

使用：改代码前加一句，AI 会先给变更计划等你确认。

```text
/minipatch 修一下 src/api/user.ts 里 id 为空时的崩溃
```

> Claude Code / Qoder 里输入 `/minipatch`；Trae 里用 `#Rule minipatch`；其他平台直接说「按 minipatch 的原则改」。

### 🔍 coldreview

安装：

```bash
cd coldreview && ./install.sh --all      # 全平台
```

使用：提交 PR 前加一句。

```text
现在切换成资深 Reviewer，不要修改代码，只检查这 4 件事：
边界条件、异常处理、性能瓶颈、安全风险。按严重程度列出问题，并给出最小修改方案。
```

装成常驻规则后，AI 完成非平凡实现会自己来一轮，不用你开口。

> Claude Code / Qoder 里输入 `/coldreview`；Trae 里用 `#Rule coldreview`；Cursor 里用 `@coldreview`。

## 适配的平台

这些 skill 都是纯 Markdown，靠各 AI 工具自己的规则机制生效，不绑定任何特定工具：

| 平台 | 规则 / 技能放哪 |
|------|----------------|
| Codex | `AGENTS.md` |
| Claude Code | `CLAUDE.md`、`.claude/commands/` |
| Cursor | `.cursor/rules/*.mdc`（或 `AGENTS.md`） |
| OpenCode | `AGENTS.md`、`~/.config/opencode/AGENTS.md` |
| Pi | `AGENTS.md`、`~/.pi/agent/AGENTS.md` |
| DSH | `AGENTS.md`、`~/.dsh/skills/` |
| WorkBuddy | `~/.workbuddy/skills/` |
| Zcode | `AGENTS.md`、`~/.zcode/skills/` |
| Trae | `.trae/rules/` |
| Qoder | `AGENTS.md`、`~/.qoder/skills/` |

每个 skill 目录下的 README 里有更详细的安装说明和关闭方式。

## License

MIT
