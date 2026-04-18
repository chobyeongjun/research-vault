---
topic: realtime-vision-control
created: 2026-04-18
tags: [topic, perception, control, vision, impedance, rl]
status: active
---

# 실시간 카메라 자세 제어 (Realtime Vision Control)

## 주제 정의
**카메라 기반 실시간 자세 인식 → 3D keypoint → 임피던스/강화학습 제어**
하드웨어 플랫폼은 H-Walker (ZED X Mini + Jetson Orin NX + Teensy 4.1 + AK60).

## 포함 범위
- Perception: ZED camera + YOLO26s-lower6-v2 TRT + Method B IMU world frame
- Pipeline: Python + CUDA_Stream (20ms HARD LIMIT)
- Control: Impedance + ILC (Paper 1), RL policy (Paper 2)
- Integration: Python → POSIX SHM → C++ → Teensy → AK60

## 포함 안 되는 것
- Exosuit (외골격 보드/회생/CAN 안전) → 별도 주제
- H-Walker LLM Graph App → `llm-experiment-analysis` 주제
- Stroke gait 임상 프로토콜 → `clinical-stroke-gait` 주제

## Paper 매핑
| ID | 제목 | 상태 |
|---|---|---|
| `vision-impedance-ral-2026` | Vision-Based Impedance Control for Cable-Driven Gait Rehabilitation | Writing (재료 축적 중) |
| `rl-sim2real-gait` | RL Sim-to-Real Policy for H-Walker Gait Assistance | Planning |

## 실험 인벤토리
- [2026-04-18-cuda-stream](./2026-04-18-cuda-stream/) — CUDA_Stream 3-stage + 20ms HARD LIMIT 보장 (0.031% violation)
- (이전 mainline 개선은 handover로만 존재 → 필요 시 실험 단위로 승격)

## Master Reference
- [[perception-evolution-master]] — 전체 여정 마스터 문서 (`10_Wiki/`)
- [[realtime-pose-estimation]] — 이전 wiki

## 관련 Raw 로그
- `00_Raw/2026-04-15-perception-pipeline-teensy.md`
- `00_Raw/2026-04-18-perception-pipeline-wrap-up.md`
- `00_Raw/2026-04-18-p0-track-completion-report.md`
- `00_Raw/2026-04-19-handover-cuda-stream-perception.md`
