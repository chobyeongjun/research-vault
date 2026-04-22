---
title: H-Walker
created: 2026-04-13
updated: 2026-04-13
sources: []
tags: [exosuit, gait-rehabilitation, cable-driven, walker]
summary: 케이블 드리븐 워커 장착형 보행 재활 로봇. Treadmill/Overground 두 환경에서 운용.
confidence_score: 0.8
---

# H-Walker

## Brief Summary
케이블 드리븐 워커 장착형 보행 재활 로봇으로, Treadmill과 Overground 두 가지 환경에서 운용 가능하다.

## Core Content

### Hardware
- **MCU:** Teensy 4.1
- **Actuator:** AK60-6 V1.1 KV80 모터 (CAN ID 65, 33)
  - Max cable force: ~70N
- **IMU:** EBIMU-9DOF
- **Vision:** ZED 카메라

### Software
- **GUI:** Python (PyQt5, BLE)
- **Control:** C++ 제어
- **Firmware:** PlatformIO

### Control Loop
- Teensy inner loop: 111Hz
- Jetson outer loop: 10-30Hz

### Repository Structure
```
src/
  hw_common/
  hw_perception/
  hw_control/
  hw_treadmill/
  hw_overground/
firmware/
```

## Knowledge Connections
- **Related Topics:** [[ak60-motor]], [[admittance-control]], [[gait-analysis]], [[realtime-pose-estimation]]
- **Projects/Contexts:** [[stroke-gait-experiment]], [[motor-benchmark]], [[3d-assistance]], [[2026-bumbuche-grant]]
- **Contradictions/Notes:** 

---
*Last updated: 2026-04-13*
