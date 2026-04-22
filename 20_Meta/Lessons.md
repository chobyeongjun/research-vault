---
title: Lessons (RL-loop memory)
updated: 2026-04-22
tags: [meta, rl-loop, claude-rules]
summary: 세션마다 누적되는 wins/misses. Claude는 세션 시작 시 Active Rules 섹션만 읽는다.
---

# Lessons — RL-loop Memory

> **읽는 순서 (Claude, 세션 시작 시):**
> 1. 아래 **Active Rules** 섹션만 먼저 읽는다 (토큰 절약).
> 2. 작업 도중 "이거 전에 이슈 있었는데?" 싶으면 Wins/Misses 검색.
> 3. 세션 종료 시 새 win/miss를 append. 반복 3회 이상이면 Active Rule로 승격.
>
> **형식:** `YYYY-MM-DD | 컨텍스트 | 교훈` — 한 줄로.

---

## Active Rules (검증된 규칙 — 짧게 유지)

<!-- 3회 이상 반복된 Miss는 여기로 승격. 1줄씩. -->

- **AR-1** wikilink는 항상 **basename만** — `[[h-walker]]` OK, `[[../../../10_Wiki/h-walker]]` 금지. Obsidian이 폴더 상관없이 basename으로 해석.
- **AR-2** 새 개념 노트는 **소문자-kebab**. 한글 제목 절차 문서는 기존 이름 유지.
- **AR-3** repo 스타일이 있으면 **기존 형식 존중**. 멋대로 YAML 추가/제거 금지. 기존 샘플 1개 먼저 읽어볼 것.
- **AR-4** 링크 수정 시 **3-pass 검증**: (1) 변경 → (2) grep으로 확인 → (3) 전체 vault broken-link 재스캔.
- **AR-5** 깨진 링크를 "없는 노트로 stub 만들기"로 해결하기 전에, **이미 다른 이름으로 존재하는지** 먼저 확인 (예: `exosuit-protection` → 실제는 `robot-hardware-protection`).

---

## Wins (재사용할 패턴)

<!-- YYYY-MM-DD | 컨텍스트 | 무엇이 좋았나 | 언제 재사용 -->

- `2026-04-22` | wiki 리팩토링 | Explore 에이전트로 **broken-link/orphan/naming/frontmatter/hub-coverage를 한 번에 진단** → 27개 깨진 링크·17개 고아를 즉시 발견 | 복잡도 높은 repo 구조 진단 시 항상 이 7-question 프레임 재사용.
- `2026-04-22` | 폴더 재구성 | Obsidian wikilink는 basename 기준이라 **폴더 이동해도 링크 안 깨짐** → `git mv`로 안전하게 프로젝트별 분리 가능 | vault 재구성 시 두려워하지 말 것.
- `2026-04-22` | 3-pass 검증 | (1) 변경 → (2) 대상별 grep → (3) 전체 vault 스캔 후 set-diff (`comm -23`) | 링크/이름 정합성 검증 시 재사용. 특히 basename-casing을 lowercase 통일 후 비교하면 false-positive 최소.
- `2026-04-22` | stub 생성 전략 | 진짜로 없는 허브 개념([[exosuit]], [[graphify]], [[0xhenry-dev]], [[stm32h743]])만 최소한의 frontmatter+plan으로 stub 생성 → graph view 연결성 복구하면서도 fake content 안 채움 | 새 concept 노드가 필요할 때 stub+expand-later 패턴 재사용.
- `2026-04-22` | dogfood RL-loop | 이번 리팩토링 자체를 Lessons.md의 첫 entries로 기록 → 다음 세션에서 Claude가 "지난번 이렇게 했네, 같은 방법"을 참고 가능 | 모든 구조적 작업은 Lessons에 최소 1 win + 0~1 miss 남기기.

---

## Misses (교정 규칙)

<!-- YYYY-MM-DD | 컨텍스트 | 무엇이 틀렸나 | 다음엔 어떻게 -->

- `2026-04-22` | 이전 세션 wiki 수정 | repo의 `docs/lessons/README.md` 양식을 무시하고 **YAML frontmatter를 멋대로 추가**해서 스타일 깨짐 | AR-3 (기존 샘플 먼저 읽기).
- `2026-04-22` | 이전 세션 wiki 수정 | wikilink를 **임의로 제거**하여 graph view/backlink가 끊김 | AR-1 (wikilink는 LLM wiki의 1급 시민, 절대 제거 금지).
- (history) | 여러 노트에서 | `[[exosuit-protection]]`을 참조하지만 실제 파일명은 `robot-hardware-protection.md` → **깨진 링크 4개** 발생 | AR-5 (stub 만들기 전 alias 여부 확인).
- (history) | `assistive-vector-treadmill/research_context.md` | 10_Wiki 개념 노트로 **wikilink 0개** → LLM이 프로젝트 맥락을 wiki와 연결 못 함 | 모든 프로젝트 루트 문서는 관련 wiki 노트 최소 3개 wikilink 필수.
- (history) | `Index.md` | 37개 노트 중 18개만 나열 (커버리지 48%) → LLM이 Index만 보면 절반을 "없다"고 오인 | Index는 항상 전수 나열. 누락 감지 스크립트 필요.
- `2026-04-22` | self-title `# [[Title]]` 패턴 | 파일명과 다른 제목을 wikilink로 감싸면 **phantom graph 노드** 생성 (e.g. `# [[LLM Wiki]]` in `llm-wiki.md` → "LLM Wiki"라는 빈 노드). 16개 파일에서 발견 | H1에는 wikilink 래퍼 금지. 평문 제목만.
- `2026-04-22` | H1 self-link 일괄 수정 | sed로 `# \[\[X\]\]` → `# X` 정규치환 시, 실제로는 **마스터 노트 참조**였던 케이스를 한 번 오인해서 링크 잃음 (realtime-vision-control/docs/perception-evolution.md) → 수동 수정 필요했음 | 일괄치환 후 반드시 각 파일 맥락 재확인. 특히 H1이 다른 노트 이름을 지칭하는 경우.
- `2026-04-22` | 브랜치 전략 이해 | `sync.sh`가 main만 처리하는 걸 **"문제"로 프레이밍**했지만, 이는 올바른 설계. main = stable (Obsidian이 보는 것), feature branch = Claude 실험장. 검증 후 main으로 통합하는 게 정답 | **AR-6 후보**: feature 브랜치 작업 완료 시 사용자 검증 거쳐 main으로 merge. `sync.sh` 같은 싱크 스크립트가 main만 따라가는 건 브랜치 위생상 올바름. main 변경은 **의도적 merge 이벤트**여야 함.
- `2026-04-23` | graphify 정체 판단 (중간 오판) | `--help` 출력만 보고 "Karpathy LLM Wiki 패턴 = graphify"로 **단정**. 그 다음엔 "AST 코드 전용"으로 **또 단정**. 둘 다 틀렸음 — 실제로는 **Claude Code 슬래시 커맨드 skill**이 메인 엔진이고 CLI는 보조. `skill.md`를 마지막에야 읽음 | **AR-7 후보**: 외부 툴 정체 파악 시 **소스 전수 확인 전까지 단정 금지**. 특히 `skill.md`·`__main__.py`·CLI entry script 3개는 필수 선독.
- `2026-04-23` | graphify bootstrap 경로 | `graphify hook install` 후 empty commit으로 bootstrap 시도 → 훅이 `CHANGED` 빈 값이면 `exit 0`이라 무반응. post-checkout 훅도 `graphify-out/` 기존재 조건. `_rebuild_code` 직접 호출도 "No code files found"로 실패 | 진짜 full-build는 **Claude Code 세션 내 `/graphify .` 슬래시 커맨드**. CLI hook은 증분 갱신 전용 (코드만). docs/md는 LLM 서브에이전트 병렬 추출 경유.
- `2026-04-23` | Lessons vs graphify-out/memory 역할 분리 | 제가 만든 `Lessons.md` RL-loop은 **사람이 읽는 distilled 규칙 레이어**. graphify의 `graphify-out/memory/`는 **기계가 읽는 Q&A 히스토리**. 서로 대체 아니라 **보완** | Win 확정: 두 레이어 공존. Lessons는 Active Rules(수기 승격), memory는 쿼리 시 자동 save-result.
- `2026-04-23` | `/graphify .` 최초 build 시 rate limit (429) | Vault 46 md 파일을 subagent 4개 병렬 dispatch → **분당 입력 30K 토큰 한도 초과** (Sonnet 4.6). chunks 1/3/4/5 실패, 2만 성공. 재시도도 window 미리셋으로 또 429 | **AR-8 후보**: `/graphify` 최초 build 시 **병렬 subagent 2개 이하**로 강제. chunk 크기도 20-25 → 10-12로 반감. skill.md 기본값(병렬 dispatch)은 코드 repo 기준이라 markdown vault엔 과함. 향후 graphify 실행 전 해당 지침을 inner 세션에 전달 필요.

---

## 승격 규칙

- Miss 항목이 **서로 다른 3개 이상의 세션**에서 반복 → Active Rule로 승격 (AR-N 부여).
- Active Rule이 6개월 이상 반복되지 않으면 archive 섹션으로 이동 (아직 없음).

---

## Archive (비활성 규칙)

(아직 없음)
