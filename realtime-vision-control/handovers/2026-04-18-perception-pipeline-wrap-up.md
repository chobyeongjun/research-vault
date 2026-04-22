# 인수인계서 — 2026-04-17 (작성 2026-04-18)

> Perception Pipeline 최적화 심화 + Method B + Teensy end-to-end 검증 + GUI-off 실패

## 오늘의 성과 요약

**PipelinedCamera 재설계 (fetch 0ms)**, **Method B IMU World Frame 채택**, **Teensy end-to-end 연결 확인**, **Python Peak Latency 방어 적용**, **치명적 교훈: GDM-off는 GMSL 카메라 파괴**.

## 최종 성능

### pipeline_main.py (Method B, Python only)
```
python3 pipeline_main.py --no-display --method B

[PROFILE] 200f avg (13.7~14.7ms/frame = 70~73Hz):
  fetch      0.0ms   ← PipelinedCamera RGB/depth 분리
  predict    12.8~13.8ms
  depth_3d   0.3ms
  shm        0.5ms
  [e2e lat]  13.8±1.8ms (max 22ms)
```

### pipeline_main.py + C++ hw_control_loop 동시
```
67~70Hz (C++ 동시 실행 시 CPU 경합으로 -3Hz)
SLOW frame 빈도 증가 (predict 20-28ms 간헐 spike)
```

### 뼈 길이 안정성 (Static)
```
L_thigh 0.302~0.400m ± 4-6mm   (세션별 편차 큼 — 자세/위치 영향)
L_shank 0.413m      ± 6mm
R_thigh 0.328~0.409m ± 4-5mm
R_shank 0.415m      ± 5mm
[sym] thigh |L-R| 1-3cm (정자세)
      shank |L-R| 0.2~2.5cm
```

---

## 현재 데이터 흐름

```
ZED X Mini (SVGA 960×600 @120fps, PERFORMANCE depth)
  │
  ↓ [PipelinedCamera, 2-stage ready 이벤트]
    Phase 1: grab → get_rgb(BGRA copy) → ready_rgb.set()
    Phase 2: get_depth(copy=True, 2.3MB) → ready_depth.set()
    Phase 3: (skip_imu=True) — Method B도 static R 사용
  │
  ↓ [Main: get_rgb → release 즉시]
    capture가 다음 grab 시작 ∥ main predict 병렬
  │
  ↓ [DirectTRT YOLO26s-lower6-v2-640.direct.engine]
    torch GPU BGRA→RGB+resize+normalize+letterbox
    execute_async_v3
    GPU output argmax → top-1 18개만 CPU
  │
  ↓ [Main: get_depth_and_gravity → batch_2d_to_3d (C++ pybind11)]
    6 keypoints × 7×7 patch median depth
    3D EMA α=0.8 (C++ 내부)
  │
  ↓ [Method B: R @ positions → world frame]
    static R (IMU warmup 20f 평균 quaternion)
    _compute_angles_world → FlexionAngles (raw, neutral 미설정)
  │
  ↓ [SHM /hwalker_pose, 36 bytes]
  │
  ↓ [C++ main_control_loop @100Hz clock_nanosleep]
    SHM stale watchdog 0.2s → pretension 5N fallback ✅
    Impedance + ILC (off)
    SerialComm → /dev/ttyACM0
  │
  ↓ [Teensy 4.1 @111Hz]
    USB CDC → 모터 명령 (오늘은 5N pretension만)
```

---

## 실행 방법

### 정상 세팅 (Method B)
```bash
# 부팅마다 필수
sudo jetson_clocks

# 터미널 1
cd ~/h-walker-ws/src/hw_perception/realtime
python3 pipeline_main.py --no-display --method B

# 터미널 2 (CPU 6-7 전용 + RT priority)
cd ~/h-walker-ws/src/hw_control/cpp
sudo chrt -r 50 taskset -c 6,7 ./build/hw_control_loop /dev/ttyACM0
```

### CLI 옵션
```
--method A         # Standing Calibration (knee_flexion zero-ref)
--method B         # IMU World Frame (중력 기준 회전, 추천)
--depth-mode PERFORMANCE  # 기본. NEURAL_LIGHT/NEURAL 기각
--no-display       # 실험 시 필수 (display=74→42Hz)
```

---

## 성공한 개선 (오늘, 2026-04-17)

| # | 개선 | Before | After | 효과 |
|---|------|--------|-------|------|
| 1 | **PipelinedCamera ready_rgb/ready_depth 분리** | fetch 7ms | fetch 0ms | release 즉시 → grab과 predict 완벽 병렬 |
| 2 | **depth copy=True 강제** | race condition → state.valid=False | 정상 | 캘리브 통과, 캡처→메인 동기화 안전 |
| 3 | **Method B IMU World Frame** | 카메라 기준 좌표 | **World frame** | 카메라 32° 기울기 감지, 중력 기준 |
| 4 | **skip_imu=True 양쪽** | Method B 매 프레임 IMU 1ms | 0ms | static R 사용 (카메라 고정 가정) |
| 5 | **Sagittal view (world frame)** | 없음 | Y-Z 측면뷰 | display 검증용 (실험 중은 off) |
| 6 | **Python GC disable + gen-0 500f** | 자동 GC spike 2-5ms | 0.3ms 예측 가능 | spike 감소 |
| 7 | **CPU affinity Python 2-5, C++ 6-7** | cores 공유 | 완전 분리 | context switch ↓ |
| 8 | **개별 frame SLOW warning (>20ms)** | 200f 평균만 | per-frame 진단 | 원인 추적 용이 |
| 9 | **Bone length 통계 로깅** (mean±std, min~max) | 1샘플 | 200f ring buffer | 정확도 기준선 확립 |
| 10 | **e2e latency 로깅** | 없음 | capture→SHM ms | 제어 관점 지연 측정 |
| 11 | **--depth-mode CLI 옵션** | hardcoded | 런타임 선택 | 실험 편의 |
| 12 | **jetson_clocks 효과 검증** | GPU idle 306MHz | 918MHz 고정 | GR3D 11%→85% |

---

## 실패 + 원인 기록

### F1. NEURAL depth mode 채택 시도 → **기각**
- **목적**: 3D 정확도 향상
- **결과**: 29Hz (74Hz 대비 **60% 감소**), predict 30.4ms (x2.4)
- **원인**: NEURAL은 depth 계산을 GPU 신경망으로 수행 → TRT YOLO와 SM 경합
- **정확도 이득**: thigh/shank 차이 ≤3cm (노이즈 수준)
- **교훈**: **PERFORMANCE가 최적**. ZED SDK "deprecated" 경고 무시 가능
- **NEURAL_LIGHT**: 52Hz로 중간 타협, 여전히 PERFORMANCE 대비 30% 손실 → 기각

### F2. Display ON (sagittal view 실험 중) → **개발 전용**
- **결과**: 74Hz → **42Hz** (43% 감소)
- **원인**: `cv2.imshow`+`waitKey(1)` main 블록, X11 렌더, GPU 경합
- **사용**: 디버깅/검증만. 실험은 반드시 `--no-display`

### F3. release() 프레임 끝으로 이동 (초기 잘못된 설계) → **수정 완료**
- **증상**: fetch 7ms 그대로
- **원인**: capture가 main shm 끝까지 대기
- **수정**: release를 `get_rgb()` 직후로 이동 → fetch 0ms

### F4. depth view(copy=False) race → **수정 완료 (copy=True)**
- **증상**: 캘리브 0% 고착, state.valid=False 연속
- **원인**: release 즉시 호출 시 capture가 ZED 내부 버퍼를 N+1로 overwrite → main view가 partial data
- **수정**: capture에서 `get_depth(copy=True)` 강제 (0.5ms 오버헤드)
- **교훈**: 파이프라인 병렬화 + 공유 버퍼 = 복사 필수

### F5. 🚨 **GDM(GUI) 끄기** → **치명적 실패 (절대 재시도 금지)**
- **목적**: X11 compositor + nvpmodel_indicator 40개 제거
- **결과**: ZED 카메라 초기화 **segfault**
  ```
  nvbufsurface: Failed to create EGLImage  (x10)
  (Argus) Error BadParameter
  Segmentation fault (core dumped)
  ```
- **원인**: **ZED X Mini는 GMSL2/CSI 카메라 → NVIDIA Argus 프레임워크 → EGL 컨텍스트 필요 → EGL은 X server에서 공급**
  - USB 카메라 (V4L2)는 GUI 무관
  - **GMSL/CSI는 X server 필수**
- **부작용**: GDM 복구해도 Argus daemon 내부 state 깨짐 → `NvPclStartPlatformDrivers Failed` → **리부팅 강제**
- **영구 교훈**: **Jetson + GMSL/CSI 카메라 = GDM 절대 끄지 말 것**

### F6. CUDA stream 분리 → **시도 안 함**
- **원인**: ZED SDK가 stream 파라미터 미노출, 내부 default stream 강제
- **효과 한계**: Orin NX GPU SM 8개 → 실질 병렬 미지원
- **대안**: depth retrieve를 main 스레드로 이동 (순차 직렬화) — 내일 작업

### F7. C++ loop rate 100→60Hz → **기각**
- **분석**: C++ CPU 3% 이하, GPU 미사용 → 낮춰도 효과 없음
- **ILC/impedance**: 100Hz가 50Hz bandwidth, 보행 분석 표준

### F8. C++ control loop 동시 실행 시 predict spike (20-28ms) → **부분 해결**
- **원인 추정**: GPU scheduling 경합 (ZED + TRT) + CPU cache pollution
- **적용**: CPU isolation (Python 2-5, C++ 6-7) → 빈도 감소
- **미해결**: 근본 해결은 depth 직렬화 or CUDA stream (내일)

### F9. Method B knee_err 좌우 비대칭 → ⚠️ **내일 확인 필수**
- **증상**: C++ 쪽에서 `knee_err=[-175.4, -152.6]` (23° 차이)
- **Python 쪽**: `[sym] thigh |L-R|=1cm` 대칭
- **원인 추정**: Method B `neutral` 미설정 → raw 각도 전송, C++ reference 해석 불일치
- **리스크**: 이 상태에서 ILC on 하면 왼다리만 176° 움직이려 함 → 실험 위험

### F10. Python 종료 시 SHM half-write
- **증상**: `knee_err=[-170.6, 24.0]` 순간 점프 직후 SHM 멈춤
- **원인**: Python write atomic 보장 없음 → C++이 중간 상태 읽음
- **방어**: **C++ SHM watchdog 0.2s fallback → pretension 이미 작동** ✅
- **개선(내일)**: SHM publisher에 sequence lock 추가

### F11. 과거 실패 재확인
- **One Euro Filter** (모든 variant): Joints 0/6 → **영구 기각**
- **SegmentLengthConstraint on 2D** (2026-04-15): 피드백 루프 → 왼쪽 keypoint 고착 → 2D는 기각, **3D만 static ref 검증 후 내일 시도 가능**
- **imgsz 480**: 사용자 영구 거부 (640 유지)
- **cv2.cuda**: JetPack OpenCV CUDA 미빌드
- **zero-copy (copy=False)**: 이번에도 확인 — race 유발

---

## Teensy 연결 상태

### 완료 ✅
- Python → SHM `/hwalker_pose` publish
- C++ SHM 읽기 + 값 정상 수신
- C++ `SerialComm` → `/dev/ttyACM0` 통신
- Teensy 펌웨어 정상 동작 (2026-04-15 기록 유지)
- **C++ SHM watchdog 0.2s → pretension 5N fallback** (Python 죽을 때 실제 작동 확인)
- `F_total=[5.0, 5.0]N` pretension 안전 유지, ILC off 상태

### 미완료 ⏸
- Method B knee_err 좌우 비대칭 원인 규명
- 실제 모터 enable 테스트 (케이블 장력 0 상태)
- Bone length constraint 적용 후 각도 안정성 검증
- 장시간 (10분+) 연속 구동 안정성

---

## 내일 할 것 (우선순위)

### P0
1. **Method B knee_err 좌우 비대칭 원인 진단** — 실험 안전 직결
2. **depth retrieve 직렬화** (main 스레드로 이동) — predict spike 제거
3. **Bone length constraint (3D only)** — static ref 기반 outlier 제거

### P1
4. **SHM atomic write** (sequence lock) — half-write 방지
5. **Method B에 set_standing_neutral 자동 호출** 또는 Method A+B 하이브리드

### P2
6. **Headless Xorg** (GUI 없이 EGL 제공) — 장기 실험용
7. **CUDA stream 분리** — ZED/TRT GPU 격리 (하루 작업)

---

## 영구 교훈 (skiro-learnings)

1. **Jetson + GMSL/CSI 카메라: GDM 절대 끄지 말 것** (Argus/EGL 필수, 끄면 segfault + 드라이버 락업)
2. **NEURAL depth mode는 TRT 동시 환경에서 불가** (GPU SM 경합)
3. **ZED depth view(copy=False)는 파이프라인 병렬에서 race** — 항상 copy=True
4. **Python sagittal display는 실험 중 FPS 반토막** — 개발 전용
5. **One Euro Filter는 YOLO26s-lower6에 불가** (0/6 joints)
6. **segment constraint는 static ref std ≤10mm 검증 후에만** (과거 피드백 루프 주의)
7. **C++ loop rate 낮추기는 성능 개선 아님** (CPU 3%, GPU 미사용)
8. **jetson_clocks는 부팅마다 재적용 필요** (persistent 아님)
9. **Method B는 카메라 고정 시 static R 사용, skip_imu=True** (runtime IMU 불필요)
10. **release 즉시 호출(get_rgb 직후)이 파이프라인 핵심** — 프레임 끝 release는 역효과

---

## 주요 파일 위치 (오늘 수정/확인)

### Python
```
src/hw_perception/realtime/
  pipeline_main.py           ★ 메인 루프, new API 적용
  calibration.py             Method A/B (B의 set_standing_neutral 미호출 — 내일 확인)
  joint_3d.py                JointState3D, compute_joint_state
  shm_publisher.py           ★ atomic write 미적용 (내일 개선 포인트)
  safety_guard.py

src/hw_perception/benchmarks/
  zed_camera.py              ★ PipelinedCamera 재설계 (ready_rgb/ready_depth 분리)
  postprocess_accel.py       ★ C++ batch_2d_to_3d + EMA
  trt_pose_engine.py         DirectTRT
```

### C++
```
src/hw_control/cpp/
  src/main_control_loop.cpp  ★ SHM watchdog 작동 확인
  build/hw_control_loop      실행 바이너리
```

---

## 관련 커밋 (2026-04-17)

```
c14f9298 perf: CPU isolation Python cores 2-5, C++ 6-7
821639ee feat: sagittal view world frame (Method B IMU 회전 적용)
e164ab9d perf: Python peak latency 방어 (GC off + CPU affinity + slow warn)
13858be1 fix: Method B IMU 초기화 + skip_imu=True 양쪽 모두
52a3a102 perf: revert depth_mode default to PERFORMANCE + 기준선 로깅 강화
8f873685 fix: depth race condition - capture에서 copy=True 강제
92dcffaf perf: split ready_rgb/ready_depth, release immediately after get_rgb
```

브랜치: `control`

---

*작성: 2026-04-18 (전날 작업 기록)*
*다음 날: knee_err 비대칭 + depth 직렬화 + bone constraint 순서로*
