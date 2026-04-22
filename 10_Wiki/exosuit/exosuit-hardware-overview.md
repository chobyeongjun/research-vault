---
tags: [project, exosuit, hardware, overview]
updated: 2026-04-13
---

# Exosuit 하드웨어 스펙 총괄

케이블 드리븐 착용형 외골격 | H-Walker 후속 보드

> **⚠️ 보조 방식**: 모터는 몸에 없음 → **워커(외부 프레임) 로봇에 모터 탑재**. 케이블이 외부에서 **정강이(shank)를 들어올려** swing phase 속도 보조. 근육 모사 아님. 고관절+무릎 모두 보조. 부착 방향: 위쪽 or 평행 (정확한 위치 미확정, 2026-04-14)

---

## 확정된 하드웨어

| 카테고리 | 선택 | 상태 |
|---------|------|------|
| 메인 MCU | STM32H743VIT6 (LQFP100) | ✅ 확정 |
| 모터 드라이버 | [[elmo-gold-twitter]] G-TWI15/100 × 4 | ✅ 확정 |
| 카메라 | [[zed-x-mini]] | ✅ 확정 |
| 컴퓨팅 | [[jetson-orin-nx]] 16GB | ✅ 확정 |
| IMU | [[ebimu-imu]] EBMotion V5 (RF) | ✅ 확정 |
| 로드셀 ADC | INA128UA + ADS1234 (5V AVDD) | ✅ 확정 |
| 배터리 모니터 | INA228 × 2 (최대 85V) | ✅ 확정 |

## 미결정 하드웨어

| 카테고리 | 옵션 | 결정 기준 |
|---------|------|---------|
| **모터** | T-Motor U8 Lite KV85 (1순위) / CubeMars RI60 KV120 | 풀리 설계 후 결정 |
| **배터리** | 24V 단일 / 24V×2 직렬(48V) | 모터 최종 선택 후 |

---

## 시스템 아키텍처

```
배터리 (24V or 48V)
    │
    ├── Elmo Twitter × 4 ──CANopen── STM32H743
    │   (각 모터 직결, 재생에너지 처리 포함)
    │
    └── DC/DC 컨버터
        ├── Jetson Orin NX 16GB
        │   ├── ZED X Mini (GMSL2 → ZED Link PCIe)
        │   └── EBIMU V5 수신기 (USB VCP)
        └── STM32H743 (3.3V/5V)
            ├── ADS1234 (로드셀 4ch, SPI)
            ├── INA228 × 2 (배터리 모니터, I2C)
            └── CANopen Master → Elmo × 4
```

---

## 통신 구조

| 링크 | 프로토콜 | 레이트 |
|------|---------|--------|
| STM32 → Elmo × 4 | CANopen CST | 500Hz |
| STM32 → Jetson | UART | 100Hz |
| STM32 → ADS1234 | SPI | 1kHz |
| Jetson → ZED X Mini | GMSL2 | 30~60 FPS |
| EBIMU → Jetson | USB VCP (RF 수신기) | 85~1000Hz |

---

## 보드 설계 상태

- `~/stm_board/BOARD_DESIGN_REVIEWED.md` (외부 repo) — CRITICAL 7개 수정 완료 버전
- [[robot-hardware-protection]] — 재생에너지/GND bounce 보호 회로

### 수정된 주요 BOM

| 기존 | 수정 후 | 이유 |
|------|--------|------|
| AP62200WU (24V max) | **TPS54560B** (60V) | 48V 시스템 대비 |
| INA333 + 5V 여기 | **INA128UA** + 5V 여기 | CMR 문제 |
| ADS1234 AVDD 3.3V | **ADS1234 AVDD 5V** | 최소 4.75V 요구 |
| TJA1051 CAN | **ISO1050 격리 CAN** | GND bounce 방지 |

---

## 다음 단계

1. [ ] 모터 최종 선택 (U8 Lite KV85 vs RI60 KV120)
2. [ ] 배터리 전압 확정 → 모터 선택 후
3. [ ] KiCad 스키매틱 시작 (MCU Core + Power sheet)
4. [ ] AS5047P 인코더 회로 설계 (U8 Lite 선택 시)
5. [ ] CANopenNode STM32H7 포팅

---

## 참고 자료

- Elmo Gold Twitter MAN-G-TWI (설치 가이드)
- TI CANopenNode GitHub
- Stereolabs ZED SDK Docs
- E2BOX EBIMU 매뉴얼
