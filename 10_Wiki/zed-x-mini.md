---
tags: [hardware, camera, stereo, depth, jetson, exosuit]
updated: 2026-04-13
---

# ZED X Mini — 스테레오 카메라

제조사: **Stereolabs** | stereolabs.com  
인터페이스: **GMSL2** (Power over Coax)

---

## 핵심 스펙

| 항목 | 스펙 |
|------|------|
| 센서 | 듀얼 1/2.8" 글로벌 셔터 컬러 |
| 해상도 | 1920 × 1200 (2MP per eye) |
| 프레임레이트 | 최대 **120 FPS** (해상도별 조정) |
| 깊이 범위 | **0.1~8m** (2.2mm 렌즈) / 0.15~12m (4mm 렌즈) |
| 베이스라인 | 50 mm |
| AI 엔진 | Neural Depth Engine 2 내장 |
| 인터페이스 | **GMSL2** (Fakra 커넥터, PoC) |
| 케이블 길이 | 최대 15m |
| 방수방진 | **IP67** |
| 크기 | 94 × 32 × 37 mm |
| 무게 | **~150g** |
| 소비 전력 | ~2~3W (카메라 자체) |

---

## Jetson 연동 방법

```
ZED X Mini
  → Fakra 케이블 (최대 15m)
  → ZED Link Duo 캡처 카드 (PCIe x4)
  → Jetson 캐리어 보드
  → ZED SDK v4+ / JetPack 5.1.1 이상
  → ROS 2 Humble
```

> ⚠️ **ZED Link 캡처 카드 필수** — Jetson Orin NX에는 네이티브 GMSL2 포트 없음  
> AGX Orin은 일부 캐리어 보드에 GMSL2 내장

---

## 외골격 착용 시 주의사항

- GMSL2 케이블이 유연하지 않음 → **케이블 라우팅 설계 필요**
- IP67 방수 → 땀/환경 노출 OK
- ZED Link 캡처 카드는 별도 방진 처리 필요
- 카메라 마운트: **진동 흡수 마운트** 권장
- 글로벌 셔터 → 모션 블러 없음 (보행 중 안정적)

---

## ZED SDK 기능 (관련)

- Depth estimation (실시간)
- Body tracking / Skeleton (17~34 keypoint)
- Object detection
- Positional tracking / SLAM

→ 보행 분석, 사용자 의도 추정에 직접 활용 가능

---

## 관련 노트

- [[jetson-orin-nx]] - 연동 컴퓨팅 플랫폼
- [[h-walker]] - 프로젝트
