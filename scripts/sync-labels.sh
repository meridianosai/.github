#!/usr/bin/env bash
# 把组织通用标签创建/校正到指定仓库（幂等，--force 覆盖颜色与描述）。
# 用法: scripts/sync-labels.sh meridianos-researcher meridianos-bff …
# 平台标签（Fleet产品侧 / Fleet运营中台）只属于 fleet，不在本清单。
set -euo pipefail
ORG=meridianosai
[[ $# -gt 0 ]] || { echo "usage: $0 <repo>..." >&2; exit 2; }
LABELS=(
  "needs-triage|e4e669|需要维护者评估"
  "needs-info|d876e3|等报告人补充信息"
  "ready-for-agent|0e8a16|已完全规格化，可交给 AFK agent"
  "ready-for-human|1d76db|需要人来实现"
  "wontfix|ffffff|不做"
  "deleted-in-feishu|cfd3d7|飞书表里已删行，由同步桥关票"
)
for repo in "$@"; do
  for spec in "${LABELS[@]}"; do
    IFS='|' read -r name color desc <<<"$spec"
    if gh label create "$name" --repo "$ORG/$repo" --color "$color" --description "$desc" --force >/dev/null 2>&1; then
      printf 'ok   %-32s %s\n' "$repo" "$name"
    else
      printf 'FAIL %-32s %s\n' "$repo" "$name" >&2
    fi
  done
done
