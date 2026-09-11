# 🩹 Minipatch

**改代码前先报计划，只改该改的文件，不重构、不升级依赖。**

一个跨平台的最小改动原则约束，适用于 Codex、Claude Code、DSH、WorkBuddy、Zcode、Trae、Qoder。

## 解决什么问题

你让 AI 修一个 bug，它顺手重构了三个无关文件、格式化了整个目录、还把 `package.json` 里的依赖全升了一版。diff 从 20 行变成 800 行，Review 成本爆炸，还可能引入新 Bug。

Minipatch 把这个「最小改动原则」固化成规则，让 AI 在动任何已有代码之前：

1. 先列出**变更计划**（改哪些文件、改什么、为什么）
2. **等你确认**再动手
3. 只改计划内的文件
4. 结束后输出**改动摘要 + 越界自检**

## 安装

选你用的平台，一行搞定。所有平台共用同一份 `SKILL.md`，内容完全一致。

| 平台 | 装到哪 | 生效范围 |
|------|--------|----------|
| **Codex** | `AGENTS.md`（追加） | 当前项目 |
| **Claude Code** | `CLAUDE.md`（追加）+ `.claude/commands/minipatch.md` | 当前项目 + `/minipatch` 命令 |
| **DSH** | `~/.dsh/skills/minipatch/SKILL.md` | 全局（项目级用 `.dsh/skills/`） |
| **WorkBuddy** | `~/.workbuddy/skills/minipatch/SKILL.md` | 全局（项目级用 `.workbuddy/skills/`） |
| **Zcode** | `~/.zcode/skills/minipatch/SKILL.md` | 全局 |
| **Trae** | `.trae/rules/minipatch.md` | 当前项目（需在设置里开启规则读取） |
| **Qoder** | `~/.qoder/skills/minipatch/SKILL.md` | 全局（项目级用 `.qoder/skills/`） |

### 方式一：一键脚本

```bash
./install.sh                 # 项目级：写 AGENTS.md + Trae 规则 + Claude 命令
./install.sh --cc            # 额外装 Claude Code 的 /minipatch 命令
./install.sh --codex         # Codex：追加到 ~/.codex/AGENTS.md
./install.sh --dsh           # DSH：装到 ~/.dsh/skills/
./install.sh --workbuddy     # WorkBuddy：装到 ~/.workbuddy/skills/
./install.sh --zcode         # Zcode：装到 ~/.zcode/skills/
./install.sh --trae          # Trae：装到 .trae/rules/
./install.sh --qoder         # Qoder：装到 ~/.qoder/skills/
./install.sh --all           # 全平台，一次装完
./install.sh --uninstall     # 撤掉装过的所有内容
```

脚本用 `<!-- minipatch:start/end -->` 标记包裹追加内容，重复运行不会产生重复副本，`--uninstall` 能干净移除。

### 方式二：手动复制

```bash
# 通用（Codex / DSH / Zcode / Qoder 走 AGENTS.md 的平台）
cat minipatch/SKILL.md >> AGENTS.md

# Claude Code
cat minipatch/SKILL.md >> CLAUDE.md
mkdir -p .claude/commands && cp minipatch/SKILL.md .claude/commands/minipatch.md

# 走 skills 目录的平台
mkdir -p ~/.workbuddy/skills/minipatch && cp minipatch/SKILL.md ~/.workbuddy/skills/minipatch/
mkdir -p ~/.dsh/skills/minipatch       && cp minipatch/SKILL.md ~/.dsh/skills/minipatch/
mkdir -p ~/.zcode/skills/minipatch     && cp minipatch/SKILL.md ~/.zcode/skills/minipatch/
mkdir -p ~/.qoder/skills/minipatch     && cp minipatch/SKILL.md ~/.qoder/skills/minipatch/

# Trae
mkdir -p .trae/rules && cp minipatch/SKILL.md .trae/rules/minipatch.md
```

Trae 用户注意：项目规则默认读取 `AGENTS.md` / `CLAUDE.md` 的开关需要在 `设置 → 规则 → 导入设置` 里打开；用 `.trae/rules/` 目录则无需开关。

## 使用

### 自动生效

装到 `AGENTS.md` / `CLAUDE.md` / skills 目录后，每次会话自动加载，不用手动触发。

### 手动触发

- **Claude Code / Qoder**：输入 `/minipatch` 
- **Trae**：聊天框输入 `#Rule minipatch`
- **其他平台**：直接说「按 minipatch 的原则改」

典型用法——高风险改动前加一句：

```
/minipatch 修一下 src/api/user.ts 里空值导致的崩溃
```

AI 会先输出变更计划等你确认，而不是直接改代码。

## 临时关闭

以下情况建议关掉，否则 AI 会束手束脚：

- 从 0 到 1 的新项目、脚手架搭建
- 你本来就要做的大规模重构
- 空目录、一次性生成的 demo

**关闭方式：**

| 场景 | 怎么做 |
|------|--------|
| 临时一次 | 对话里说「这次放开限制，随便改」或「大改模式」 |
| 单个项目 | 删掉项目里的 minipatch 段落 / `.trae/rules/minipatch.md`，或运行 `./install.sh --uninstall` |
| 全局 | 删掉对应的 `~/.xxx/skills/minipatch/` 目录 |

规则本身也内置了自动让位条件：用户明确说「重构吧 / 重写 / 随便改」，或面对全新项目时，约束自动解除。

## 验收测试

装完可以用这三句话验证是否生效：

1. **越界测试** → "修一下 `src/a.ts` 第 20 行的类型错误"
   预期：只改 `a.ts`，不碰同目录其他文件，不改任何依赖。
2. **依赖测试** → "顺便把依赖升到最新版"
   预期：先说明影响并请求确认，未确认前不执行。
3. **跨文件测试** → 故意提一个需要改两个文件的需求
   预期：先列出两个文件和理由，等你点头才动手。

## 变更计划长什么样

```markdown
### 变更计划

**目标**：修复用户接口在 id 为空时的崩溃

**计划修改**

| 文件 | 改动点 | 理由 |
|------|--------|------|
| src/api/user.ts:42 | 增加空值判断 | 修复 #123 |

**不会改动**

- 其他文件（包括风格不一致的部分）
- 任何依赖版本

**风险**：无

确认后执行。
```

完整模板见 [CHANGE-PLAN.md](CHANGE-PLAN.md)。

## License

MIT
