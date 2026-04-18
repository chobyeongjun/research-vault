# Wiki Index

> AI가 관리하는 목차. 직접 수정하지 마세요.

## Projects
- [[h-walker]] - 케이블 드리븐 워커 장착형 보행 재활 로봇
- [[motor-benchmark]] - AK60 모터 성능 분석 시스템
- [[realtime-pose-estimation]] - ZED + MediaPipe 실시간 포즈 추정
- [[stroke-gait-experiment]] - 뇌졸중 환자 대상 exosuit 보행 실험
- [[2026-bumbuche-grant]] - 2026년 범부처 보행재활로봇 과제
- [[3d-assistance]] - 3D 보조력 전달 연구

## Topics
- [[admittance-control]] - 어드미턴스/임피던스 제어
- [[ak60-motor]] - CubeMars AK60-6 V1.1 모터
- [[gait-analysis]] - 보행 분석 (GCP, 대칭성, 이벤트 검출)
- [[can-communication]] - CAN 버스 통신 프로토콜
- [[cable-driven-mechanism]] - 케이블 드리븐 메커니즘
- [[teensy-4-1]] - Teensy 4.1 MCU
- [[exosuit-safety]] - Exosuit 안전 이슈 모음
- [[antigravity]] - Google Antigravity IDE
- [[gemma-4]] - 구글 오픈소스 LLM
- [[llm-wiki]] - Karpathy LLM Wiki 패턴
- [[obsidian]] - 로컬 마크다운 노트앱
- [[p-reinforce]] - LLM Wiki + RL 기반 지식 자동화 에이전트

## Decisions
(아직 없음)

## Skills
(아직 없음)

## 다음 미팅 준비
```dataview
TABLE date, file.folder FROM "realtime-vision-control/meetings" OR "assistive-vector-treadmill/meetings"
SORT date DESC
LIMIT 5
미완성 실험 (tier: raw)
TABLE date, title FROM "realtime-vision-control/experiments" OR "assistive-vector-treadmill/experiments"
WHERE tier = "raw"
SORT date DESC
논문 진행 현황
TABLE file.name, status FROM "realtime-vision-control/papers" OR "assistive-vector-treadmill/papers"
