---
tags: [hardware, motor-driver, canopen, exosuit, servo]
updated: 2026-04-13
---

# Elmo Gold Twitter — 서보 드라이버

제조사: **Elmo Motion Control** | elmomc.com  
형태: PCB 직접 솔더 모듈 (Pin-mount nano servo drive)

---

## 추천 모델: G-TWI15/100

| 항목 | 스펙 |
|------|------|
| 입력 전압 | **10~95V DC** |
| 연속 전류 | **15A** (amplitude) |
| 피크 전류 | **30A** (2×, ~3초) |
| 크기 | **35 × 30 × 11.5 mm** |
| 무게 | **18.6 g** (히트싱크 없음) |
| 히트싱크 포함 | 47 × 41.3 × 15.5 mm / 39.6 g |

---

## 전체 라인업 (100V 계열)

| 파트넘버 | 연속 전류 | 피크 전류 |
|---------|---------|---------|
| G-TWI1/100 | 1A | 2A |
| G-TWI3/100 | 3A | 6A |
| G-TWI6/100 | 6A | 12A |
| G-TWI10/100 | 10A | 20A |
| **G-TWI15/100** | **15A** | **30A** |
| G-TWI25/100 | 25A | 50A |

---

## 지원 모터 타입

- AC 서보 (PMSM) ✅
- BLDC ✅
- DC 브러시드 ✅
- 리니어 모터 ✅

---

## 피드백 센서 지원

| 포트 | 지원 센서 |
|------|---------|
| Port A | 인크리멘탈 인코더, Serial 절대치(EnDat/BiSS/SSI), Hall |
| Port B | 인크리멘탈, Sin/Cos(아날로그), Resolver |
| 절대치 프로토콜 | EnDat 2.1/2.2/3, BISS, SSI, HIPERFACE, Hiperface DSL |

---

## 통신 — CANopen CiA 402

| 항목 | 스펙 |
|------|------|
| 프로토콜 | CANopen DS301 ✅ |
| 모터 제어 | **CiA 402 (DS402) 완전 지원** |
| 지원 모드 | CSP, CSV, **CST**, PP, PV, IP |
| 기타 | EtherCAT, RS232, USB, TCP/IP |

**외골격 추천 모드:**
- **CST (Cyclic Sync Torque)**: 어드미턴스 제어 → 토크 명령
- **CSV (Cyclic Sync Velocity)**: 속도 우선 제어

---

## 전원 요구사항

| 항목 | 스펙 |
|------|------|
| 주 전원 (VP+) | 10~95V DC |
| 로직 전원 (VL) | **12~40V DC 별도 필요**, <2.5W |
| 단일 전원 옵션 | 'P' suffix 모델 → VL 불필요 |

> ⚠️ **주의**: 기본 모델은 로직 전원 분리 필요.  
> `G-TWI15/100P` (P suffix) → 단일 전원으로 동작

---

## 재생 에너지 처리 ⚠️

**내부 클램프 없음** → 과전압 트립만 존재

외부 처리 필요:
- 버스 캐패시터 (큰 용량)
- 외부 션트 저항 모듈 (Elmo G-OBO 시리즈)
- 또는 [[robot-hardware-protection]] 설계 내용 참고

---

## 보호 기능

- 과전류 (Overcurrent)
- 과전압 (Overvoltage)
- 저전압 (Undervoltage)
- 과열 (연속 모니터링)
- 단락 보호
- **STO** (Safe Torque Off, IEC 61800-5-2)

---

## 외골격 적용 시 확인사항

- [ ] 단일 전원 모델 ('P' suffix) 선택 여부
- [ ] 모터 인코더 타입 확인 (Hall만이면 Port A에 직결)
- [ ] 재생 에너지 처리 (외부 벌크 캐패시터 필수)
- [ ] CANopen 마스터: [[stm32h743]] + CANopenNode

---

## 관련 노트

- [[motor-selection]] - 호환 모터 선택
- [[robot-hardware-protection]] - 보호 회로 설계
- [[h-walker]] - 기존 시스템
