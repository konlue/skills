# 🔄 Handover Skill

**长会话结束前写交接文档，新会话读完直接干活。**

适用于 [Claude Code](https://docs.anthropic.com/en/docs/claude-code) 和 [OpenAI Codex](https://github.com/openai/codex)。

## 解决什么问题

AI 编程会话有上下文上限。会话断了之后，新对话什么都不记得——你得重新解释项目背景、已经做了什么、踩过哪些坑。

这个 Skill 让 AI 在会话结束前自动写一份交接文档 `HANDOVER.md`，下次开新会话只要说"先读 HANDOVER.md"，它就能无缝接上。

## 安装

### Claude Code

把 `SKILL.md` 放到项目根目录的 `.claude/` 下：

```bash
mkdir -p .claude
cp SKILL.md .claude/session-handoff.md
```

或者直接把 `SKILL.md` 的内容追加到你已有的 `.claude/CLAUDE.md` 里。

### Codex

把 `SKILL.md` 放到项目根目录的 `codex-instructions/` 下：

```bash
mkdir -p codex-instructions
cp SKILL.md codex-instructions/session-handoff.md
```

或者把内容追加到你的 `codex-instructions/AGENTS.md`。

## 使用

### 1. 会话结束前

输入：

```
请写一份交接文档存到 HANDOVER.md
```

AI 会根据当前对话内容，生成一份包含以下内容的交接文档：

| 模块 | 内容 |
|------|------|
| **当前任务** | 我们在做什么，目标是什么 |
| **已完成** | 做了哪些东西，哪些只做了一半 |
| **当前状态** | 卡在哪，有什么未解决的问题 |
| **下一步计划** | 接下来该做什么，优先级 |
| **踩坑记录** | 试过但不行的方案，避免重复踩坑 |
| **关键上下文** | 新会话需要知道的背景信息 |

### 2. 开新会话时

第一句话：

```
先读 HANDOVER.md
```

AI 读完交接文档后，会直接继续工作，不需要你重新解释任何东西。

## 什么时候写

不用等会话"正式结束"。任何你觉得有进展的时刻都可以写一次，覆盖更新就行：

- 实现了一个重要功能后
- 踩了一个大坑、搞清楚原因后
- 准备切换到另一个任务前
- 上下文快满了、准备开新会话前

## Tips

- **踩坑记录最有价值** — 写详细点，包括报错信息、尝试过的方案、为什么不行
- **下一步要具体** — "先修 `src/api.ts` 里的鉴权逻辑，然后跑测试" 比 "继续开发" 好 100 倍
- **`CONTINUE.md` 跟着项目走** — 放在项目根目录，提交到 Git，这样换机器也能用

## 示例

一个真实的 `HANDOVER.md` 长这样：

```markdown
# HANDOVER.md — 会话交接文档

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

## License

MIT
