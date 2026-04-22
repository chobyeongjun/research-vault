---
title: Teensy 4.1
created: 2026-04-13
updated: 2026-04-13
sources: []
tags: [mcu, teensy, arm, embedded]
summary: ARM Cortex-M7 기반 MCU. h-walker Exosuit의 메인 컨트롤러로 111Hz 제어 주기를 구현한다.
confidence_score: 0.8
---

# Teensy 4.1

## Brief Summary
NXP iMXRT1062 기반 ARM Cortex-M7 MCU로, 600MHz 클럭과 풍부한 주변장치를 갖추고 있다. h-walker Exosuit의 실시간 제어를 담당한다.

## Core Content

### 주요 사양
- **프로세서:** ARM Cortex-M7 (NXP iMXRT1062)
- **클럭:** 600MHz
- **RAM:** 1MB
- **Flash:** 8MB (QSPI)
- **ADC:** 12-bit
- **동작 전압:** 3.3V
- **SD 카드:** 내장 슬롯

### h-walker에서의 역할
- 메인 컨트롤러로 사용
- 제어 주기: 111Hz (~9ms)
- CAN 통신으로 4개 AK60 모터 제어
- 센서 데이터 수집 (로드셀, IMU 등)
- SD 카드에 실험 데이터 로깅

### 개발 환경
- **빌드 시스템:** PlatformIO
- **CAN 라이브러리:** FlexCAN_T4
- **프레임워크:** Arduino (Teensyduino)

### 주의사항
- 3.3V 로직이므로 5V 센서 인터페이스 시 레벨 시프터 필요
- ADC 12-bit 해상도 (0~3.3V 범위)
- CAN 트랜시버 별도 필요 (ISO1050 권장)

## Knowledge Connections
- **Related Topics:** [[h-walker]], [[can-communication]], [[ak60-motor]]
- **Projects/Contexts:** [[h-walker]] Exosuit 임베디드 제어 시스템
- **Contradictions/Notes:** 600MHz이지만 FPU 단정밀도만 하드웨어 지원, 배정밀도는 소프트웨어 에뮬레이션

---
*Last updated: 2026-04-13*
