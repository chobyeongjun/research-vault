---
title: 조병준 — 개인 스펙
updated: 2026-04-23
tags: [meta, profile, spec]
summary: 연구자 개인 스펙. 진행 중인 작업이 완료/변경될 때마다 업데이트.
---

# 조병준 (Cho Byeong-jun)

- GitHub: [chobyeongjun](https://github.com/chobyeongjun)
- Email: menaldo1234@gmail.com

---

## 연구 정체성

케이블 드리븐 보행 재활 로봇 분야. H-Walker 플랫폼을 중심으로
하드웨어(PCB 설계) → 펌웨어(STM32/Teensy) → 엣지 AI(Jetson TRT) → 제어(임피던스/ILC)
수직 스택을 다루는 연구자.
환자 대상 시스템이라 안전 설계가 절대 우선.

---

## 기술 스택

| 레이어 | 스택 |
|--------|------|
| 엣지 AI | CUDA Stream, TensorRT FP16, YOLO, Jetson JetPack 6 |
| 제어 | Impedance/Admittance Control, ILC, Cable-driven 역학 |
| 펌웨어 | Teensy 4.1, STM32H743, FreeRTOS, CAN/CANopen, ISR 설계 |
| 시스템 | POSIX SHM seqlock, multi-process real-time |
| PCB | KiCad, BOM 설계 (power/motor/sensor) |
| 언어 | Python, C++ |
| 도구 | Obsidian (Second Brain), Claude Code, graphify, git |

---

## 플랫폼

### H-Walker

케이블 드리븐 보행 재활 워커 로봇.
모터는 착용자 몸이 아닌 외부 워커 프레임에 탑재.
케이블이 외부에서 정강이(shank)를 당겨 swing phase 속도 보조.
사람이 주 동력, 로봇은 속도 보조 역할.

**시스템 구성**

| 구성요소 | 사양 |
|----------|------|
| 액추에이터 | AK60 motor (CAN bus), max cable force 70N |
| MCU | Teensy 4.1 (111Hz inner loop) |
| Edge SBC | Jetson Orin NX 16GB (JetPack 6, MAXN) |
| 카메라 | ZED X Mini (GMSL2, SVGA @120fps, Global Shutter) |
| 모델 | yolo26s-lower6-v2 (TRT FP16, 6 keypoints) |

### Exosuit (차세대)

H-Walker 후속 — 보조 방식 동일 (외부 워커 + 케이블), 제어 보드 신규 설계.

**확정 하드웨어**

| 항목 | 선택 |
|------|------|
| MCU | STM32H743VIT6 |
| 모터 드라이버 | Elmo Gold Twitter × 4 (CANopen) |
| 카메라 | ZED X Mini |
| SBC | Jetson Orin NX 16GB |
| IMU | EBIMU EBMotion V5 (RF) |
| 로드셀 ADC | INA128UA + ADS1234 (AVDD 5V) |

**미확정**
- 모터: T-Motor U8 Lite KV85 (1순위) vs CubeMars RI60 KV120
- 배터리: 24V 단일 vs 48V 직렬

---

## 프로젝트 현황

### realtime-vision-control ✅ stable (2026-04-21, v0.1.0)

비전 기반 실시간 임피던스 제어. [[realtime-vision-control/research_context]] 참조.

**성능 (v0.1.0 stable)**

| 지표 | 값 |
|------|----|
| Throughput | 86 Hz (단독), 77 Hz (viewer 켠 상태) |
| e2e p99 | 14.46 ms |
| HARD LIMIT 위반 | 0.000% (180s, 13,872 frames) |

**다음 단계**
- [ ] C++ control + Teensy 실제 통합 검증
- [ ] 장시간 thermal drift 측정 (10분+)
- [ ] 실제 모터 구동 (pretension → impedance)
- [ ] Paper 1 (RA-L) 집필 시작

### Exosuit PCB ⏳ 설계 대기

**현재 블로커**: 필요 연속 전류 계산 → 모터 확정 → 배터리 확정 → KiCad 시작

**다음 단계**
- [ ] 스윙 관절 토크 프로파일로 연속전류 계산
- [ ] 모터 확정 (U8 Lite vs RI60)
- [ ] 배터리 전압 확정
- [ ] KiCad 스키매틱 시작

### H-Walker AI ⏳ 진행 중

H-Walker 보행 데이터 기반 LLM 파인튜닝 + Graph App LLM 기능.

**다음 단계**
- [ ] LLM 품질 개선 Phase 1 완료
- [ ] Graph App LLM Plotting 검증

---

## 논문 트랙

### 현재 진행 (H-Walker)

| 논문 | 타겟 | 상태 |
|------|------|------|
| Paper 1: Vision-Based Impedance Control | RA-L | 15% — pipeline 완료, 제어 실험 미실시 |
| Paper 2: RL Sim-to-Real Policy | TBD | 기획 단계 |

### 과거 참여 논문

| 논문 | 저널 | 연도 | 역할 |
|------|------|------|------|
| "Effect of a soft wearable robot suit with hip extensor assistance on gait in patients with Parkinson's disease: a study protocol" | Frontiers in Neurology | 2025 | 공저자 |
| DOI: 10.3389/fneur.2025.1695612 | | | 소속: School of Mechanical Engineering, Chung-Ang University |

---

## 배경 / 이력

### 학력 / 소속
- 중앙대학교 기계공학부 학사 졸업
- 중앙대학교 기계공학부 석사 과정 재학 중 (대학원)
- 중앙대 보조및재활로봇연구실 (ARLab, 지도교수: 이기욱)

### 활동
- **마하 드론 동아리** — 드론 모델링 기반 제작 (수동 모델링 → 실제 드론 제작까지)
- 중앙대 + 휴로틱스 협업 연구 (Frontiers in Neurology 2025 논문 공저)

### 특허
- 중앙대 / 휴로틱스 관련 특허 존재 가능성 — KIPRIS 직접 확인 필요 (발명자: 조병준)

---

## 과제 / 재원

| 과제 | 상태 |
|------|------|
| 2026 범부처 과제 (국립재활원 연계, exosuit 보행재활) | 신청 준비 중 (계획서 V10) — 미선정 |

---

## 안전 원칙 (불변)

- 케이블 force hard limit: **70N** (AK60 한계)
- 비전 latency hard limit: **20ms** (위반 시 valid=False, 모터 skip)
- 7-layer 안전 chain 항상 활성 유지
- Python → Teensy 직접 송신 절대 금지 (C++ 안전 chain 우회)
