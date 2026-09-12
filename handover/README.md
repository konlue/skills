# 🔄 Handover

**长会话结束前写交接文档，新会话读完直接干活。**

适用于 Codex、Claude Code、Cursor、OpenCode、Pi、DSH、WorkBuddy、Zcode、Trae、Qoder。

## 解决什么问题

AI 编程会话有上下文上限。会话断了之后，新对话什么都不记得——你得重新解释项目背景、已经做了什么、踩过哪些坑。

这个 Skill 让 AI 在会话结束前把进度写进 `CONTINUE.md`，下次开新会话只要说「先读 CONTINUE.md」，它就能无缝接上。

## 安装

选你用的平台，一行搞定。所有平台共用同一份 `SKILL.md`，内容完全一致。

| 平台 | 装到哪 | 生效范围 |
|------|--------|----------|
| **Codex** | `AGENTS.md`（追加） | 当前项目 |
| **Claude Code** | `CLAUDE.md`（追加）+ `.claude/commands/handover.md` | 当前项目 + `/handover` 命令 |
| **Cursor** | `.cursor/rules/handover.mdc` | 当前项目（`@handover` 可手动引用） |
| **OpenCode** | `~/.config/opencode/AGENTS.md`（追加） | 全局 |
| **Pi** | `~/.pi/agent/AGENTS.md`（追加） | 全局 |
| **DSH** | `~/.dsh/skills/handover/SKILL.md` | 全局（项目级用 `.dsh/skills/`） |
| **WorkBuddy** | `~/.workbuddy/skills/handover/SKILL.md` | 全局（项目级用 `.workbuddy/skills/`） |
| **Zcode** | `~/.zcode/skills/handover/SKILL.md` | 全局 |
| **Trae** | `.trae/rules/handover.md` | 当前项目（需在设置里开启规则读取） |
| **Qoder** | `~/.qoder/skills/handover/SKILL.md` | 全局（项目级用 `.qoder/skills/`） |

### 方式一：让 AI 自己装（最省事）

不用记路径，**把这段话直接粘给你在用的任意 AI 编程工具的对话框**：

```text
帮我装一个 skill。内容在这里：
https://raw.githubusercontent.com/konlue/skills/main/handover/SKILL.md

按下面的位置安装，只追加、不要覆盖目标文件里已有的内容：
- Codex / Cursor / OpenCode / Pi / DSH / Zcode / Qoder → 项目根目录的 AGENTS.md
- Claude Code → CLAUDE.md，再复制一份到 .claude/commands/handover.md
- Trae → .trae/rules/handover.md
- WorkBuddy → .workbuddy/skills/handover/SKILL.md

装完告诉我你改了哪些文件。
```

如果你用的工具能猜对位置，其实一句话就够：

```text
帮我装这个 skill：https://raw.githubusercontent.com/konlue/skills/main/handover/SKILL.md
```

> `raw.githubusercontent.com` 访问不稳时，把链接换成 jsDelivr：
> `https://cdn.jsdelivr.net/gh/konlue/skills@main/handover/SKILL.md`

### 方式二：一键脚本

```bash
./install.sh                 # 项目级：追加到 AGENTS.md + 生成 Trae 规则
./install.sh --project       # 同上
./install.sh --cc            # Claude Code：CLAUDE.md + .claude/commands/handover.md
./install.sh --cursor        # Cursor：.cursor/rules/handover.mdc
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
curl -fsSL https://raw.githubusercontent.com/konlue/skills/main/handover/install.sh | bash -s -- --all
```

脚本用 `<!-- handover:start/end -->` 标记包裹追加内容，重复运行不会产生重复副本，`--uninstall` 能干净移除。

### 方式三：手动复制

```bash
# 通用（Codex / DSH / Zcode / Qoder 走 AGENTS.md 的平台）
cat handover/SKILL.md >> AGENTS.md

# Claude Code
cat handover/SKILL.md >> CLAUDE.md
mkdir -p .claude/commands && cp handover/SKILL.md .claude/commands/handover.md

# Cursor（必须用 .mdc 扩展名，.md 会被忽略）
mkdir -p .cursor/rules && cp handover/SKILL.md .cursor/rules/handover.mdc

# OpenCode / Pi
cat handover/SKILL.md >> ~/.config/opencode/AGENTS.md
cat handover/SKILL.md >> ~/.pi/agent/AGENTS.md

# 走 skills 目录的平台
mkdir -p ~/.workbuddy/skills/handover && cp handover/SKILL.md ~/.workbuddy/skills/handover/
mkdir -p ~/.dsh/skills/handover       && cp handover/SKILL.md ~/.dsh/skills/handover/
mkdir -p ~/.zcode/skills/handover     && cp handover/SKILL.md ~/.zcode/skills/handover/
mkdir -p ~/.qoder/skills/handover     && cp handover/SKILL.md ~/.qoder/skills/handover/

# Trae
mkdir -p .trae/rules && cp handover/SKILL.md .trae/rules/handover.md
```

Trae 用户注意：项目规则默认读取 `AGENTS.md` / `CLAUDE.md` 的开关需要在 `设置 → 规则 → 导入设置` 里打开；用 `.trae/rules/` 目录则无需开关。

## 使用

### 1. 会话结束前

输入：

```text
请写一份交接文档存到 CONTINUE.md
```

AI 会根据当前对话，在项目根目录生成 `CONTINUE.md`：

| 模块 | 内容 |
|------|------|
| **当前任务** | 我们在做什么，目标是什么 |
| **已完成** | 做了哪些，哪些只做了一半 |
| **当前状态** | 卡在哪，有什么未解决的问题 |
| **下一步计划** | 接下来做什么，优先级 |
| **踩坑记录** | 试过但不行的方案，避免重复踩坑 |
| **关键上下文** | 新会话需要知道的背景信息 |

### 2. 开新会话时

第一句话：

```text
先读 CONTINUE.md
```

读完直接继续工作，不需要重新解释任何东西。

## 什么时候写

不用等会话「正式结束」。任何有进展的时刻都可以写一次，覆盖更新就行：

- 实现了一个重要功能后
- 踩了一个大坑、搞清楚原因后
- 准备切换到另一个任务前
- 上下文快满了、准备开新会话前

装好之后，AI 在这些时机会主动提醒你写——但不会不问自取地直接动笔。

## 手动触发

- **Claude Code / Qoder**：输入 `/handover`
- **Trae**：聊天框输入 `#Rule handover`
- **Cursor**：聊天框输入 `@handover`
- **其他平台**：直接说「写份交接文档」

## Tips

- **踩坑记录最有价值** — 写详细点，包括报错信息、尝试过的方案、为什么不行
- **下一步要具体** —「先修 `src/api/user.ts` 的空值判断，再跑 `npm test`」比「继续开发」好 100 倍
- **`CONTINUE.md` 跟着项目走** — 放在项目根目录，提交到 Git，换机器也能用
- **任务收尾就删掉** — 别让它变成过期的僵尸文档

## 示例

一个真实的 `CONTINUE.md` 长这样：

```markdown
# CONTINUE.md — 会话交接文档

> 最后更新：2025-07-28 14:30

## 当前任务

给 Express API 加 JWT 鉴权中间件，保护 `/api/admin/*` 路由。

## 已完成

- [x] 安装 `jsonwebtoken` 和 `express-jwt`
- [x] 写了 `src/middleware/auth.ts`，基本的 token 验证逻辑
- [x] 在 `src/routes/admin.ts` 里加了中间件引用
- [ ] token 刷新逻辑还没写

## 当前状态

登录接口 `/api/auth/login` 能正常签发 token，但过期后没有刷新机制。
前端同事在等这个，需要优先解决。

## 下一步计划

1. 在 `src/middleware/auth.ts` 里加 refresh token 逻辑
2. 加一个 `/api/auth/refresh` 接口
3. 写单元测试覆盖过期和刷新场景
4. 更新 API 文档

## 踩坑记录

### 坑1：express-jwt 版本不兼容

- **现象**：`express-jwt@8` 的 middleware 签名变了，旧写法报 `jwt is not a function`
- **原因**：v8 改成了 named export `{ expressjwt }` 而不是 default export
- **解决**：改成 `import { expressjwt } from 'express-jwt'`，已解决

### 坑2：CORS preflight 丢 Authorization header

- **现象**：OPTIONS 请求返回 401
- **原因**：浏览器 preflight 不带 Authorization header，中间件对所有请求都校验了
- **解决**：中间件里加了 `unless({ path: ['/api/auth/login'] })`，还没测

## 关键上下文

- 数据库用的 PostgreSQL，连接配置在 `.env` 的 `DATABASE_URL`
- 测试跑 `npm test`，用的是 vitest
- 代码风格：2 空格缩进，单引号，不加分号
```

空白模板见 [CONTINUE.template.md](CONTINUE.template.md)。

## License

MIT
