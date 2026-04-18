---
title: 12개 모델 E2E 벤치마크 비교
date: 2026-03-24
project: realtime-vision-control
status: completed
tier: verified
tags: [experiment, benchmark, model-comparison]
---

# 12개 모델 E2E 벤치마크

## 환경
- Jetson Orin NX 16GB + ZED X Mini (SVGA@120fps, Global Shutter)
- 측정 시간: 모델당 15초, Depth ON

## 결과

| 모델 | FPS | E2E(ms) | P95 E2E | <50ms% | 인식률 | Conf |
|------|-----|---------|---------|--------|--------|------|
| YOLOv8n-Pose | 27.7 | 35.7 | 38.2 | 100% | 100% | 0.97 |
| YOLOv8s-Pose | 25.1 | 39.5 | 43.4 | 100% | 100% | 0.99 |
| YOLO11s-Pose | 24.5 | 40.4 | 43.2 | 99.7% | 100% | 0.99 |
| YOLO11n-Pose | 23.8 | 41.6 | 44.7 | 100% | 100% | 0.99 |
| YOLO26n-Pose | 22.4 | 44.2 | 46.5 | 100% | 100% | 0.97 |
| YOLO26s-Pose | 22.3 | 44.4 | 47.5 | 99.4% | 100% | 0.99 |
| MediaPipe (c=0) | 15.5 | 63.6 | 71.1 | 0% | 94.4% | 0.77 |
| RTMPose (lw) | 6.6 | 150.5 | 177.7 | 0% | 100% | 0.60 |
| RTMPose Wholebody | 4.1 | 245.6 | 292.4 | 0% | 100% | 0.68 |

## 결론
- **E2E < 50ms 달성**: YOLO 계열 6개만 달성
- **선택**: YOLO26s-Pose (속도 + 정확도 균형, Conf 0.99)
- RTMPose: CUDA EP 미사용으로 CPU fallback → 실용 불가
- MediaPipe: 워커 환경 인식률 94.4% + E2E 63ms → 탈락

## 관련
- [[../../../10_Wiki/admittance-control]]
- [[../../../10_Wiki/ak60-motor]]
