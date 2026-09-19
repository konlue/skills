# 🔍 Coldreview

**让 AI 写完代码后，切换成 Reviewer 审自己：只查四件事，只出清单，不动手改。**

适用于 Codex、Claude Code、Cursor、OpenCode、Pi、DSH、WorkBuddy、Zcode、Trae、Qoder。

## 解决什么问题

「检查一下代码」这句话基本没用。AI 会回你一段「整体结构清晰，建议增加单元测试」——看着挺认真，什么也没查出来。

原因很简单：同一次会话里，写代码的人和审代码的人是同一个模型，它会为自己的实现辩护。「我这么写是因为……」，于是真正的漏洞被合理化掉了。

Coldreview 用三条硬约束破这个局：**换角色、禁止动手改、限定只查四件事**。

```text
现在切换成资深 Reviewer，不要修改代码，只检查这 4 件事：
边界条件、异常处理、性能瓶颈、安全风险。
按严重程度列出问题，并给出最小修改方案。
```

把这句贴在提交 PR 之前，效果比「检查一下代码」好得多。

## 安装

选你用的平台，一行搞定。所有平台共用同一份 `SKILL.md`，内容完全一致。

| 平台 | 装到哪 | 生效范围 |
|------|--------|----------|
| **Codex** | `AGENTS.md`（追加） | 当前项目 |
| **Claude Code** | `CLAUDE.md`（追加）+ `.claude/commands/coldreview.md` | 当前项目 + `/coldreview` 命令 |
| **Cursor** | `.cursor/rules/coldreview.mdc` | 当前项目（`@coldreview` 可手动引用） |
| **OpenCode** | `~/.config/opencode/AGENTS.md`（追加） | 全局 |
| **Pi** | `~/.pi/agent/AGENTS.md`（追加） | 全局 |
| **DSH** | `~/.dsh/skills/coldreview/SKILL.md` | 全局（项目级用 `.dsh/skills/`） |
| **WorkBuddy** | `~/.workbuddy/skills/coldreview/SKILL.md` | 全局（项目级用 `.workbuddy/skills/`） |
| **Zcode** | `~/.zcode/skills/coldreview/SKILL.md` | 全局 |
| **Trae** | `.trae/rules/coldreview.md` | 当前项目（需在设置里开启规则读取） |
| **Qoder** | `~/.qoder/skills/coldreview/SKILL.md` | 全局（项目级用 `.qoder/skills/`） |

### 方式一：让 AI 自己装（最省事）

不用记路径，**把这段话直接粘给你在用的任意 AI 编程工具的对话框**：

```text
帮我装一个 skill。内容在这里：
https://raw.githubusercontent.com/konlue/skills/main/coldreview/SKILL.md

按下面的位置安装，只追加、不要覆盖目标文件里已有的内容：
- Codex / Cursor / OpenCode / Pi / DSH / Zcode / Qoder → 项目根目录的 AGENTS.md
- Claude Code → CLAUDE.md，再复制一份到 .claude/commands/coldreview.md
- Trae → .trae/rules/coldreview.md
- WorkBuddy → .workbuddy/skills/coldreview/SKILL.md

装完告诉我你改了哪些文件。
```

如果你用的工具能猜对位置，其实一句话就够：

```text
帮我装这个 skill：https://raw.githubusercontent.com/konlue/skills/main/coldreview/SKILL.md
```

> `raw.githubusercontent.com` 访问不稳时，把链接换成 jsDelivr：
> `https://cdn.jsdelivr.net/gh/konlue/skills@main/coldreview/SKILL.md`

### 方式二：一键脚本

```bash
./install.sh                 # 项目级：追加到 AGENTS.md + 生成 Trae 规则
./install.sh --project       # 同上
./install.sh --cc            # Claude Code：CLAUDE.md + .claude/commands/coldreview.md
./install.sh --cursor        # Cursor：.cursor/rules/coldreview.mdc
./install.sh --opencode      # OpenCode：~/.config/opencode/AGENTS.md
./install.sh --pi            # Pi：~/.pi/agent/AGENTS.md
./install.sh --codex         # Codex：追加到 ~/.codex/AGENTS.md
./install.sh --dsh           # DSH：装到 ~/.dsh/skills/
./install.sh --workbuddy     # WorkBuddy：装到 ~/.workbuddy/skills/
./install.sh --zcode         # Zcode：装到 ~/.zcode/skills/
./install.sh --trae          # Trae：装到 .trae/rules/
./install.sh --qoder         # Qoder：装到 ~/.qoder/skills/
./install.sh --all           # 全平台，一次装完
./install.sh --uninstall     # 撤掉装过的所有内容

# 不想 clone 整个仓库，也可以直接跑远端脚本
curl -fsSL https://raw.githubusercontent.com/konlue/skills/main/coldreview/install.sh | bash -s -- --all
```

脚本用 `<!-- coldreview:start/end -->` 标记包裹追加内容，重复运行不会产生重复副本，`--uninstall` 能干净移除。

### 方式三：手动复制

```bash
# 通用（Codex / DSH / Zcode / Qoder 走 AGENTS.md 的平台）
cat coldreview/SKILL.md >> AGENTS.md

# Claude Code
cat coldreview/SKILL.md >> CLAUDE.md
mkdir -p .claude/commands && cp coldreview/SKILL.md .claude/commands/coldreview.md

# Cursor（必须用 .mdc 扩展名，.md 会被忽略）
mkdir -p .cursor/rules && cp coldreview/SKILL.md .cursor/rules/coldreview.mdc

# OpenCode / Pi
cat coldreview/SKILL.md >> ~/.config/opencode/AGENTS.md
cat coldreview/SKILL.md >> ~/.pi/agent/AGENTS.md

# 走 skills 目录的平台
mkdir -p ~/.workbuddy/skills/coldreview && cp coldreview/SKILL.md ~/.workbuddy/skills/coldreview/
mkdir -p ~/.dsh/skills/coldreview       && cp coldreview/SKILL.md ~/.dsh/skills/coldreview/
mkdir -p ~/.zcode/skills/coldreview     && cp coldreview/SKILL.md ~/.zcode/skills/coldreview/
mkdir -p ~/.qoder/skills/coldreview     && cp coldreview/SKILL.md ~/.qoder/skills/coldreview/

# Trae
mkdir -p .trae/rules && cp coldreview/SKILL.md .trae/rules/coldreview.md
```

Trae 用户注意：项目规则默认读取 `AGENTS.md` / `CLAUDE.md` 的开关需要在 `设置 → 规则 → 导入设置` 里打开；用 `.trae/rules/` 目录则无需开关。

## 使用

### 手动触发

- **Claude Code / Qoder**：输入 `/coldreview`
- **Trae**：聊天框输入 `#Rule coldreview`
- **Cursor**：聊天框输入 `@coldreview`
- **其他平台**：直接说「审一下」「PR 前检查一下」

最直接的那一句：

```text
现在切换成资深 Reviewer，不要修改代码，只检查这 4 件事：
边界条件、异常处理、性能瓶颈、安全风险。按严重程度列出问题，并给出最小修改方案。
```

### 自动生效

装到 `AGENTS.md` / `CLAUDE.md` / skills 目录后成为常驻规则，AI 会在这些时候自己来一轮：

- 刚完成一段非平凡实现（多文件改动、新增接口、涉及外部输入 / 数据库 / 并发 / 权限）
- 你说「可以提交了」「提个 PR」
- 修完一轮自审的问题后，重扫确认没引入新问题

小改动、纯文档 / 格式化不会触发，不会拖慢日常节奏。

## 输出长什么样

```markdown
## 自审结果：src/api/user.ts

**结论**：建议修完 2 个 🟡 再提交

### 🔴 严重（阻塞提交）

**1. `src/api/user.ts:42` — id 为空时直接 500**
- 为什么：`id` 未经校验就传给 `findById`，空值时抛异常，整个请求失败
- 最小改法：
  ```ts
  if (!id) return res.status(400).json({ error: 'missing id' })
  ```

**逐项结论**

| 检查项 | 结果 |
|--------|------|
| 边界条件 | 1 🔴 1 🟡 |
| 异常处理 | 未发现 |
| 性能瓶颈 | 1 🔵 |
| 安全风险 | 未发现 |
```

分级：**🔴 严重**（会崩 / 数据错 / 安全漏洞，阻塞提交）、**🟡 重要**（特定场景下出错，建议修）、**🔵 建议**（有改进空间）、**⚪ 可选**（风格命名）。

每个问题必须带三样东西：位置、为什么是问题、最小改法。缺一样就不算一个问题。

## 想要更深的自审

`SKILL.md` 里内置的是精简版检查点。想审得更细，把 [CHECKLIST.md](CHECKLIST.md) 一起喂给 AI——四件事各展开了 15～25 条具体检查项（浮点精度、时区、重试幂等、N+1、越权、日志脱敏……）。

## 和 minipatch 怎么配合

| | 管什么 | 什么时候用 |
|---|---|---|
| [minipatch](../minipatch/) | 改之前：先报计划，只改该改的 | 动手改代码前 |
| **coldreview** | 改之后：换角色审一遍 | 提交 / 提 PR 前 |

两个不冲突，可以都装：按 minipatch 改，按 coldreview 审。

## 卸载提示

`./install.sh --uninstall` 会删除各平台下 `skills/coldreview/` 整个目录。如果你在里面放了自己的文件，先手动取出来。

## License

MIT
