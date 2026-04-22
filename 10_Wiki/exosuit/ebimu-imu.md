---
tags: [hardware, imu, sensor, rf, exosuit]
updated: 2026-04-13
---

# EBIMU — RF IMU 센서

제조사: **E2BOX (이투박스)** | e2box.co.kr

---

## 제품 라인업

| 구분 | 유선 (UART) | 무선 (RF 2.4GHz) |
|------|------------|-----------------|
| 현재 | EBIMU-9DOFV6 | EBMotion V6 |
| 이전 | EBIMU-9DOFV5-R3 (단종) | EBMotion V5 |

---

## EBMotion V5 (무선, 주력) — EBIMU24GV52 + EBRCV24GV5

| 항목 | 센서 | 수신기 |
|------|------|--------|
| RF | 2.4GHz ISM | 동일 |
| DOF | 9DOF (자이로+가속도+지자기) | — |
| 내부 갱신율 | **1000Hz** | — |
| 출력 레이트 | **1센서: 1000Hz / 15센서: 85Hz** | — |
| 데이터 포맷 | Euler, Quaternion, BVH | — |
| 전원 | 1셀 LiPo 내장 + USB 충전 | — |
| 소비 전류 | 30mA | — |
| 크기 | 32 × 24 mm | 39 × 26 mm |
| 인터페이스 | Micro USB | Micro USB (VCP, PC 연결) |
| 최대 연결 센서 | — | **최대 100개** |
| 가격 | ~290,000원 | ~175,000원 |

---

## EBMotion V6 (무선, 최신) — EBIMU24GV6 + EBRCV24GV6

| 항목 | 스펙 |
|------|------|
| RF | 2.4GHz ISM, 126채널, 최대 756 고유 ID |
| 출력 레이트 | **1센서 71Hz / 15센서 52Hz / 최대 100Hz** |
| 데이터 포맷 | Quaternion + Euler, BVH |
| 센서 크기 | 32 × 21 mm |
| 수신기 크기 | 100 × 50 mm (SMA 안테나) |
| 최대 연결 센서 | **최대 18개** (V5 대비 감소, 안정성 개선) |
| 인터페이스 | Micro USB (VCP), TTL 3.3V UART |

---

## EBIMU-9DOFV6 (유선 UART, 최신)

| 항목 | 스펙 |
|------|------|
| 출력 레이트 | 최대 **1000Hz** |
| 자이로 범위 | 250~2000 dps |
| 가속도 범위 | ±2g~±16g |
| 인터페이스 | UART (4핀: VCC/GND/TX/RX), 9600~921600 bps |
| 전압 | 3.3~6V / 소비 전류 15mA |
| 크기 | 16.3 × 18.6 mm |

---

## 외골격 적용 고려사항

**V5 선택 권장 이유:**
- 1센서 기준 1000Hz → 500Hz 제어 루프에 2× 오버샘플링
- 최대 100개 센서 → 전신 다관절 커버 가능
- BVH 출력 → 관절 각도 직접 활용

**주의:**
- 다수 센서 동시 사용 시 레이트 저하: 15개 → 85Hz (V5), 52Hz (V6)
- 고속 토크 제어 루프보다는 **자세 추정 / 의도 인식용**으로 적합
- STM32H743 UART 수신 가능 (UART1, RX only)

**ROS 패키지:** `e2box_imu_9dofv4` (GitHub)

---

## 관련 노트

- [[h-walker]] - 기존 AR_Walker 시스템
- [[elmo-gold-twitter]] - 모터 드라이버
