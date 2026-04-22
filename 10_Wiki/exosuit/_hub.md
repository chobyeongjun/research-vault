---
title: Exosuit Hub
updated: 2026-04-22
tags: [hub, exosuit, h-walker]
summary: Exosuit/H-Walker 도메인 노트 허브. 하드웨어·제어·안전 개념을 모은다.
---

# Exosuit — Hub

> 이 폴더는 케이블 드리븐 착용형 보행 보조 로봇([[exosuit]]) 도메인의 개념 노트를 모읍니다.
> 상위 프로젝트: [[h-walker]], [[assistive-vector-treadmill/README|assistive-vector-treadmill]].

## 플랫폼
- [[exosuit]] — 상위 개념
- [[h-walker]] — 핵심 프로토타입
- [[exosuit-hardware-overview]] — 하드웨어 구성 전체
- [[exosuit-handoff]] — 인수인계 로그
- [[exosuit-safety]] — 안전 이슈 모음
- [[stroke-gait-experiment]] — 환자 실험

## Hardware — Actuation
- [[ak60-motor]] — CubeMars AK60 (주 액추에이터)
- [[motor-benchmark]] — 모터 성능 분석
- [[motor-selection]] — 모터 선택 로직
- [[cable-driven-mechanism]] — 케이블 메커니즘

## Hardware — Driver / MCU / Bus
- [[elmo-gold-twitter]] — Elmo Gold Twitter 드라이버
- [[elmo-driver-comparison]] — 드라이버 비교
- [[teensy-4-1]] — 메인 MCU
- [[stm32h743]] — 대체 MCU 후보 (stub)
- [[can-communication]] — CAN 버스
- [[ebimu-imu]] — IMU 센서

## Control / Safety
- [[admittance-control]] — 어드미턴스/임피던스 제어
- [[robot-hardware-protection]] — 보호 회로 통합 설계
- [[exosuit-safety]]
