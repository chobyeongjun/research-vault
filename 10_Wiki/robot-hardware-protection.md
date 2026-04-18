---
tags: [로봇, Hardware, Protection, STM32, CAN]
created: 2026-04-14
summary: 케이블 드리븐 로봇의 반복적 고전류 상황에서 보드를 보호하기 위한 통합 하드웨어 아키텍처 및 안전 로직 정리.
---

# 🦾 로봇 시스템 보호 설계 (Robot Hardware Protection)

## 0. 설계 배경
- **문제**: 구동 시스템의 급격한 제어 시 발생하는 역기전력(EMF)이 버스 전압을 24V에서 140V 이상으로 폭주시켜 제어 보드 즉사.
- **해결**: 대용량 캐패시터와 능동 제동 회로, 물리적 격리(Isolation)를 결합한 5단계 방어선 구축.

## 1. 하드웨어 방어선 (Physical Layer)
상세 설계 수치 및 계측 데이터는 [[EXOSUIT_PROTECTION.md]] 참조.

### 1-1. 회생 에너지 흡수 (Regenerative Energy)
- **벌크 캐패시터 (11,280μF)**: 1J의 회생 에너지를 흡수하여 전압 상승을 28V 이내로 제한.
- **능동 제동 저항 (Braking Resistor)**: 26.5V 초과 시 3Ω/50W 저항으로 초과 에너지 소산.

### 1-2. 통신 및 로직 보호 (Communication)
- **ISO1050 (격리 CAN)**: 5000Vrms 격리로 Ground Bounce(전위 요동)로부터 MCU를 완벽히 하이딩.
- **다단계 TVS**: 600W급 TVS를 버스와 모터 로컬에 배치하여 ns 스파이크 차단.

## 2. 소프트웨어 방어선 (Firmware Layer)
하드웨어 구동 전 최후의 소프트웨어적 예방 로직.

### 2-1. Pre-emptive Derating
- **임계치**: 26.0V (하드웨어 트리거 0.5V 전).
- **동작**: 모터 토크 출력을 즉시 50% 이하로 제어하여 추가적인 에너지 유입 억제.

### 2-2. Health Monitoring
- CAN 통신의 Error Counter를 모니터링하여 물리적 전기 노이즈 상황 감지.
- 전압 스파이크 발생 횟수 및 최고 전압 기록 (Black-box 기능).

## 3. 관련 링크
- **설계 문서**: [[EXOSUIT_PROTECTION.md]]
- **비전 블로그**: [로봇 시스템 보호 설계 리포트](https://blog.naver.com/0xhenry/...)
- **유튜브 스크립트**: [[EP01_robot_hardware_failure.md]]

---
*Created by Antigravity for 0xHenry Lab.*
