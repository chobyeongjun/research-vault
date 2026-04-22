---
tags: [project, exosuit, handoff, status]
updated: 2026-04-14
---

# Exosuit 보드 프로젝트 — 인수인계

---

## 현재 상태: 모터/드라이버 선택 대기

**블로커**: 필요 연속 전류 계산 → 모터 확정 → 드라이버 확정 → 배터리 확정

---

## 확정 하드웨어

| 항목 | 선택 | 스펙 노트 |
|------|------|---------|
| MCU | STM32H743VIT6 | [[teensy-4-1]] 에서 전환 |
| IMU | EBIMU EBMotion V5 (RF) | [[ebimu-imu]] |
| 카메라 | ZED X Mini | [[zed-x-mini]] |
| 컴퓨팅 | Jetson Orin NX 16GB | [[jetson-orin-nx]] |
| 로드셀 앰프 | INA128UA (5V 단전원) | INA333에서 교체 (CMR 문제) |
| 로드셀 ADC | ADS1234 (AVDD=5V, DVDD=3.3V) | 24bit 4ch 동시 |
| 배터리 모니터 | INA228 × 2 | 직렬 배터리 개별 측정 |
| 제어 통신 | CANopen CiA 402 | CANopenNode (오픈소스) |
| RTOS | FreeRTOS | STM32CubeMX |

---

## 미확정 — 후보 리스트

### 모터 후보

| 순위 | 모델 | Kt (Nm/A) | 무게 | RPM@48V | 인코더 | 가격 | 비고 |
|------|------|----------|------|---------|--------|------|------|
| 1 | **T-Motor U8 Lite KV85** | 0.112 | 220g | 4,080 | 없음 (AS5047P 추가) | $60~80 | 팬케이크형, 드론용 → 연속구동 발열 확인 필요 |
| 2 | **CubeMars RI60 KV120** | 0.080 | ~180g | 5,760 | Hall 내장 | $80~120 | 외골격 전용, Elmo 즉시 연결 |
| 3 | **Maxon EC-i 40 70W** | 0.033 | 345g | 25,000 | ENX/MILE (Elmo 호환) | $400~600 | 검증 최고, 원통형 → 패키징 불리 |

→ 상세: [[motor-selection]]

### Elmo 드라이버 후보

| 순위 | 모델 | 크기 (mm) | 무게 | 최대 연속전류 | 형태 | 비고 |
|------|------|----------|------|------------|------|------|
| 1 | **Gold Twitter** G-TWI | 35×30×11.5 | **18g** | 50A | PCB 납땜 모듈 | 최소형, 커스텀 PCB 필수 |
| 2 | **Gold Solo Twitter** G-SOLTWI | ~47×40×30 | 32~60g | 70A | 독립 커넥터 | 프로토타입에 유리, PCB 불필요 |
| 3 | **Gold Whistle** G-WHIS | 55×46×15 | 55g | **20A** | PCB 모듈 | 단일전원 기본, I/O 풍부, 전류 한계 |

→ 상세: [[elmo-driver-comparison]]

### 배터리 후보

| 옵션 | 전압 | 속도 향상 | 장점 | 단점 |
|------|------|---------|------|------|
| **24V 단일 (6S)** | 25.2V 완충 | 기준 | 단순, 안전 | 속도 제한 |
| **24V×2 직렬 (12S)** | 50.4V 완충 | **+83%** | 속도 2배, 무게 분산 | 12S BMS, 모터 내압 확인 |
| **33V 단일 (8S)** | 33.6V 완충 | +25% | 중간 타협, AK 모터 안전 | 새 팩 구매 |

---

## 다음에 해야 할 것 (순서대로)

### 1. 필요 연속 전류 계산

```
조건: 스윙(유각기) 시 외부에서 보조력 인가
필요 데이터:
  - 스윙 위상 관절 토크 프로파일 (보행 데이터)
  - 보조 비율 (10~30% 예상)
  - 외골격 모멘트 암 d_moment (mm)
  - 풀리 반경 r_pulley (mm)

계산:
  τ_assist   = 보행 토크 × 보조비율
  F_cable    = τ_assist / d_moment
  τ_motor    = F_cable × r_pulley
  I_required = τ_motor / Kt
```

### 2. 모터 확정
→ I_required vs 후보 모터 Kt/전류정격 비교

### 3. Elmo 드라이버 확정
→ 모터 전류 20A 초과? → Twitter/Solo Twitter
→ 20A 이하? → Whistle도 가능

### 4. 배터리 확정
→ 모터 전압 범위 + 속도 목표

### 5. KiCad 스키매틱
→ Nucleo-H743ZI로 펌웨어 병렬 개발 가능

---

## CRITICAL 이슈 (설계 시 반드시 반영)

| # | 문제 | 수정 방법 |
|---|------|---------|
| C1 | 벅 컨버터 VIN 부족 | TPS54560B (60V) 사용 |
| C2 | P-MOS VGS 초과 | 12V 제너(BZT52C12) 추가 |
| C3 | VCAP_2 핀 누락 | Pin 33, 57 각각 2.2μF |
| C4 | VREF+ 핀 미처리 | VDDA 직결 + 디커플링 |
| C5 | ADS1234 AVDD 5V 필수 | 3.3V 공급 불가 |
| C6 | INA333 CMR 문제 | INA128UA로 교체 |
| C7 | CAN GND bounce → 파손 | ISO1050 격리 CAN 사용 |

---

## 핵심 기술 결정 사항

### 보조 방식 — 외부 워커 로봇에서 외력 인가
> ⚠️ 절대 혼동 금지

- **모터 위치**: 몸 위가 아님. **워커(외부 보행 프레임)에 달린 로봇**에 모터 탑재
- **케이블 경로**: 워커 로봇(외부) → 정강이(shank). 몸을 따라가지 않음, 바깥에서 당김
- **역할**: 근육 모사 ✗ → **외력(External Force)으로 정강이를 들어올려 swing 속도 보조**
- **관절 보조**: 외력이 정강이에 작용하므로 **고관절 + 무릎 모두 보조 가능**
- **부착 방향**: 위쪽(upward) 또는 평행(parallel) — 정확한 위치/방향 미확정 (2026-04-14)
- **설계 철학**: 사람이 주 동력, 외골격은 속도 보조 → **속도 >> 토크**
- **중요**: 모터/배터리 무게 = 착용자 부담 아님 (워커에 있으므로)

### MIT 모드 안 쓰는 이유
케이블 드리븐 → 풀리 r(θ) 변화 → T_ff 계산 어려움
→ 서보(전류) 모드 + 어드미턴스 피드백이 기구학 불확실성 흡수

### 속도 > 토크인 이유
케이블 = 외력 보조 → 사람이 주 동력
모터 역할: 빠르게 따라가기 > 세게 밀기
→ 높은 Kv + 높은 전압 선호

### 보드 파손 원인 (기존)
4모터 동시 릴리즈 → 재생 1J → C_bus 부족 시 143V 폭주
→ 11,280μF 벌크 + 26.5V 제동저항 + ISO1050 격리

---

## 설계 문서 위치

| 위치 | 파일 |
|------|------|
| `~/stm_board/BOARD_DESIGN_REVIEWED.md` | CRITICAL 7개 수정 보드 설계 |
| `~/stm_board/EXOSUIT_PROTECTION.md` | 보호 회로 최종 설계 |
| Obsidian `10_Wiki/Topics/` | 각 하드웨어 스펙 노트 |
| Obsidian `10_Wiki/Projects/` | 총괄 + 이 핸드오프 |

---

## 참고 자료

| 소스 | 용도 |
|------|------|
| [mjbots/moteus](https://github.com/mjbots/moteus) | STM32+CAN 보호 설계 |
| [CANopenNode](https://github.com/CANopenNode/CANopenNode) | STM32 CANopen 스택 |
| [TI WEBENCH](https://webench.ti.com) | 벅 컨버터 자동 설계 |
| [AR_Walker](https://github.com/chobyeongjun/AR_Walker) | 기존 시스템 코드 |
| [Elmo Gold Twitter](https://www.elmomc.com/product/gold-twitter/) | 드라이버 공식 |

---

## 관련 노트

- [[exosuit-hardware-overview]] - 하드웨어 총괄
- [[motor-selection]] - 모터 후보 상세
- [[elmo-driver-comparison]] - Elmo 비교표
- [[ebimu-imu]] / [[zed-x-mini]] / [[jetson-orin-nx]] - 확정 스펙
