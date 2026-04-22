---
title: CAN Communication
created: 2026-04-13
updated: 2026-04-13
sources: []
tags: [can-bus, communication, protocol, teensy]
summary: CAN 버스 통신 프로토콜. AK60 모터와 Teensy MCU 간 1Mbps 통신에 사용된다.
confidence_score: 0.8
---

# CAN Communication

## Brief Summary
CAN(Controller Area Network) 버스는 AK60 모터와 Teensy MCU 간의 실시간 통신에 사용되며, MIT 모드와 서보 모드의 명령/피드백 패킷을 전달한다.

## Core Content

### 기본 설정
- **통신 속도:** 1Mbps 고정
- **라이브러리:** FlexCAN_T4 (Teensy 전용)
- **트랜시버:** ISO1050 격리 CAN 트랜시버 권장

### AK60 통신 프로토콜

#### MIT 모드 패킷
위치(p), 속도(v), KP, KD, 토크(T_ff) 5개 파라미터를 단일 CAN 프레임에 패킹:
- 각 값은 정해진 비트 범위 내에서 정규화
- 응답: 현재 위치, 속도, 토크

#### 서보 모드 패킷
위치 및 속도 명령:
- 모터 내부 PID로 위치 추종
- MIT 모드보다 단순하지만 유연성이 낮음

### 성능 병목 분석
세 가지 지연 요소가 전체 제어 주기를 결정:
1. **CAN 대역폭:** 1Mbps에서 8-byte 프레임 전송 ~0.1ms
2. **모터 내부 처리 지연:** 모터 펌웨어의 명령 해석 시간
3. **MCU 처리:** Teensy의 제어 루프 연산 시간

### ISO1050 격리 CAN 트랜시버
- 모터 회생 시 전압 스파이크로부터 MCU 보호
- 그라운드 루프 방지
- 4모터 시스템에서 필수적

## Knowledge Connections
- **Related Topics:** [[ak60-motor]], [[h-walker]], [[motor-benchmark]]
- **Projects/Contexts:** [[h-walker]] 4-DOF Exosuit 실시간 제어
- **Contradictions/Notes:** CAN FD(Flexible Data-rate) 미지원 - AK60 펌웨어 제약

---
*Last updated: 2026-04-13*
