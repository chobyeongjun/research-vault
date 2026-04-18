---
title: Exosuit Safety
created: 2026-04-13
updated: 2026-04-13
sources: []
tags: [safety, hardware, critical]
summary: h-walker Exosuit의 안전 관련 CRITICAL 이슈 모음. 전압 폭주, 정격 초과, ADC 미동작 등.
confidence_score: 0.8
---

# [[Exosuit Safety]]

## Brief Summary
h-walker Exosuit 개발 과정에서 발견된 하드웨어 안전 이슈들을 정리한 문서. 다수의 CRITICAL 등급 문제가 포함되어 있다.

## Core Content

### CRITICAL: 4모터 동시 회생 → 버스 전압 폭주
- 4개 AK60 모터가 동시에 회생 제동 시 버스 캐패시터 부족
- 버스 전압이 V = 143V까지 폭주 가능
- **대책:** 11,280uF 벌크 캐패시터 + 26.5V 제동저항 + ISO1050 격리 CAN

### CRITICAL: AP62200WU VIN 정격 초과
- AP62200WU 레귤레이터의 VIN 최대 정격: 24V
- 6S LiPo 완충 전압: 25.2V
- 완충 상태에서 정격 초과 → 레귤레이터 손상 위험

### CRITICAL: INA333 + 5V 로드셀 VCM 허용 초과
- INA333 계측 증폭기의 Common Mode 전압 허용 범위 초과
- 5V 로드셀과 조합 시 VCM이 허용 범위를 넘음
- 잘못된 측정값 또는 IC 손상 가능

### CRITICAL: ADS1234 AVDD 부족
- ADS1234 ADC의 AVDD 최소 요구 전압: 4.75V
- 실제 공급 전압: 3.3V
- ADC가 정상 동작하지 않음

### CRITICAL: E-stop 미구현
- 비상 정지 버튼 미구현 상태
- CAN 통신 타임아웃 감시 없음
- 통신 두절 시 모터가 마지막 명령을 유지할 위험

## Knowledge Connections
- **Related Topics:** [[h-walker]], [[ak60-motor]], [[stroke-gait-experiment]]
- **Projects/Contexts:** [[h-walker]] 하드웨어 안전 감사
- **Contradictions/Notes:** 모든 CRITICAL 이슈는 인체 착용 실험 전 반드시 해결 필요

---
*Last updated: 2026-04-13*
