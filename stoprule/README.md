# 🛑 Stoprule

**优化要有停止条件。先定义基线、目标指标和测量方法，只有收益超过成本阈值才实施，否则停止优化，并记录取舍。**

适用于 Codex、Claude Code、Cursor、OpenCode、Pi、DSH、WorkBuddy、Zcode、Trae、Qoder。

## 解决什么问题

做性能优化时别说「继续优化」——那是一条没有终点的指令。AI 会一直改下去，每一轮都能拿出「新的改进」：收益越来越小、改动越来越大、风险越来越高。

最后你拿到一个改了 20 处、性能提升 2%、还带了两个新 bug 的 PR。

根因是三个东西同时缺：**基线**（不知道从哪开始）、**目标**（不知道到哪算够）、**阈值**（不知道什么收益值得做）。

真正专业的优化，不是无限追求更快，而是**知道什么时候该停**。

## 安装

选你用的平台，一行搞定。所有平台共用同一份 `SKILL.md`，内容完全一致。

| 平台 | 装到哪 | 生效范围 |
|------|--------|----------|
| **Codex** | `AGENTS.md`（追加） | 当前项目 |
| **Claude Code** | `CLAUDE.md`（追加）+ `.claude/commands/stoprule.md` | 当前项目 + `/stoprule` 命令 |
| **Cursor** | `.cursor/rules/stoprule.mdc` | 当前项目（`@stoprule` 可手动引用） |
| **OpenCode** | `~/.config/opencode/AGENTS.md`（追加） | 全局 |
| **Pi** | `~/.pi/agent/AGENTS.md`（追加） | 全局 |
| **DSH** | `~/.dsh/skills/stoprule/SKILL.md` | 全局（项目级用 `.dsh/skills/`） |
| **WorkBuddy** | `~/.workbuddy/skills/stoprule/SKILL.md` | 全局（项目级用 `.workbuddy/skills/`） |
| **Zcode** | `~/.zcode/skills/stoprule/SKILL.md` | 全局 |
| **Trae** | `.trae/rules/stoprule.md` | 当前项目（需在设置里开启规则读取） |
| **Qoder** | `~/.qoder/skills/stoprule/SKILL.md` | 全局（项目级用 `.qoder/skills/`） |

### 方式一：让 AI 自己装（最省事）

不用记路径，**把这段话直接粘给你在用的任意 AI 编程工具的对话框**：

```text
帮我装一个 skill。内容在这里：
https://raw.githubusercontent.com/konlue/skills/main/stoprule/SKILL.md

按下面的位置安装，只追加、不要覆盖目标文件里已有的内容：
- Codex / Cursor / OpenCode / Pi / DSH / Zcode / Qoder → 项目根目录的 AGENTS.md
- Claude Code → CLAUDE.md，再复制一份到 .claude/commands/stoprule.md
- Trae → .trae/rules/stoprule.md
- WorkBuddy → .workbuddy/skills/stoprule/SKILL.md

装完告诉我你改了哪些文件。
```

如果你用的工具能猜对位置，其实一句话就够：

```text
帮我装这个 skill：https://raw.githubusercontent.com/konlue/skills/main/stoprule/SKILL.md
```

> `raw.githubusercontent.com` 访问不稳时，把链接换成 jsDelivr：
> `https://cdn.jsdelivr.net/gh/konlue/skills@main/stoprule/SKILL.md`

### 方式二：一键脚本

```bash
./install.sh                 # 项目级：追加到 AGENTS.md + 生成 Trae 规则
./install.sh --project       # 同上
./install.sh --cc            # Claude Code：CLAUDE.md + .claude/commands/stoprule.md
./install.sh --cursor        # Cursor：.cursor/rules/stoprule.mdc
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
curl -fsSL https://raw.githubusercontent.com/konlue/skills/main/stoprule/install.sh | bash -s -- --all
```

脚本用 `<!-- stoprule:start/end -->` 标记包裹追加内容，重复运行不会产生重复副本，`--uninstall` 能干净移除。

### 方式三：手动复制

```bash
# 通用（Codex / DSH / Zcode / Qoder 走 AGENTS.md 的平台）
cat stoprule/SKILL.md >> AGENTS.md

# Claude Code
cat stoprule/SKILL.md >> CLAUDE.md
mkdir -p .claude/commands && cp stoprule/SKILL.md .claude/commands/stoprule.md

# Cursor（必须用 .mdc 扩展名，.md 会被忽略）
mkdir -p .cursor/rules && cp stoprule/SKILL.md .cursor/rules/stoprule.mdc

# OpenCode / Pi
cat stoprule/SKILL.md >> ~/.config/opencode/AGENTS.md
cat stoprule/SKILL.md >> ~/.pi/agent/AGENTS.md

# 走 skills 目录的平台
mkdir -p ~/.workbuddy/skills/stoprule && cp stoprule/SKILL.md ~/.workbuddy/skills/stoprule/
mkdir -p ~/.dsh/skills/stoprule       && cp stoprule/SKILL.md ~/.dsh/skills/stoprule/
mkdir -p ~/.zcode/skills/stoprule     && cp stoprule/SKILL.md ~/.zcode/skills/stoprule/
mkdir -p ~/.qoder/skills/stoprule     && cp stoprule/SKILL.md ~/.qoder/skills/stoprule/

# Trae
mkdir -p .trae/rules && cp stoprule/SKILL.md .trae/rules/stoprule.md
```

Trae 用户注意：项目规则默认读取 `AGENTS.md` / `CLAUDE.md` 的开关需要在 `设置 → 规则 → 导入设置` 里打开；用 `.trae/rules/` 目录则无需开关。

## 使用

### 手动触发

- **Claude Code / Qoder**：输入 `/stoprule`
- **Trae**：聊天框输入 `#Rule stoprule`
- **Cursor**：聊天框输入 `@stoprule`
- **其他平台**：直接说「先定基线和停止条件」

提需求时把这句带上，效果最好：

```text
先定义当前基线、目标指标和测量方法；
只有收益超过成本阈值才实施，否则停止优化，并记录取舍。
```

### 自动生效

装到 `AGENTS.md` / `CLAUDE.md` / skills 目录后成为常驻规则。AI 接到「优化一下性能」「继续优化」这类指令时，会先建基线再动手，而不是立刻开始改。

## 停止条件长什么样

动手前先填这张表：

```markdown
### 优化任务：订单列表接口

**基线**（优化前实测，不是估算）

| 指标 | 当前值 | 测量方法 | 测量环境 |
|------|--------|----------|----------|
| P95 响应时间 | 820ms | wrk -t4 -c100 -d30s，取 3 次中位数 | 8C16G 容器，10 万行数据 |

**目标**
- P95 ≤ 300ms（来源：产品要求的页面秒开预算）

**成本阈值**（满足其一才实施）
- 预期收益 ≥ 剩余差距的 20%
- 收益 / 改动成本 ≥ 3

**停止条件**（触发任一即停，并记录）
- [ ] 达标：P95 ≤ 300ms
- [ ] 收益不足：最优候选方案预期收益 < 50ms
- [ ] 成本超限：需改 5 个以上文件，或要引入新依赖
- [ ] 风险过大：会改变对外行为、需要数据迁移、无法快速回滚
- [ ] 边际递减：连续两轮提升 < 5%
- [ ] 时间预算用尽：投入超过 N 小时
```

## 输出长什么样

```markdown
**结论**：达标 / 未达标（原因）/ 停止（原因）

| 轮次 | 改动 | 优化前 | 优化后 | 收益 | 决定 |
|------|------|--------|--------|------|------|
| 1 | 给 user_id 加索引 | 820ms | 410ms | -410ms | 保留 |
| 2 | 热点数据加缓存 | 410ms | 380ms | -30ms | 保留 |
| 3 | 改并发模型 | 380ms | 375ms | -5ms | **回滚**（1.3%，复杂度上升） |

**停止原因**：第 3 轮收益 5ms（1.3%），低于 5% 阈值，触发「边际递减」。

**未采用的方案及原因**

- 引入 Redis 集群：预期再降 40ms，但新增依赖 + 运维成本，成本远超收益
- 用 Rust 重写：预期降 100ms，工期 2 周，超出时间预算
```

停止不等于没做事——**那份「试过什么、放弃了什么、为什么」的记录，和下一段优化代码一样有价值。**

## 别被这些「假收益」骗了

- 只测一次、只报最好的那次 → 应多次取中位数或 P95
- 冷启动和热态混在一起 → 分开测，说明测的是哪种
- 数据量不真实 → 本地 100 条跑出 1ms，线上 100 万条是另一回事
- 只看平均不看长尾 → P50 好看、P99 崩了，用户体感照样差
- 优化了次要指标 → QPS 上去了，内存涨 3 倍
- 在开发环境测 → 本机 M3 和生产 2C4G 完全是两回事
- 把「代码变短了」当成「变快了」→ 拿数据说话

## 什么时候不适用

- **修正确性 bug**：那不是优化，没有「够好就行」
- **修安全漏洞**：必须修完，不设阈值
- **一次性脚本、临时代码**：不值得为它建基线

## 和其他 skill 的关系

| Skill | 管什么 |
|-------|--------|
| [pushback](../pushback/) | 接到指令时：前提是错的就别照做 |
| [minipatch](../minipatch/) | 动手改之前：先报计划，只改该改的 |
| **stoprule** | 优化类任务：先建基线，够好就停 |
| [coldreview](../coldreview/) | 改完之后：换角色审一遍 |
| [handover](../handover/) | 会话要断时：写交接文档 |

可以都装，互不冲突。

## 卸载提示

`./install.sh --uninstall` 会删除各平台下 `skills/stoprule/` 整个目录。如果你在里面放了自己的文件，先手动取出来。

## License

MIT
