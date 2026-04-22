---
title: realtime-vision-control
created: 2026-04-21
updated: 2026-04-21
tags: [project, perception, cuda-stream, h-walker]
status: stable v0.1.0-cuda-stream-stable
---

# realtime-vision-control

H-Walker용 실시간 카메라 포즈 인식 + 제어 시스템. 이 노트는 **포인터 + 현재 상태 요약**.
코드 자체는 GitHub + Mac + Jetson local에 있음 (vault에 mirror하지 않음).

## 한 줄 요약 (2026-04-21 기준)
**77.4 Hz / e2e p99 14.46 ms / HARD LIMIT 위반 0.000% (180s, 13872 frames).**
4/18 baseline (73Hz / p99 19.8 / 0.031%) 모든 면에서 능가. 매 run reproducible.

## 코드 위치 (single source of truth)
| 위치 | 용도 |
|---|---|
| **GitHub** | `https://github.com/chobyeongjun/realtime-vision-control` (정본) |
| Mac | `~/realtime-vision-control/` (작업 + backup) |
| Jetson | `~/realtime-vision-control/` (실행 + backup) |
| Vault | (코드 X — pointer만) |

## 현재 release
**`v0.1.0-cuda-stream-stable`** — `git checkout v0.1.0-cuda-stream-stable` 로 정확한 시점 복구.

## 핵심 문서 (GitHub의 docs/)
1. [`docs/evolution/full-journey-summary.md`](https://github.com/chobyeongjun/realtime-vision-control/blob/main/docs/evolution/full-journey-summary.md) — **전체 여정 + 잘된 것/안된 것 종합**
2. [`docs/evolution/perception-evolution.md`](https://github.com/chobyeongjun/realtime-vision-control/blob/main/docs/evolution/perception-evolution.md) — Master 정리
3. [`docs/evolution/why-it-got-faster.md`](https://github.com/chobyeongjun/realtime-vision-control/blob/main/docs/evolution/why-it-got-faster.md) — 22 최적화 원리
4. [`docs/evolution/cuda-stream-architecture.md`](https://github.com/chobyeongjun/realtime-vision-control/blob/main/docs/evolution/cuda-stream-architecture.md) — Track B 4-stream 설계
5. [`docs/experiments/2026-04-21-stable-baseline.md`](https://github.com/chobyeongjun/realtime-vision-control/blob/main/docs/experiments/2026-04-21-stable-baseline.md) — 현재 baseline
6. [`CHANGELOG.md`](https://github.com/chobyeongjun/realtime-vision-control/blob/main/CHANGELOG.md) — v0.1.0 milestone

## 현재 활성 안전 chain (7 layers)
1. Python e2e > 20ms → `valid=False` publish
2. Bone length constraint → outlier reject
3. Joint velocity bound (8 m/s) → teleportation reject
4. Sticky publish (max 5 frames ≈ 60ms)
5. C++ watchdog 0.2s → SHM stale → pretension 5N
6. C++ 5중 force clamp → max 70N (AK60)
7. Estop sentinel → watchdog unhealthy 시 즉시 0N

## 절대 시도 금지 (영구)
17개 항목 — `docs/evolution/full-journey-summary.md` 마지막 표 참조. 핵심:
- One Euro / EMA / smoothing on **2D keypoints** (depth NaN)
- `copy=False` depth (race)
- GDM (X server) 끄기 (GMSL/CSI 죽음)
- NEURAL depth (GPU SM 경합)
- imgsz 480 (사용자 거부)
- `sagittal display + pipeline` 같은 process (FPS 반토막)
- Python에서 Teensy 직접 송신 (안전 chain 우회)
- EMA로 outlier 차단 (EMA는 smoothing — outlier는 bone/velocity constraint)

## 다음 작업 (roadmap)
1. **C++ control + Teensy 실제 통합 검증** — SHM 50Hz 송신 + force command 도달
2. 장시간 (10분+) thermal drift
3. 실제 모터 구동 테스트 (pretension → impedance, ILC off로 시작)
4. Sagittal viewer X-axis 자동 정렬 검증

## Related
- **프로젝트 폴더 (이 노트의 진짜 본문)**: [[realtime-vision-control/README]]
  - `~/research-vault/realtime-vision-control/` 안에 docs + experiments + handovers + meetings + papers
- 연구 주제 컨텍스트: [[realtime-vision-control/research_context]]
- 관련 레포: `h-walker-ws` (private — C++ control + Teensy firmware)
- 최근 handover: [[2026-04-21-handover]]
- 마스터 정리: [[perception-evolution-master]]
