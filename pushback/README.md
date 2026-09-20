# 🙅 Pushback

**不做应声虫。执行前先检查前提对不对，发现问题当场指出，变成能纠错的技术搭档。**

适用于 Codex、Claude Code、Cursor、OpenCode、Pi、DSH、WorkBuddy、Zcode、Trae、Qoder。

## 解决什么问题

AI 天生倾向配合。你给一个前提，它默认接受，然后在这个前提上把事情做得又快又好——**前提是错的时候，执行得越漂亮，返工越大**。

更麻烦的是：你不知道自己给了错前提，你只看到它「照做了」，于是默认它认可了这个方案。

Pushback 要的就是这几件事：

```text
执行前检查是否存在错误前提、逻辑漏洞；
不要一味迎合，独立判断；
涉及数据尽量核验；
发现问题直接指出；
说明风险主动提醒；
容易忽略的变量与偏差。
```

一句话收益：**不会盲目跟着指令执行，变成可以纠错的技术搭档。**

## 安装

选你用的平台，一行搞定。所有平台共用同一份 `SKILL.md`，内容完全一致。

| 平台 | 装到哪 | 生效范围 |
|------|--------|----------|
| **Codex** | `AGENTS.md`（追加） | 当前项目 |
| **Claude Code** | `CLAUDE.md`（追加）+ `.claude/commands/pushback.md` | 当前项目 + `/pushback` 命令 |
| **Cursor** | `.cursor/rules/pushback.mdc` | 当前项目（`@pushback` 可手动引用） |
| **OpenCode** | `~/.config/opencode/AGENTS.md`（追加） | 全局 |
| **Pi** | `~/.pi/agent/AGENTS.md`（追加） | 全局 |
| **DSH** | `~/.dsh/skills/pushback/SKILL.md` | 全局（项目级用 `.dsh/skills/`） |
| **WorkBuddy** | `~/.workbuddy/skills/pushback/SKILL.md` | 全局（项目级用 `.workbuddy/skills/`） |
| **Zcode** | `~/.zcode/skills/pushback/SKILL.md` | 全局 |
| **Trae** | `.trae/rules/pushback.md` | 当前项目（需在设置里开启规则读取） |
| **Qoder** | `~/.qoder/skills/pushback/SKILL.md` | 全局（项目级用 `.qoder/skills/`） |

### 方式一：让 AI 自己装（最省事）

不用记路径，**把这段话直接粘给你在用的任意 AI 编程工具的对话框**：

```text
帮我装一个 skill。内容在这里：
https://raw.githubusercontent.com/konlue/skills/main/pushback/SKILL.md

按下面的位置安装，只追加、不要覆盖目标文件里已有的内容：
- Codex / Cursor / OpenCode / Pi / DSH / Zcode / Qoder → 项目根目录的 AGENTS.md
- Claude Code → CLAUDE.md，再复制一份到 .claude/commands/pushback.md
- Trae → .trae/rules/pushback.md
- WorkBuddy → .workbuddy/skills/pushback/SKILL.md

装完告诉我你改了哪些文件。
```

如果你用的工具能猜对位置，其实一句话就够：

```text
帮我装这个 skill：https://raw.githubusercontent.com/konlue/skills/main/pushback/SKILL.md
```

> `raw.githubusercontent.com` 访问不稳时，把链接换成 jsDelivr：
> `https://cdn.jsdelivr.net/gh/konlue/skills@main/pushback/SKILL.md`

### 方式二：一键脚本

```bash
./install.sh                 # 项目级：追加到 AGENTS.md + 生成 Trae 规则
./install.sh --project       # 同上
./install.sh --cc            # Claude Code：CLAUDE.md + .claude/commands/pushback.md
./install.sh --cursor        # Cursor：.cursor/rules/pushback.mdc
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
curl -fsSL https://raw.githubusercontent.com/konlue/skills/main/pushback/install.sh | bash -s -- --all
```

脚本用 `<!-- pushback:start/end -->` 标记包裹追加内容，重复运行不会产生重复副本，`--uninstall` 能干净移除。

### 方式三：手动复制

```bash
# 通用（Codex / DSH / Zcode / Qoder 走 AGENTS.md 的平台）
cat pushback/SKILL.md >> AGENTS.md

# Claude Code
cat pushback/SKILL.md >> CLAUDE.md
mkdir -p .claude/commands && cp pushback/SKILL.md .claude/commands/pushback.md

# Cursor（必须用 .mdc 扩展名，.md 会被忽略）
mkdir -p .cursor/rules && cp pushback/SKILL.md .cursor/rules/pushback.mdc

# OpenCode / Pi
cat pushback/SKILL.md >> ~/.config/opencode/AGENTS.md
cat pushback/SKILL.md >> ~/.pi/agent/AGENTS.md

# 走 skills 目录的平台
mkdir -p ~/.workbuddy/skills/pushback && cp pushback/SKILL.md ~/.workbuddy/skills/pushback/
mkdir -p ~/.dsh/skills/pushback       && cp pushback/SKILL.md ~/.dsh/skills/pushback/
mkdir -p ~/.zcode/skills/pushback     && cp pushback/SKILL.md ~/.zcode/skills/pushback/
mkdir -p ~/.qoder/skills/pushback     && cp pushback/SKILL.md ~/.qoder/skills/pushback/

# Trae
mkdir -p .trae/rules && cp pushback/SKILL.md .trae/rules/pushback.md
```

Trae 用户注意：项目规则默认读取 `AGENTS.md` / `CLAUDE.md` 的开关需要在 `设置 → 规则 → 导入设置` 里打开；用 `.trae/rules/` 目录则无需开关。

## 使用

### 自动生效

装到 `AGENTS.md` / `CLAUDE.md` / skills 目录后成为常驻规则，不需要手动触发。AI 会在每次执行前先审题：前提成立吗、推得出来吗、数据核实过吗。

### 手动触发

- **Claude Code / Qoder**：输入 `/pushback`
- **Trae**：聊天框输入 `#Rule pushback`
- **Cursor**：聊天框输入 `@pushback`
- **其他平台**：直接说「别迎合我，先检查前提」

想要更强调时，把这段贴进去：

```text
执行前检查是否存在错误前提、逻辑漏洞；
不要一味迎合，独立判断；
涉及数据尽量核验；
发现问题直接指出；
说明风险主动提醒；
容易忽略的变量与偏差。
```

## 会有什么不一样

| ❌ 应声虫 | ✅ 装了 pushback |
|---|---|
| 「好的，马上执行」 | 「可以，但有个前提我想先确认：……」 |
| 「你说得对」 | 「这点我不同意，原因是……建议改成……」 |
| 「已完成，一切正常」 | 「做完了，另外发现两个你可能没注意的点：……」 |
| （默默按错误前提做完） | 「这里的前提可能不成立：……如果确实要这么做，风险是……」 |

## 检查什么

| 检查项 | 具体看什么 |
|--------|-----------|
| 错误前提 | 接口真的返回数组吗、用户一定已登录吗、这个库的版本支持吗 |
| 逻辑漏洞 | 结论推得出来吗、边界自洽吗、什么情况下会失败 |
| 数据核验 | 来源和口径、数量级合理吗、样本够吗、有没有幸存者偏差 |
| 独立判断 | 不同意就明确说，并给替代方案；用户坚持就照做但记下风险 |
| 风险提示 | 删除、强推、发布、花钱、改线上配置——先说再动 |
| 被忽略的变量 | 环境差异、副作用、确认偏差、采样偏差、近因效应 |

## 分寸

这条规则最怕走极端：从「应声虫」变成「杠精」。所以规则里也写了什么时候不用较真——指令明确、风险低、用户已经解释过为什么、或者纠结的成本已经超过做错的成本。

**否定必须伴随出路**：只说「这样不行」是抬杠，说出「那可以怎么做」才是搭档。

## 和其他 skill 的关系

| Skill | 管什么 |
|-------|--------|
| **pushback** | 接到指令时：前提是错的就别照做 |
| [minipatch](../minipatch/) | 动手改之前：先报计划，只改该改的 |
| [coldreview](../coldreview/) | 改完之后：换角色审一遍 |
| [handover](../handover/) | 会话要断时：写交接文档 |

四个覆盖一次任务的完整链路，可以都装，互不冲突。

## 卸载提示

`./install.sh --uninstall` 会删除各平台下 `skills/pushback/` 整个目录。如果你在里面放了自己的文件，先手动取出来。

## License

MIT
