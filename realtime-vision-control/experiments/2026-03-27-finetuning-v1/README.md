---
title: 하체 6kpt Fine-Tuning v1 (YOLO26s-lower6)
date: 2026-03-27
project: realtime-vision-control
status: completed
tier: verified
tags: [experiment, finetuning, yolo26s]
---

# 하체 6kpt Fine-Tuning v1

## 환경
- 학습: RTX 5090, batch=-1 (AutoBatch), epochs=500, patience=50
- 배포: Jetson Orin NX 16GB

## 학습 결과
- Best epoch: 302/352 (EarlyStopping)
- Pose mAP50: **88.5%**
- Pose mAP50-95: **77.7%**
- 학습 시간: 25.8시간

## Jetson 실측 비교

| 항목 | YOLO26s 17kpt | YOLO26s-lower6 6kpt | 개선 |
|------|--------------|-------------------|------|
| 추론 속도 | 44ms | **18ms** | **2.4배** |
| 인식률 | 100% | 100% | 동일 |
| Confidence | 0.97 | **0.99** | 향상 |

## 설계 근거
- heel/toe → IMU 담당 → 비전은 hip/knee/ankle 6kpt 집중
- capacity 집중으로 속도 2.4배 + 정확도 향상
- YOLO26s-pose pretrained backbone 재사용, Pose Head만 재초기화

## 모델 파일
- `models/yolo26s-lower6.pt`
- `models/yolo26s-lower6.onnx`
