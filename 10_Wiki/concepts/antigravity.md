---
title: Antigravity IDE
created: 2026-04-13
updated: 2026-04-13
sources: []
tags: [ide, ai, google, agent]
summary: Google의 Agent-First IDE. 자율 에이전트가 계획-작성-테스트-디버그 전 과정을 수행한다.
confidence_score: 0.8
---

# Antigravity IDE

## Brief Summary
Google이 개발한 Agent-First IDE로, AI 에이전트가 코드의 계획, 작성, 테스트, 디버그를 자율적으로 수행한다.

## Core Content

### 핵심 개념
- **Agent-First:** 사용자가 아닌 에이전트가 주도적으로 개발 워크플로우 수행
- **Agent Skills:** 전문 지식 패키지 형태로 에이전트 능력을 확장
  - 위치: `.agents/skills/` 디렉토리
  - 도메인별 전문 지식을 모듈화

### 지원 모델
- Gemini 3.1 Pro
- Claude Opus 4.6
- GPT-OSS-120B

### 로컬 모델 지원
- 로컬 모델 직접 지원은 안 됨
- **우회 방법:** ADK(Agent Development Kit) + Ollama 조합으로 로컬 모델 사용 가능

### 설정
- `antigravity.config.json`으로 프로젝트별 설정 관리
- 모델 라우팅, 스킬 경로, 에이전트 동작 설정

## Knowledge Connections
- **Related Topics:** [[gemma-4]], [[llm-wiki]], [[0xhenry-dev]]
- **Projects/Contexts:** [[0xhenry-dev]] 개발 환경 구성
- **Contradictions/Notes:** 로컬 모델 미지원은 프라이버시/오프라인 작업 시 제약

---
*Last updated: 2026-04-13*
