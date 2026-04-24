---
title: Wiki Index
updated: 2026-04-22
tags: [meta, moc, index]
summary: Vault 전체 MOC. 모든 wiki 노트가 여기서 도달 가능. Claude가 세션 중 필요 시 스캔.
---

# Wiki Index (MOC)

> **읽는 순서**: [[claude-rules]] → [[Lessons]] (Active Rules) → 이 파일 (필요 시).
> 모든 wiki 노트는 basename wikilink로 참조. 누락 발견 시 즉시 추가.

## 🔧 [[10_Wiki/exosuit/_hub|Exosuit]] — 착용형 보행 보조 로봇

**Platform**
- [[exosuit]] · [[h-walker]] · [[exosuit-hardware-overview]] · [[exosuit-handoff]] · [[exosuit-safety]] · [[stroke-gait-experiment]]

**Actuation**
- [[ak60-motor]] · [[motor-benchmark]] · [[motor-selection]] · [[cable-driven-mechanism]]

**Driver / MCU / Bus**
- [[elmo-gold-twitter]] · [[elmo-driver-comparison]] · [[teensy-4-1]] · [[stm32h743]] · [[can-communication]] · [[ebimu-imu]]

**Control / Safety**
- [[admittance-control]] · [[robot-hardware-protection]]

## 📷 [[10_Wiki/perception/_hub|Perception]] — 실시간 비전·포즈·게이트

- [[realtime-vision-control]] · [[realtime-pose-estimation]] · [[perception-evolution-master]]
- [[zed-x-mini]] · [[jetson-orin-nx]]
- [[gait-analysis]]

## 🤖 [[10_Wiki/h-walker-ai/_hub|H-Walker AI]] — LLM fine-tuning / Graph App

- [[H-Walker LLM Fine-tuning 파이프라인]]
- [[H-Walker LLM 품질 개선 Phase 1]]
- [[H-Walker Fine-tuning 빠른 시작]]
- [[H-Walker 5090 Fine-tuning 설정 가이드]]
- [[H-Walker Graph App 사용 가이드]]
- [[H-Walker Graph App LLM Plotting 검증 수정 인수인계]]
- [[h-walker-graph-app-knowledge]]

## 📝 [[10_Wiki/grants/_hub|Grants]] — 과제·제안서

- [[2026-bumbuche-grant]] · [[3d-assistance]]

## 💡 [[10_Wiki/concepts/_hub|Concepts]] — 메타·AI·도구

- [[llm-wiki]] · [[p-reinforce]] · [[obsidian]] · [[graphify]]
- [[antigravity]] · [[gemma-4]]
- [[0xhenry-dev]] · [[skiro-learnings]]

## 🧪 Projects (top-level)

- [[assistive-vector-treadmill/README|assistive-vector-treadmill]] — treadmill assistive force vector 연구
  - [[assistive-vector-treadmill/research_context|research_context]]
- [[realtime-vision-control/README|realtime-vision-control]] — 실시간 비전 제어
  - [[realtime-vision-control/research_context|research_context]]

## 📂 Raw (원본, 불변)

- `00_Raw/` — 인수인계·회의 로그·파이프라인 원본 (Obsidian Graph 연결은 [[perception-evolution-master]], [[realtime-vision-control]] 경유)

## 🗂 Meta

- [[me]] — 개인 스펙 (프로젝트 현황, 기술 스택, 논문 트랙)
- [[claude-rules]] — 세션 시작 규칙
- [[Lessons]] — RL-loop 메모리 (wins/misses, Active Rules)
- [[Log]] — 작업 로그
- [[obsidian-sync-setup]] — Obsidian Git 자동 싱크 셋업 가이드

---

## Dataview (Obsidian 내)

```dataview
TABLE file.folder AS "폴더", length(file.inlinks) AS "incoming"
FROM "10_Wiki" OR "20_Meta"
SORT length(file.inlinks) DESC
LIMIT 20
```

```dataview
TABLE date FROM "realtime-vision-control/meetings" OR "assistive-vector-treadmill/meetings"
SORT date DESC
LIMIT 5
```
