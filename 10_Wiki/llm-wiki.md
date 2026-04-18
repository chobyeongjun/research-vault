---
title: LLM Wiki
created: 2026-04-13
updated: 2026-04-13
sources: [raw/youtube/2026-04-12-karpathy-llm-wiki.md]
tags: [AI, knowledge-management, karpathy]
summary: RAG 대신 LLM이 직접 마크다운 위키를 구축/유지하는 지식 관리 패턴
---

# [[LLM Wiki]]

## Brief Summary
Andrej Karpathy가 2026년 4월 제안한 지식 관리 패턴. RAG 대신 LLM이 구조화된 마크다운 위키를 점진적으로 구축하고 유지한다.

## Core Content
- 3계층 구조: raw/(원본, 불변) -> wiki/(AI 관리) -> schema(규칙)
- 3가지 작업: ingest(수집), query(질의), lint(점검)
- 마크다운 기반이라 인간도 직접 읽을 수 있고, Git 버전관리 가능
- RAG 대비 쿼리당 71.5배 토큰 절감
- X 포스트 1600만+ 뷰 달성

## Knowledge Connections
- **Related Topics:** [[gemma-4]], [[obsidian]], [[graphify]]
- **Projects/Contexts:** [[exosuit]], [[0xhenry-dev]]
- **Contradictions/Notes:** Graphify는 노트가 수백 개 이상 쌓였을 때 도입 고려

---
*Last updated: 2026-04-13*
