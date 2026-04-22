---
title: Motor Benchmark
created: 2026-04-13
updated: 2026-04-13
sources: []
tags: [motor, benchmark, can-bus, teensy]
summary: AK60 모터 성능 분석 시스템. Teensy 4.1 기반 실시간 벤치마크.
confidence_score: 0.8
---

# Motor Benchmark

## Brief Summary
AK60 모터의 서보/MIT 모드 성능을 Teensy 4.1 기반으로 실시간 벤치마킹하는 시스템이다.

## Core Content

### Test Configuration
- **서보 모드:** CAN 테스트 1-500Hz
- **MIT 모드:** CAN 테스트 1-2000Hz
- **MCU:** Teensy 4.1

### Analysis
- 적응형 병목 분석 수행
  - CAN 대역폭 한계
  - 모터 내부 지연
  - MCU 처리 한계

## Knowledge Connections
- **Related Topics:** [[h-walker]], [[ak60-motor]], [[can-communication]]
- **Projects/Contexts:** [[h-walker]]
- **Contradictions/Notes:** 

---
*Last updated: 2026-04-13*
