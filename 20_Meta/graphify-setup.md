---
title: Graphify Setup
updated: 2026-04-23
tags: [meta, setup, graphify, llm-wiki, rl-loop]
summary: graphify 슬래시 커맨드 스킬 설치 + `/graphify .` 최초 빌드 절차. Obsidian wikilink 구조와 별도 레이어로 공존.
---

# Graphify Setup

## 무엇인가

[[graphify]] = Claude Code 슬래시 커맨드 기반 지식 그래프 빌더. `/graphify .` 한 줄로 vault 전체 → `graph.json` + `GRAPH_REPORT.md` + `graph.html` + 커뮤니티 탐지 + god nodes 분석까지.

**우리 vault에서의 역할:**
- [[Index]] / `_hub.md` / [[Lessons]] = **사람이 읽는 distilled 레이어**
- graphify `graph.json` / `graphify-out/memory/` = **기계가 쿼리하는 세밀한 레이어**
- 둘은 서로 대체 아니라 보완 ([[Lessons#Misses]] 참조)

## 설치 (Mac에서 1회)

### Step 1. 슬래시 커맨드 skill 설치
```bash
graphify install --platform claude
ls ~/.claude/skills/graphify/
```
새 Claude Code 세션에서 `/graphify` 슬래시 커맨드 활성화.

### Step 2. CLAUDE.md 통합
```bash
cd ~/research-vault
graphify claude install
git diff CLAUDE.md .claude/settings.json 2>/dev/null | head -50
```
루트에 `CLAUDE.md` 생성/수정 + PreToolUse hook 추가 → Claude가 tool 호출 전 자동으로 graph 확인.

## 최초 빌드 (새 Claude Code 세션)

`~/research-vault` 열고:
```
/graphify .
```

자동 실행되는 9단계:
1. graphify 설치 확인
2. 파일 감지 (code/docs/papers/images 분류)
3. AST 추출 (코드) + **의미 추출 (docs는 LLM 서브에이전트 병렬 dispatch)**
4. networkx 그래프 build + community clustering
5. Community labeling (Claude 본인이 커뮤니티 이름 생성)
6. `graph.html` + (선택) Obsidian vault export
7. Neo4j / SVG / GraphML (선택)
8. Token reduction benchmark
9. Manifest 저장 + cost tracker 갱신

예상 비용 (vault 46 md, ~200k 단어 가정):
- 서브에이전트 2-3개 병렬 dispatch → ~45-90초
- 입력 토큰 ~50-100k, 출력 ~5-10k
- 이후 `--update`는 **변경 파일만** 재추출 (토큰 대폭 감소)

## 쿼리 & 피드백 루프

```bash
graphify query "AK60 모터와 cable-driven 메커니즘의 관계"
# → BFS 탐색, 2000 토큰 예산 안에서 subgraph 추출
# → Claude가 답변
# → graphify save-result 자동 호출 (skill이 지시) → graphify-out/memory/ 에 Q&A 저장
```

이후 `--update` 돌리면 이 Q&A가 그래프 노드로 들어가서 **다음 쿼리에 자동 참조**. 이게 실제 RL-loop.

## 기존 Obsidian vault와 공존

| 레이어 | 출처 | 어떻게 본다 |
|---|---|---|
| Obsidian graph view | `[[wikilink]]` 기반 | Obsidian 앱에서 그래프뷰 클릭 탐색 |
| Graphify graph view | `graphify-out/graph.html` | 브라우저에서 커뮤니티별 색상 그래프 |
| Graphify query | `graphify-out/graph.json` | `graphify query` CLI 또는 `/graphify query` |

**절대 쓰지 말 것**: `/graphify . --obsidian`. 우리 vault 위에 새 vault를 생성해서 구조 깨집니다. 기본값 (플래그 없음) 으로 쓰면 `graphify-out/` 폴더에만 결과물 들어감.

## `.gitignore` 정책

커밋 대상 (공유):
- `graphify-out/graph.json` — 쿼리 기반 (작지만 중요)
- `graphify-out/GRAPH_REPORT.md` — 사람이 읽는 요약
- `graphify-out/cost.json` — 토큰 비용 추적

로컬 전용 (`.gitignore`):
- `graphify-out/memory/` — 세션별 Q&A
- `graphify-out/graph.html` / `.svg` / `.graphml` — 재생성 가능, 용량 큼
- `graphify-out/.graphify_*.json` — 임시 파일
- `graphify-out/obsidian/` — graphify가 옵션으로 만드는 별도 vault (사용 안 함)

## 증분 갱신 (--update)

파일 추가/수정 후:
```bash
# Claude Code 세션에서:
/graphify . --update
```
변경 파일만 재추출. 코드 전용 변경이면 LLM 건너뜀 (무료).

git commit hook은 이미 `graphify hook install` 으로 설치됨 — 커밋 시 **코드 AST만** 자동 갱신. docs/md 변경은 `/graphify . --update` 로 수동.

## 트러블슈팅

- `graph file not found` → 아직 `/graphify .` 안 돌림
- `pip install graphifyy` 에러 (skill.md 내부 타이포) → 무시. graphify 이미 설치되어 있으므로 해당 fallback 경로 안 탐.
- 서브에이전트 결과 누락 → skill이 "general-purpose" 대신 "Explore" 쓴 경우. 새 세션에서 재시도.

## 관련 노트

- [[graphify]] — 개념 노트
- [[llm-wiki]] — Karpathy 원본 패턴
- [[p-reinforce]] — RL-loop 개념
- [[Lessons]] — graphify 도입 중 학습한 miss/win
- [[claude-rules]] — 세션 진입점
- [[obsidian-sync-setup]] — 자매 셋업 문서
