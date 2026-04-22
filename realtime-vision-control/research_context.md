---
title: realtime-vision-control — Research Context
project: realtime-vision-control
created: 2026-04-22
updated: 2026-04-22
tags: [research-context, perception, cuda-stream]
note: 이 파일은 meeting-ppt / research-paper 스킬이 자동으로 읽음
---

# H-Walker — Realtime Vision Control 연구 컨텍스트

## 연구 제목
**Vision-Based Real-Time Impedance Control for Cable-Driven Gait Rehabilitation**

## 연구 목표
1. ZED 카메라 + YOLO26s-lower6 TRT 파이프라인으로 실시간 하체 자세 인식 (Jetson Orin NX)
2. 20 ms HARD LIMIT 보장으로 stale keypoint의 모터 도달 차단
3. 임피던스 제어 + ILC + (장기) RL sim-to-real 로 cable force 제어
4. Treadmill / Overground 환경 실험 검증

## 두 논문 trajectory

### Paper 1 — Vision-Based Impedance Control (RA-L target, 15% complete)
**Contributions (draft)**:
1. ZED+YOLO26s-lower6 TRT 파이프라인으로 Jetson Orin NX **14 ms / 73-86 Hz** 달성 (4/18 baseline 73Hz, 4/21 stable 86Hz)
2. **Method B IMU World Frame** — 카메라 자유 배치, 중력 기준 sagittal
3. **20 ms HARD LIMIT frame-skip pattern** — `valid=False`로 publish → C++ control loop가 skip → stale keypoint 모터 도달 차단 (300s 측정 위반율 0.000% — 4/21 stable)
4. **POSIX SHM seqlock + 7-layer safety chain** (Python valid → SHM → C++ skip → stale fallback → 5중 force clamp → estop sentinel)

**Status**:
- ✅ Pipeline 14 ms / 86 Hz reproducible
- ✅ 7-layer safety chain 활성
- ✅ Bone length + Joint velocity constraint 적용
- ⏳ 실제 환자 실험 미실시 (pretension 5N 까지만)
- ⏳ Method B knee_err 좌우 비대칭 검증 미완

### Paper 2 — RL Sim-to-Real Policy (TBD venue, planning)
- Sim env 후보: MuJoCo / Isaac Gym / Genesis
- Observation: Paper 1의 6 keypoint + cable tension feedback
- Reward shaping: gait-cycle reference + force smoothness
- **Safety layer = Paper 1의 7-layer chain 재사용** (이게 Paper 2 가능하게 하는 전제)

## 시스템 한 줄 모델

```
ZED 120Hz → Jetson Python 70-86Hz (CUDA 4-stream)
           → SHM /hwalker_pose_cuda (valid bit, seqlock)
             → C++ 100Hz (5층 안전)
               → Teensy 111Hz (USB serial)
                 → AK60 motor (CAN, max 70N cable force)
                   → 케이블 → 사용자 다리
```

각 단계 frequency 다른 이유 (decoupled, 의도적):
- ZED 120Hz: 카메라 native, 모든 frame 사용 안 해도 OK
- Python 70-86Hz: TRT inference + post-processing 한계 (~14 ms)
- C++ 100Hz: clock_nanosleep RT, motor 응답 50Hz bandwidth × 2 (Nyquist)
- Teensy 111Hz: firmware 권장 inner motor torque loop rate
- 모두 **async**: 한쪽 늦어도 다른 쪽 안 멈춤

## 현재 stable baseline (2026-04-21, tag `v0.1.0-cuda-stream-stable`)

| Metric | 값 | 비교 (4/18 baseline) |
|---|---|---|
| Throughput | **77.4 Hz** (viewer 켠 상태), 단독 86 Hz | 73 Hz (+5%) |
| e2e p50 | 8.02 ms | 13.8 ms |
| **e2e p99** | **14.46 ms** | 19.8 ms (-27%) |
| Max | 19.07 ms | ~22 ms |
| **HARD LIMIT 위반** | **0.000%** (180s, 13872 frames) | 0.031% |
| Reproducibility | ✅ 매 run 같은 결과 | 단발 측정 |

## 시스템 구성 (정확)

| 구성요소 | 정확한 값 |
|---|---|
| 로봇 | H-Walker (cable-driven gait rehabilitation walker) |
| 환경 | Treadmill / Overground (둘 다) |
| 액추에이터 | AK60 motor (CAN bus), max cable force 70N |
| MCU | Teensy 4.1 (111 Hz inner loop) |
| Edge SBC | Jetson Orin NX 16GB (JetPack 6.x, MAXN, jetson_clocks) |
| 카메라 | ZED X Mini (GMSL2, SVGA 960×600 @120fps, Global Shutter, IMU 내장) |
| Depth | PERFORMANCE mode (NEURAL은 GPU SM 경합으로 영구 기각) |
| 모델 | yolo26s-lower6-v2 (TRT FP16, imgsz=640, 6 keypoints L/R hip/knee/ankle) |

## 제어 방법론

| 단계 | 방법 |
|---|---|
| **현재** | Pretension 5N (단순 hold) — Paper 1 measurement용 |
| Paper 1 | Impedance control (force = K(x_des - x) + D(v_des - v)) |
| Paper 1 발전 | + ILC (Iterative Learning Control) — gait phase 따라 force profile 학습 |
| Paper 2 | RL policy (sim-to-real) — observation = pose + tension, action = cable force |

## 7-Layer 안전 chain (활성, 4/21 stable 기준)

1. **Python**: e2e > 20 ms 감지 → `valid=False` publish
2. **gpu_postprocess**: bone length constraint → outlier reject
3. **gpu_postprocess**: joint velocity bound (8 m/s) → teleportation reject
4. **gpu_postprocess**: sticky publish (max 5 frames ≈ 60 ms) → 짧은 detection 손실 흡수
5. **C++**: SHM stale 0.2s → pretension 5N fallback
6. **C++**: 5중 force clamp → max 70 N (AK60 한계)
7. **C++/watchdog**: estop sentinel `/dev/shm/hwalker_pose_cuda_estop` → 즉시 0 N

## 절대 다시 시도하지 말 것 (영구 기각, 17개)

자세한 내용: [`docs/full-journey-summary.md`](docs/full-journey-summary.md) 마지막 표.

**핵심 카테고리**:
- 2D keypoint smoothing (One Euro, EMA) → depth NaN
- `copy=False` depth → race
- GDM (X server) 끄기 → GMSL/CSI 죽음
- NEURAL depth → GPU SM 경합
- imgsz 480 → 사용자 거부
- sagittal display + pipeline 같은 process → FPS 반토막
- Python에서 Teensy 직접 송신 → 안전 chain 우회
- EMA로 outlier 차단 → EMA는 smoothing이지 outlier reject 아님

## 다음 작업 후보 (4/22~)

1. **C++ control + Teensy 실제 통합 검증** ⭐ 1순위
2. 장시간 (10분+) thermal drift 측정
3. 실제 모터 구동 테스트 (pretension → impedance, ILC off로 시작)
4. Sagittal viewer X-axis 자동 정렬 검증

## 관련 wiki / 노트

- [[perception-evolution-master]] — 전체 여정 마스터 (vault `10_Wiki/`)
- [[realtime-pose-estimation]] — 포즈 추정 wiki
- [[gait-analysis]] — 보행 분석
- [[admittance-control]] — 임피던스/어드미턴스
- [[cable-driven-mechanism]] — 케이블 드리븐
- [[ak60-motor]] — AK60 spec
- [[zed-x-mini]] — ZED 카메라
- [[jetson-orin-nx]] — Edge SBC
- [[teensy-4-1]] — MCU

## 관련 프로젝트

- [[assistive-vector-treadmill/research_context]] — H-Walker treadmill assistive force vector 연구 (별도)

---

*Last updated: 2026-04-22 — vault 통합 및 stable baseline 반영*
