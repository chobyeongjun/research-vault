---
title: Assistive Vector Treadmill
created: 2026-04-22
updated: 2026-04-22
tags: [project, hub, exosuit, treadmill]
summary: H-Walker treadmill 환경 assistive force vector 연구 프로젝트 허브.
---

# Assistive Vector Treadmill

## 프로젝트 개요

케이블 드리븐 워커 장착형 보행 재활 로봇 ([[h-walker]]) 의 **treadmill 환경** assistive force vector 제어 연구.
상세 컨텍스트는 [[research_context]] 참조.

## 관련 개념 (10_Wiki)

### Hardware
- [[ak60-motor]] — 주 액추에이터 (cable force max 70N)
- [[teensy-4-1]] — 내부 제어 루프 (111Hz)
- [[jetson-orin-nx]] — 외부 제어 루프 (10~30Hz)
- [[zed-x-mini]] — 비전 센서
- [[robot-hardware-protection]] — 보호 회로

### Control
- [[admittance-control]] — 임피던스/어드미턴스 제어
- [[cable-driven-mechanism]] — 케이블 메커니즘
- [[can-communication]] — 통신 프로토콜

### Perception
- [[realtime-pose-estimation]] — MediaPipe / ZED 포즈
- [[gait-analysis]] — 보행 분석

### Upper-level
- [[h-walker]] — 플랫폼 전체
- [[exosuit]] — 상위 개념
- [[3d-assistance]] — 3D 보조력
- [[stroke-gait-experiment]] — 환자 실험

## 관련 프로젝트

- [[realtime-vision-control/README|realtime-vision-control]] — 실시간 비전 기반 제어 (overground)

## 폴더 구조

- `experiments/` — 개별 실험 기록
- `meetings/` — 미팅 노트
- `papers/` — 논문 드래프트 / 레퍼런스

---
*Project hub. 모든 도메인 개념은 위 wikilink로 도달.*
