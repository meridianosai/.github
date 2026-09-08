# Issue 约定（全组织）

本文件是 `meridianosai` 组织所有仓库共用的 issue 约定。各仓库 `docs/agents/issue-tracker.md`
只写本仓特有的部分并指向这里。2026-09-08 起生效，取代 Linear（team `MER`）。

## 事实源

- **issue 属于仓库**，全公司汇总在组织级 Project **「MeridianOS」**
  （<https://github.com/orgs/meridianosai/projects/1>，node id `PVT_kwDOEQbw884Bizza`）。
  Project 是跨仓视图，也是**状态与优先级的唯一落点**。
- 业务同事在飞书多维表格「漏洞 & 反馈 跟踪记录」提报，同步桥双向同步到 GitHub；他们不看 GitHub。
- 决策全文：`meridianos-fleet/docs/decisions/0047-github-issues-org-project.md`，
  桥侧 `meridianos-github-feishu-bridge/docs/decisions/0011-github-issues-tracker-side.md`。

## 字段

| 维度 | 落点 | 取值 |
|---|---|---|
| 状态 | Project 字段 `Status` | 新增 / 修复中 / 待验收 / 验收通过，待上线 / 已上线 / 设计如此 / 暂不修复 / 重复issue |
| 优先级 | Project 字段 `Priority` | P0 / P1 / P2 |
| 类型 | 组织级 **issue type** | Bug / Feature / Improvement / Suggestion；Task 给不出飞书的工程拆解票 |
| 平台 | 仓库本身，fleet 内再加标签 | `Fleet产品侧` / `Fleet运营中台` 只在 fleet 仓 |
| triage | 标签 | `needs-triage` / `needs-info` / `ready-for-agent` / `ready-for-human` / `wontfix` |

Status 与 issue 开关的关系由同步桥维护：已上线 → closed（completed）；设计如此、暂不修复 →
closed（not_planned）；重复issue → closed（duplicate）；其余 open。**不要用 PR 的 `Closes #n`
自动关票**：合并不等于上线，自动关闭会把飞书状态误推成「已上线」。PR 正文引用 `#n` 即可，
状态在 Project 里推进。

## 编号与引用

- 同仓引用写 `#123`；跨仓写 `meridianosai/<repo>#123`。各仓编号独立，裸 `#123` 跨仓会指错。
- commit subject：`<type>(#123): <description>`，type ∈ feat / fix / refactor / docs / test /
  chore / perf / ci；跨仓的票写 `<type>(meridianosai/<repo>#123): …`。**每笔提交都带票号**，
  没有票先建票。
- 历史 Linear 编号 `MER-n` 在 fleet 与 researcher 仓配了 autolink，指向 Linear 只读页；
  MER → GitHub 的对照表在 `meridianos-fleet/docs/agents/linear-github-map.csv`（迁移后生成）。

## 正文怎么写

用组织默认的 Issue Form「问题 / 需求」，四段：现在什么情况 / 有什么不对 / 做成什么样 /
这次不做什么。GitHub 渲染 markdown 可靠，可以用标题、列表、代码块。

- 标题写结果，不写现象。
- 讲看得见的现象，不讲里面怎么运作；一句话说一件事；少堆名词，多用动词。
- 文件路径、行号、方案、要拍板的问题写在**第一条评论**里，不进正文。
- 需要拆任务的开 **sub-issue**（父子关系），子票是工程拆解，**不同步到飞书**。
- 阻塞关系用 GitHub 的 blocked by，不在正文里写一行「Blocked by」。

## Agent 怎么读写

用 `gh` CLI，不要用第三方 MCP 顶替：

| 要做的事 | 命令 |
|---|---|
| 列 / 读 / 建 / 改 issue | `gh issue list` / `gh issue view <n> --comments` / `gh issue create` / `gh issue edit` |
| 评论 | `gh issue comment <n> --body-file …` |
| 进 Project、改 Status / Priority | `gh project item-add 1 --owner meridianosai --url <issue-url>`，然后 `gh project item-edit --project-id PVT_kwDOEQbw884Bizza --id <item> --field-id <field> --single-select-option-id <opt>` |
| 查字段与选项 id | `gh project field-list 1 --owner meridianosai --format json` |
| 设 issue type | GraphQL `updateIssueIssueType`（`gh api graphql`） |
| 父子 / 阻塞 | GraphQL `addSubIssue` / `addBlockedBy` |

不要凭记忆猜选项 id、标签名，先 `field-list` / `label list` 拿真实取值。

## 标签维护

triage 标签与 `deleted-in-feishu` 在每个接入仓都要有，用本仓 `scripts/sync-labels.sh <repo>…`
从清单创建或校正；平台标签只在 fleet。不要删各仓的 GitHub 默认标签，agent 也不使用它们。
