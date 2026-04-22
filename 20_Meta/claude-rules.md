---
title: Claude Rules (Research Vault)
updated: 2026-04-22
tags: [meta, rules, session-start]
summary: Claude가 세션 시작 시 읽는 최소 규칙. 토큰 절약 위해 짧게 유지.
---

# Claude Rules — Research Vault

## 세션 시작 (3단계, 이 순서)

1. **이 파일** (지금 읽는 것) — 규칙 파악
2. [[Lessons]] — **Active Rules 섹션만**. Wins/Misses는 필요할 때 검색.
3. [[Log]] — 오늘 작업 파악

> Index/wiki 노트는 키워드 감지 시에만 읽는다 (토큰 절약).

## 작업 중 필수

- **Wiki 참조**: 하드웨어/연구 키워드 등장 → 관련 [[10_Wiki]] 노트 최소 1개 먼저 읽고 답변.
- **새 교훈/스펙 발견** → 즉시 해당 wiki 노트에 기록 (또는 Lessons에 miss/win 추가).
- **작업 완료** → `Log.md`에 한 줄 + 필요 시 `Lessons.md`에 win/miss 한 줄.

## Wikilink 규약 (AR-1, AR-2)

- **basename만** 사용. `[[h-walker]]` ✅ · `[[../../../10_Wiki/h-walker]]` ❌
- **소문자-kebab** 기본. 기존 한글/대문자 파일명은 보존.
- **self-title 금지**: `# [[Title]]` 쓰지 말고 `# Title`만. (self-link는 phantom 노드 생성)

## Git 규칙

- 작업 완료 시 커밋 + 푸시 자동.
- AI 흔적 금지 (커밋 메시지/브랜치명/PR에 Claude·AI 언급 금지).

## 기술 스펙 검증

- 하드웨어 수치는 공식 소스 확인: AK60→T-Motor, ZED→Stereolabs, Teensy→PJRC.
- 확신 없으면 `⚠️ 확인 필요` 표기. **추측 수치 금지**.

## 명명 규약

- 로봇: **Exosuit** (외골격/exoskeleton 금지).

## 기기 역할

- **Mac** = 연구/코딩 전용. Mac에서 콘텐츠 작업 요청 시 → "Windows에서 진행" 안내 후 중단.

## Vault 경로

- Wiki: `10_Wiki/{exosuit,perception,h-walker-ai,grants,concepts}/`
- Raw: `00_Raw/`
- Projects: `assistive-vector-treadmill/`, `realtime-vision-control/`
- 실험: `{project}/experiments/` · 미팅: `{project}/meetings/` · 논문: `{project}/papers/`
- Meta: `20_Meta/` ([[Index]], [[Lessons]], [[Log]], 이 파일)
