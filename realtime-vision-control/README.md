---
title: realtime-vision-control
project: realtime-vision-control
status: stable v0.1.0-cuda-stream-stable
updated: 2026-04-22
tags: [project, perception, cuda-stream, h-walker, second-brain]
---

# realtime-vision-control — Second Brain 인덱스

H-Walker용 실시간 카메라 포즈 인식 + 제어 시스템. 이 폴더는 **vault 안의 프로젝트 허브**.
코드는 GitHub + Mac + Jetson local에 있고, 여기엔 docs/notes만.

## 한 줄 요약 (2026-04-21 기준)
**77.4 Hz / e2e p99 14.46 ms / HARD LIMIT 위반 0.000% (180s, 13872 frames).**
→ tag `v0.1.0-cuda-stream-stable`

## 폴더 구조

| 폴더 | 내용 |
|---|---|
| `docs/` | 마스터 정리 4편 (전체 여정 / 최적화 원리 / Track B 아키텍처 / phase summary) |
| `experiments/` | 날짜별 실험 메타 + 측정 수치 JSON |
| `handovers/` | 세션별 인수인계 (4/15 ~ 4/21) |
| `meetings/` | 격주 교수님 미팅 자료 (예정) |
| `papers/` | 논문 outline (예정 — Paper 1 RA-L, Paper 2 RL) |

## 시작하기 — 이 프로젝트 0부터 이해하려면 5분 순서

1. **이 README** (지금 보는 것) — 1분, 전체 인덱스
2. [`docs/full-journey-summary.md`](docs/full-journey-summary.md) — 7 phase + 잘된 것/안된 것 + 영구 기각 17개 (3분)
3. [`experiments/2026-04-21-stable-baseline.md`](experiments/2026-04-21-stable-baseline.md) — 현재 baseline 측정 (1분)

이후 깊이 필요 시:
- [`docs/perception-evolution.md`](docs/perception-evolution.md) — Master (전체 여정 상세)
- [`docs/why-it-got-faster.md`](docs/why-it-got-faster.md) — 22 최적화 원리 (6 카테고리)
- [`docs/cuda-stream-architecture.md`](docs/cuda-stream-architecture.md) — Track B 4-stream 설계
- [`handovers/2026-04-21-handover.md`](handovers/2026-04-21-handover.md) — 가장 최근 세션 요약

## 코드 위치 (vault에는 X)

| | 위치 | 용도 |
|---|---|---|
| **GitHub** | `https://github.com/chobyeongjun/realtime-vision-control` | 정본 |
| Mac | `~/realtime-vision-control/` | 작업 + backup |
| Jetson | `~/realtime-vision-control/` | 실행 + backup |
| **현재 release** | tag `v0.1.0-cuda-stream-stable` | 정확한 시점 복구 가능 |

## 활성 안전 chain (7 layers, 4/21 기준)

1. Python e2e > 20ms → `valid=False` publish
2. Bone length constraint → outlier reject
3. Joint velocity bound (8 m/s) → teleportation reject
4. Sticky publish (max 5 frames ≈ 60ms)
5. C++ watchdog 0.2s → SHM stale → pretension 5N
6. C++ 5중 force clamp → max 70N (AK60)
7. Estop sentinel → watchdog unhealthy 시 즉시 0N

## 절대 다시 시도하지 말 것 (영구 기각, 17개)

`docs/full-journey-summary.md` 마지막 표 참조. 핵심:
- 2D keypoint smoothing (One Euro, EMA)
- `copy=False` depth (race)
- GDM 끄기 (GMSL/CSI 죽음)
- NEURAL depth mode (GPU 경합)
- imgsz 480 (사용자 거부)
- sagittal+pipeline 같은 process (FPS 반토막)
- Python에서 Teensy 직접 송신 (안전 chain 우회)
- EMA로 outlier 차단 (EMA는 smoothing — outlier는 bone/velocity constraint)
- Vault에 코드 mirror (vault는 docs용)

## 다음 작업 후보 (4/22~)

1. **C++ control + Teensy 실제 통합 검증** ⭐ 1순위
   - launch_clean.sh로 perception → SHM /hwalker_pose_cuda
   - 다른 터미널 `~/h-walker-ws/.../hw_control_loop /dev/ttyACM0`
   - F_total 정상 + Teensy 도달
2. 장시간 (10분+) thermal drift 측정
3. 실제 모터 구동 테스트 (pretension → impedance, ILC off)
4. Sagittal viewer X-axis 자동 정렬 검증

## 환경 (변경 시 baseline 흔들림)
- Jetson Orin NX 16GB, JetPack 6.x, MAXN, jetson_clocks
- ZED X Mini SVGA 960×600 @120fps PERFORMANCE depth
- TRT 10.3 (engine은 이 환경에서 빌드된 것 — 다른 Jetson에 못 옮김)
- Python 3.10, torch 2.10
- 모델: yolo26s-lower6-v2 (TRT FP16 imgsz=640)

## 관련 vault 노트

- [[realtime-vision-control]] — `10_Wiki/realtime-vision-control.md` (한 줄 요약 + 외부 링크)
- [[perception-evolution-master]] — `10_Wiki/perception-evolution-master.md` (전체 여정 마스터)
- [[realtime-pose-estimation]] — `10_Wiki/realtime-pose-estimation.md` (포즈 추정 wiki)
- [[2026-04-21-handover]] — `00_Raw/2026-04-21-handover.md` (handover, 이 폴더에도 사본)
- [[gait-analysis]] — `10_Wiki/gait-analysis.md`
- [[zed-x-mini]] — `10_Wiki/zed-x-mini.md`
- [[jetson-orin-nx]] — `10_Wiki/jetson-orin-nx.md`
- [[admittance-control]] — `10_Wiki/admittance-control.md`

## Related projects

- [[assistive-vector-treadmill/README|assistive-vector-treadmill]] — H-Walker treadmill 환경 assistive force vector 연구 (별도)

---

*이 인덱스는 vault에서 Obsidian Graph View로 봤을 때 프로젝트 허브 역할. 모든 docs는 이 README에서 link로 도달 가능.*
