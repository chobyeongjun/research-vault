---
title: AK60-6 Motor
created: 2026-04-13
updated: 2026-04-13
sources: []
tags: [motor, bldc, can-bus, cubemars]
summary: CubeMars AK60-6 V1.1 BLDC 모터. h-walker Exosuit의 주 액추에이터.
confidence_score: 0.8
---

# AK60-6 Motor

## Brief Summary
CubeMars AK60-6 V1.1은 유성기어 내장 BLDC 모터로, CAN 통신 기반 MIT 모드 및 서보 모드를 지원한다. h-walker Exosuit의 핵심 액추에이터이다.

## Core Content

### 사양
- **KV80 버전:** h-walker 프로젝트에서 사용
- **KV140 버전:** 벤치마크 테스트용
- **기어비:** 6.0 (유성기어)
- **극쌍:** 14
- **Kt:** 0.078 Nm/A
- **연속 전류:** 6.5A
- **피크 전류:** 22.7A

### 통신
- CAN 버스 1Mbps 고정
- **MIT 모드:** 위치/속도/KP/KD/토크 패킷 전송
- **서보 모드:** 위치/속도 명령

### 회생 제동 위험 (CRITICAL)
4모터 동시 회생 시 버스 캐패시터 부족 문제 발생:
- 버스 전압 V = 143V까지 폭주 가능
- **대책 1:** 11,280uF 벌크 캐패시터 추가
- **대책 2:** 26.5V 제동저항 설치
- **대책 3:** ISO1050 격리 CAN 트랜시버 사용

## Knowledge Connections
- **Related Topics:** [[h-walker]], [[motor-benchmark]], [[admittance-control]]
- **Projects/Contexts:** [[h-walker]] Exosuit 4-DOF 보행 보조
- **Contradictions/Notes:** KV80과 KV140의 토크/속도 특성이 다르므로 제어 게인 재조정 필요

---
*Last updated: 2026-04-13*
