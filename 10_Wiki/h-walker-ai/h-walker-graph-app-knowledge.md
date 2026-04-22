---
title: H-Walker Domain Knowledge
updated: 2026-04-17
tags: [h-walker, domain, reference, csv-schema]
summary: H-Walker 시스템 도메인 지식 — CSV 스키마, 신호 규약, 제어 루프 구조.
---

# H-Walker Domain Knowledge

## System
H-Walker: cable-driven walking rehab robot. AK60 motors → cables → leg assistance.
Teensy 4.1 (111Hz inner loop), Jetson (10-30Hz outer loop).

## CSV Schema (H-Walker firmware, 60 cols @ 111Hz)

### Control Signals (suffix meaning):
- `Des*` = Desired (목표값, plot as **dashed**)
- `Act*` = Actual (실제값, plot as **solid**)
- `Err*` = Error (= Act - Des)

### Column Groups:
| Group | Columns | Unit |
|---|---|---|
| Force | L/R_{Des,Act,Err}Force_N | N |
| Velocity | L/R_{Des,Act,Err}Vel_mps | m/s |
| Position | L/R_{Des,Act,Err}Pos_deg | deg |
| Current | L/R_{Des,Act,Err}Curr_A | A |
| IMU angles | L/R_{Roll,Pitch,Yaw} | deg |
| Gyro | L/R_{Gx,Gy,Gz} | deg/s |
| Accel | L/R_{Ax,Ay,Az} | m/s² |
| Displacement | L/R_{Dx,Dy,Dz} | m |
| Gait | L/R_{GCP,Event,Phase} | 0-100%, 0/1, stance/swing |

### GCP (Gait Cycle Percentage):
- L_GCP / R_GCP: independent sawtooth per leg (0→peak during stance, 0 during swing)
- Used for gait-cycle normalization (resample to 101 points)
- Heel strike = start of active segment (GCP > 0.01)

## Korean Lab Terminology (must recognize)
| Korean | English | analysis_type |
|---|---|---|
| 힘/추종/트래킹/케이블 힘 | force tracking | force |
| 속도/프로파일 | velocity | velocity |
| 위치/각도/관절/무릎/hip | position or imu angles | position or imu |
| 전류/토크 | current/torque | current |
| IMU/Roll/Pitch/Yaw | IMU Euler | imu |
| 자이로/각속도 | gyro | gyro |
| 가속도 | acceleration | accel |
| 보행/걸음/걸음걸이/gait | gait analysis | gait (+ normalize_gcp=true) |
| 보행주기/GCP/stride | gait cycle | (+ normalize_gcp=true) |
| 왼쪽/left | left side | sides=[left] |
| 오른쪽/right | right side | sides=[right] |
| 양쪽/둘다/both | both | sides=[both] |
| 비교/compare/overlay | multi-file compare | compare_mode=true |
| 에러/오차/error | error columns | columns=[*Err*] |
| admittance/임피던스 | admittance control | force + normalize_gcp |

## Plot Rendering Rules
- **Des columns → dashed line** (e.g. `L_DesForce_N`)
- **Act columns → solid line** (e.g. `L_ActForce_N`)
- Same signal's Des/Act share color
- L/R in separate subplots when sides=[both] and both L/R present
- X-axis: "GCP (%)" if normalize_gcp else "Sample"

## External CSVs (non-H-Walker)
If CSV headers don't match H-Walker (e.g. `Hip_Moment`, `Vision_Knee_X`):
→ Use `columns` field to specify exact column names from loaded CSV.
User may compare Vision vs MoCap data.

## Normal Ranges (50N assistance, healthy adult)
- Stride time: 0.9-1.2s, Cadence: 100-120 steps/min
- L/R symmetry: <10% normal, >20% significant
- Force RMSE: <5N good, >10N problematic
