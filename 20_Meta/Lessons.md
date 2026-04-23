---
title: Lessons (RL-loop memory)
updated: 2026-04-23
tags: [meta, rl-loop, claude-rules]
summary: 세션마다 누적되는 wins/misses. Claude는 세션 시작 시 Active Rules + Always Do만 읽는다.
---

# Lessons — RL-loop Memory

> **읽는 순서 (Claude, 세션 시작 시):**
> 1. **Active Rules** + **Always Do** 섹션 먼저 읽는다 (토큰 절약).
> 2. 작업 도중 "이거 전에 이슈 있었는데?" 싶으면 Wins/Misses 검색.
> 3. 세션 종료 시 새 win/miss를 append.
>
> **승격 조건:** 서로 다른 3회 이상 반복 **OR 사용자가 "무조건 기억해"라고 명시적으로 지시한 것**
>
> **가중치:** Misses → `[CRITICAL×10 | WARNING×5 | MINOR×1]` / Wins → `[HIGH×10 | MED×5 | LOW×1]`
>
> **형식:** `YYYY-MM-DD | 컨텍스트 | [weight] 교훈`

---

## Active Rules (Punish 승격 — 하지 말 것)

<!-- CRITICAL/WARNING Miss가 승격 조건 충족 시 여기로. 1줄씩. -->

- **AR-1** wikilink는 항상 **basename만** — `[[h-walker]]` OK, `[[../../../10_Wiki/h-walker]]` 금지. Obsidian이 폴더 상관없이 basename으로 해석.
- **AR-2** 새 개념 노트는 **소문자-kebab**. 한글 제목 절차 문서는 기존 이름 유지.
- **AR-3** repo 스타일이 있으면 **기존 형식 존중**. 멋대로 YAML 추가/제거 금지. 기존 샘플 1개 먼저 읽어볼 것.
- **AR-4** 링크 수정 시 **3-pass 검증**: (1) 변경 → (2) grep으로 확인 → (3) 전체 vault broken-link 재스캔.
- **AR-5** 깨진 링크를 "없는 노트로 stub 만들기"로 해결하기 전에, **이미 다른 이름으로 존재하는지** 먼저 확인 (예: `exosuit-protection` → 실제는 `robot-hardware-protection`).
- **AR-6** Claude Code 세션 시작 시 **"Auth conflict" 경고가 뜨면 즉시 멈추고** `unset ANTHROPIC_API_KEY` + shell config에서 제거 후 재시작. 구독 사용자는 API 키가 우선 사용되면 낮은 tier로 과금 + rate limit에 갇힘. 429 디버깅 전에 `env | grep ANTHROPIC` 부터 확인할 것.

---

## Always Do (Reward 승격 — 항상 할 것)

<!-- HIGH Wins가 승격 조건 충족 시 여기로. 1줄씩. -->

- **AD-1** 실험 트랙과 메인라인은 **Git 브랜치로 분리**. CLAUDE.md에 어느 브랜치가 stable인지 명시. outdated 베이스에서 재발명 차단.
- **AD-2** 안전 한계값(HARD LIMIT)은 **CLAUDE.md에 수치로 박아둘 것** (예: 20ms, 70N). 주석 없이 맥락만 있으면 다음 세션이 오인함.
- **AD-3** 긴 작업(graphify, 대규모 리팩토링) 완료 시 **milestone tag + summary 문서** 남기기. 다음 세션 zero-start 5분 파악 가능.

---

## Wins (재사용할 패턴)

<!-- YYYY-MM-DD | 컨텍스트 | [weight] 무엇이 좋았나 -->

- `2026-04-22` | wiki 리팩토링 | [HIGH] Explore 에이전트로 **broken-link/orphan/naming/frontmatter/hub-coverage를 한 번에 진단** → 27개 깨진 링크·17개 고아를 즉시 발견. 복잡도 높은 repo 구조 진단 시 항상 이 7-question 프레임 재사용.
- `2026-04-22` | 폴더 재구성 | [MED] Obsidian wikilink는 basename 기준이라 **폴더 이동해도 링크 안 깨짐** → `git mv`로 안전하게 프로젝트별 분리 가능.
- `2026-04-22` | 3-pass 검증 | [MED] (1) 변경 → (2) 대상별 grep → (3) 전체 vault 스캔 후 set-diff (`comm -23`). basename lowercase 통일 후 비교하면 false-positive 최소.
- `2026-04-22` | stub 생성 전략 | [LOW] 진짜로 없는 허브 개념만 최소 frontmatter+plan으로 stub 생성 → graph view 연결성 복구, fake content 안 채움.
- `2026-04-22` | dogfood RL-loop | [LOW] 구조적 작업은 Lessons에 최소 1 win + 0~1 miss 남기기.
- `2026-04-21` | perception | [HIGH] **Watchdog pause/resume during CUDA graph capture** — `stream.query()`가 다른 thread에서 capture invalidate. `capture_error_mode='thread_local'`은 무효. 명시적 pause/resume이 유일한 답. 매 run reproducible 80Hz 확보.
- `2026-04-21` | perception | [HIGH] **EMA(smoothing) vs Constraint(outlier reject) 도구 분리** — EMA는 low-pass라 50cm jump 못 잡음. outlier reject는 bone_length / joint_velocity hard constraint. 이미 `constraints.py` 구현돼있었음, default OFF였음.
- `2026-04-21` | process | [MED] **v0.1.0 tag + full-journey-summary.md** — 7 phase + 잘된 것/안된 것 + 영구 기각 목록. 다음 세션 5분 파악.

---

## Misses (교정 규칙)

<!-- YYYY-MM-DD | 컨텍스트 | [weight] 무엇이 틀렸나 → 다음엔 어떻게 -->

- `2026-04-23` | exosuit hardware | [CRITICAL] **Loadcell 데이터 읽기/저장 안 됨** — 원인 미파악. ADS1234 ADC 또는 INA128UA 앰프 연결 문제 가능성. 힘 제어 전체가 이 데이터에 의존하므로 미해결 시 어시스턴스 벡터 제어 불가. → 다음 세션 최우선 진단.
- `2026-04-22` | wiki 수정 | [WARNING] repo 양식 무시하고 **YAML frontmatter 멋대로 추가** → AR-3 (기존 샘플 먼저 읽기).
- `2026-04-22` | wiki 수정 | [WARNING] wikilink **임의 제거** → graph view/backlink 끊김. AR-1.
- (history) | 여러 노트 | [WARNING] `[[exosuit-protection]]` 참조하지만 실제 파일명은 `robot-hardware-protection.md` → **깨진 링크 4개**. AR-5.
- (history) | project root | [MINOR] 프로젝트 루트 문서에 **wikilink 0개** → LLM이 wiki와 연결 못 함. 프로젝트 루트는 wiki 노트 최소 3개 wikilink 필수.
- (history) | Index.md | [MINOR] 37개 노트 중 18개만 나열(커버리지 48%) → LLM이 절반을 "없다"고 오인. Index는 항상 전수 나열.
- `2026-04-22` | self-title | [WARNING] `# [[Title]]` 패턴 → **phantom graph 노드** 생성. 16개 파일에서 발견. H1에는 wikilink 래퍼 금지.
- `2026-04-22` | 일괄치환 | [WARNING] sed로 H1 self-link 일괄 수정 시 **마스터 노트 참조 케이스 오인**해서 링크 잃음. 일괄치환 후 맥락 재확인 필수.
- `2026-04-22` | 브랜치 전략 | [MINOR] `sync.sh`가 main만 처리하는 걸 "문제"로 오인. main = stable, feature = 실험장. 올바른 설계였음.
- `2026-04-23` | 외부 툴 파악 | [WARNING] `--help`만 보고 graphify 정체 단정 → 틀림. AR-7: 소스 전수 확인 전 단정 금지 (`skill.md` + `__main__.py` + CLI entry 3개 필수 선독).
- `2026-04-23` | graphify bootstrap | [MINOR] empty commit으로 bootstrap 시도 → hook이 `CHANGED` 빈 값이면 `exit 0`. full-build는 `/graphify .` 슬래시 커맨드만.
- `2026-04-23` | rate-limit 산수 | [WARNING] chunk size 안 줄이고 dispatch만 순차로 → 단일 subagent 입력이 이미 한도 초과. **TPM ÷ 파일당 토큰 = 최대 chunk size** 산수 필수.
- `2026-04-23` | 429 대응 | [WARNING] Sonnet 429 → Opus 전환 시도 → 동일 429. 30K TPM은 org 단위, 모델 무관. 해결책: (1) 새 세션, (2) 1h+ 대기, (3) Tier 상향. **같은 세션 재시도 루프 절대 금지**.
- `2026-04-23` | ANTHROPIC_API_KEY 충돌 | [CRITICAL] 구독 중인데 shell `ANTHROPIC_API_KEY`를 Claude Code가 우선 사용 → 낮은 tier API 30K TPM에 갇힘. 하루 날림 → **AR-6** (즉시 승격됨).
- `2026-04-21` | safety | [CRITICAL] **Python에서 Teensy 직접 송신** → C++ control loop의 watchdog·5중 force clamp 우회. AK60 70N 안전 chain 무력화. 환자 위험.
- `2026-04-21` | perception | [WARNING] **Silent fallback when CUDA graph capture fails** → eager 폴백으로 80Hz vs 40Hz 비결정성. 항상 명시적 retry + raise. silent X.
- `2026-04-21` | process | [WARNING] **Outdated baseline에서 출발** → 최신 branch 확인 안 하고 구버전 재발명. 22ms/44Hz (vs 검증된 14ms/73Hz).
- `2026-04-21` | perception | [WARNING] **Perception + matplotlib display 동일 스크립트 결합** → FPS 74→44 반토막. display는 별도 process 규칙 위반.
- `2026-04-21` | perception | [WARNING] **EMA를 outlier 차단으로 오인** → alpha 올려봐야 50cm jump 15cm로 dampening만. outlier reject는 bone_length hard constraint가 답.
- `2026-04-21` | process | [MINOR] **Vault에 git clone** → vault는 docs/notes 전용. iCloud sync와 .git 충돌 위험. pointer 노트 + handover만 vault에.

---

## 승격 규칙

**Punish 승격 (Misses → Active Rules):**
- CRITICAL/WARNING Miss가 서로 다른 **3회 이상 반복** → Active Rule (AR-N 부여)
- **또는 사용자가 "무조건 기억해"라고 명시적으로 지시한 것** → 즉시 승격

**Reward 승격 (Wins → Always Do):**
- HIGH Win이 서로 다른 **3회 이상 반복** → Always Do (AD-N 부여)
- **또는 사용자가 "항상 해"라고 명시적으로 지시한 것** → 즉시 승격

**Inbox → Lessons 흐름:**
- skiro-learnings.md는 **자동 수집 Inbox** (노이즈 포함). 주기적으로 여기로 distill.
- Active Rule이 6개월 이상 트리거되지 않으면 Archive로 이동.

---

## Archive (비활성 규칙)

(아직 없음)
