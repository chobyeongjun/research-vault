---
title: Gemma 4
created: 2026-04-13
updated: 2026-04-13
sources: [raw/youtube/2026-04-12-gemma4-second-brain.md]
tags: [AI, local-llm, google, open-source]
summary: 구글의 오픈소스 LLM. 로컬 실행 가능, agentic 기능 내장, Apache 2.0
---

# [[Gemma 4]]

## Brief Summary
Google이 2026년 4월 2일 출시한 오픈소스 LLM 패밀리. Apache 2.0 라이선스. 로컬 실행 가능하며 agentic 기능(function calling, 도구 사용) 내장.

## Core Content
- 모델 4종: E2B(~2.3B effective), E4B(~4.5B effective), 26B A4B(MoE), 31B Dense
- E2B/E4B: 엣지용, 오디오 입력 지원, 128K 컨텍스트
- 26B A4B: 총 25.2B 파라미터, 추론 시 ~4B만 활성화
- 31B Dense: 30.7B, 최고 성능 플래그십, 256K 컨텍스트
- Ollama로 로컬 실행: `ollama pull gemma4:e4b`
- 우리 환경: antigravity.config.json에 E4B 로컬 설정 완료

## Knowledge Connections
- **Related Topics:** [[llm-wiki]], [[antigravity]]
- **Projects/Contexts:** [[exosuit]] - 로컬 AI 에이전트로 활용 가능
- **Contradictions/Notes:** 없음

---
*Last updated: 2026-04-13*
