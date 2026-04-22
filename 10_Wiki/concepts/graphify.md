---
title: Graphify
created: 2026-04-22
updated: 2026-04-22
sources: []
tags: [tool, knowledge-management, obsidian, ai]
summary: Obsidian graph와 LLM을 연동하는 지식 그래프 도구. [[llm-wiki]] 패턴 확장 시 고려 대상.
---

# Graphify

## Brief Summary
Obsidian 노트 그래프를 LLM 질의 컨텍스트로 활용하는 도구. 노트가 100+ 누적되었을 때 RAG 대안으로 검토. 현재 미도입.

## Core Content
- [[llm-wiki]] 방식(LLM이 직접 wiki 유지)의 **그래프 기반 확장**
- 세션 시작 시 query 키워드 → 2-hop neighborhood 추출 → 컨텍스트 주입
- 토큰 절감: 전체 vault가 아닌 관련 subgraph만 로드

## Knowledge Connections
- **Related Topics:** [[llm-wiki]], [[p-reinforce]], [[obsidian]]
- **Adoption gate:** 노트 수 100+ 도달 시 재검토 ([[llm-wiki]] 원칙).

---
*Stub created 2026-04-22 — replace with concrete spec when adopted.*
