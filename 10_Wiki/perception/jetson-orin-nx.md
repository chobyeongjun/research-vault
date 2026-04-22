---
tags: [hardware, jetson, nvidia, computing, exosuit]
updated: 2026-04-13
---

# Jetson Orin NX — 추천 컴퓨팅 플랫폼

제조사: **NVIDIA** | 외골격 프로젝트 추천 모델: **Orin NX 16GB**

---

## 라인업 비교

| 모델 | AI 성능 | RAM | 전력 | 가격(모듈) | ZED X Mini |
|------|--------|-----|------|----------|-----------|
| Orin Nano 4GB | 20~40 TOPS | 4GB | 7~10W | ~$199 | ○ (ZED Link) |
| Orin Nano 8GB | 40~67 TOPS | 8GB | 10~25W | ~$299 | ○ (ZED Link) |
| **Orin NX 8GB** | 70~117 TOPS | 8GB | 10~25W | ~$399 | ○ (ZED Link) |
| **Orin NX 16GB** | 100~157 TOPS | 16GB | 10~40W | ~$599 | ○ (ZED Link) |
| AGX Orin 32GB | 200~275 TOPS | 32GB | 15~60W | ~$999+ | ○ (네이티브 or ZED Link) |

---

## 추천: Orin NX 16GB

**이유:**

| 항목 | 근거 |
|------|------|
| 157 TOPS | 실시간 포즈 추정 + 보행 ML 동시 처리 가능 |
| 16GB LPDDR5 | ZED Body Tracking + 제어 로직 동시 실행 충분 |
| 10~40W | 48V 배터리에서 운용 가능 (~20~25W 실사용) |
| PCIe x4 | **ZED Link Duo 카드 장착 가능** |
| 모듈 크기 | 69.6 × 45 mm / 158g → 외골격 탑재 적합 |

---

## 시스템 역할

```
Jetson Orin NX 16GB
├── ZED X Mini (GMSL2 → ZED Link → PCIe)
│   ├── 깊이 추정 (실시간)
│   ├── Body Tracking (보행자 자세)
│   └── SLAM (위치 추정)
├── STM32H743 (UART / USB)
│   ├── 상위 레벨 명령 (속도/토크 목표)
│   └── 센서 데이터 수신 (로드셀, 상태)
├── EBIMU V5 수신기 (USB VCP)
│   └── 관절 각도 (Quaternion)
└── Elmo CANopen 마스터 (optional: 직접 CAN)
    └── 또는 STM32가 CANopen 마스터 역할
```

---

## 전원 요구사항

| 항목 | 스펙 |
|------|------|
| 입력 전압 | 5V (일부 캐리어 보드) / 9~20V (대부분) |
| 소비 전력 | 10~40W (로드 의존) |
| ZED Link Duo 포함 | ~20~25W 예상 |
| 48V 배터리 → Jetson | DC/DC 컨버터 필요 (48V → 12V 또는 19V) |

---

## 소프트웨어 스택

```
Ubuntu 22.04 (JetPack 6.x)
├── ZED SDK v4+ (ZED X Mini 지원)
├── ROS 2 Humble
│   ├── zed-ros2-wrapper (Stereolabs 공식)
│   └── STM32 통신 노드 (UART/USB)
├── PyTorch / TensorRT (보행 ML)
└── CANopenNode (Elmo 직접 제어 시)
```

---

## ZED X Mini 연동 세팅

```bash
# JetPack 설치 후
sudo apt install zed-sdk
# ZED Link 드라이버 설치
sudo apt install zed-link-driver
# 카메라 확인
ZED_Explorer
```

---

## 관련 노트

- [[zed-x-mini]] - 연동 카메라
- [[elmo-gold-twitter]] - 모터 드라이버
- [[h-walker]] - 프로젝트
