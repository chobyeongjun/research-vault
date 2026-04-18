---
title: Claude Rules (Research)
updated: 2026-04-18
tags: [claude, rules, meta]
---

# Claude Rules — Research Vault

## 세션 시작 시 자동 실행
1. `~/research-vault/20_Meta/Log.md` 읽기 → 오늘 한 작업 파악
2. 현재 작업 레포 CLAUDE.md 읽기
3. 연구/하드웨어 키워드 감지 시 → `~/research-vault/10_Wiki/` 관련 노트 먼저 읽기

## Git 규칙
- 작업 완료 시 커밋 + 푸시 자동 수행
- AI 흔적 완전 금지: 커밋 메시지, 브랜치명, PR에 Claude/AI 언급 금지

## 기술 스펙 검증
- 하드웨어 수치는 반드시 공식 소스 확인
  - AK60 → T-Motor 공식 spec sheet
  - ZED X Mini → Stereolabs 공식 문서
  - Teensy 4.1 → PJRC 공식 문서
- 확신 없으면 `⚠️ 확인 필요` 표기, 추측 수치 절대 금지

## 명명 규칙
- 로봇: **Exosuit** (외골격/exoskeleton 사용 금지)

## 기기 역할
- **Mac** → 연구/코딩 전용
- Mac에서 콘텐츠 작업 요청 시 → "Windows에서 진행하세요" 안내 후 중단

## Vault 참조 규칙
- 새 교훈/스펙 발견 시 → 즉시 해당 Wiki 노트에 기록
- 작업 완료 시 → `Log.md`에 한 줄 기록

## Vault 경로
- Wiki: `~/research-vault/10_Wiki/`
- 실험: `~/research-vault/{프로젝트}/experiments/`
- 미팅: `~/research-vault/{프로젝트}/meetings/`
- 논문: `~/research-vault/{프로젝트}/papers/`
