# 인수인계서 - 2026-04-15

> Perception Pipeline 최적화 + Teensy 연결 세션

## 오늘의 성과 요약

**30fps → 61fps (2배 향상)**, Teensy 연결 성공, SHM 통신 확인

## 최종 성능

### verify_geometry.py (인식 검증)
```
python3 verify_geometry.py --direct-trt --no-display

[PROFILE] 120프레임 평균 (16.4ms/frame = 61fps):
  fetch      0.0ms  ← PipelinedCamera zero-copy
  predict   13.7ms  ← DirectTRT GPU output 파싱
  2d_to_3d   2.0ms  ← C++ 확장 모듈
  총        16.4ms = 61fps
```

### pipeline_main.py (제어용)
```
python3 pipeline_main.py --no-display

[PROFILE] 200f avg (17.7ms/frame = 56fps):
  fetch      5.7ms  ← PipelinedCamera (release 타이밍 개선 필요)
  predict    9.3ms
  depth_3d   2.1ms
  shm        0.5ms
  총        17.7ms

→ release 즉시 호출 버전 push 완료 (미테스트, ~15ms 예상)
```

---

## 현재 데이터 흐름

```
ZED X Mini (SVGA 960x600, 120fps, PERFORMANCE depth)
  │
  ↓ [PipelinedCamera 캡처 스레드]
    grab → get_rgb(BGRA, copy=True) → get_depth → get_gravity → ready.set()
  │
  ↓ [Main 스레드]
    get() → release() 즉시 → 다음 grab이 predict와 파이프라인
  │
  ↓ [DirectTRT (trt_pose_engine.py)]
    torch GPU: BGRA→RGB + resize + normalize + letterbox
    TRT: execute_async_v3 (사전 바인딩 버퍼)
    GPU output 파싱: top-1 conf만 CPU 복사 (18개)
  │
  ↓ [batch_2d_to_3d (C++ 확장)]
    6 keypoints × depth → 3D 좌표
    + 3D EMA smoothing (alpha=0.8)
  │
  ↓ [compute_joint_state → SHM]
    /dev/shm/hwalker_pose (36 bytes)
  │
  ↓ [C++ main_control_loop (100Hz, clock_nanosleep)]
    SHM read → GaitReference → ImpedanceController → ILC
    → SerialComm → /dev/ttyACM0
  │
  ↓ [Teensy 4.1 (111Hz)]
    USB serial recv → 모터 제어 (CAN → AK60)
```

---

## 실행 방법

### 터미널 1: Python 파이프라인
```bash
cd ~/h-walker-ws/src/hw_perception/realtime
python3 pipeline_main.py --no-display
```

### 터미널 2: C++ 제어 루프 + Teensy
```bash
cd ~/h-walker-ws/src/hw_control/cpp
./build/hw_control_loop /dev/ttyACM0
```

### verify_geometry (검증만)
```bash
python3 verify_geometry.py --direct-trt              # display 포함
python3 verify_geometry.py --direct-trt --no-display # 최고 속도
```

### 첫 실행 시 필요한 것
```bash
# 1. C++ 후처리 모듈 빌드 (Jetson 최초 1회)
cd ~/h-walker-ws/src/hw_perception/benchmarks/cpp_ext
pip3 install pybind11
python3 setup.py build_ext --inplace
cp pose_postprocess_cpp*.so ../

# 2. PlatformIO 설치 (Jetson 최초 1회)
pip3 install platformio
export PATH="$HOME/.local/bin:$PATH"

# 3. UDEV 규칙 (Teensy 업로드용)
sudo curl -o /etc/udev/rules.d/00-teensy.rules https://www.pjrc.com/teensy/00-teensy.rules
sudo udevadm control --reload-rules

# 4. Teensy 펌웨어 업로드 (버튼 누른 상태로)
cd ~/h-walker-ws/firmware
pio run -t upload

# 5. C++ 제어 루프 빌드
cd ~/h-walker-ws/src/hw_control/cpp
cmake -B build && cmake --build build
```

---

## 성공한 최적화 (13가지)

| # | 최적화 | 이전 → 이후 | 효과 |
|---|--------|-----------|------|
| 1 | PipelinedCamera (Double Buffer + Event) | fetch 9.4ms → 0.0ms | grab을 predict 뒤에 숨김 |
| 2 | DirectTRT (Ultralytics 우회) | predict 16ms → 13ms | torch GPU 전처리 |
| 3 | GPU output 파싱 | 7200개 → 18개 CPU 복사 | -2ms |
| 4 | BGRA raw 전달 | BGR 변환 2회 → 1회 | 색변환 절약 |
| 5 | C++ 후처리 빌드 | 10ms → 2ms | pybind11 |
| 6 | Safety/KF 제거 (pipeline) | 22ms → 17ms | C++가 제어 담당 |
| 7 | sleep 제거 (pipeline) | rate limit → 최대 속도 | 파이프라인 유지 |
| 8 | ONNX→TRT 자동 빌드 | 수동 → 자동 | 버전 불일치 해결 |
| 9 | detection 실패 fallback | 끊김 → 이전 프레임 유지 | prev_kpts_2d |
| 10 | Sagittal plane 시각화 | 없음 → Y-Z 측면뷰 | 별도 cv2 window |
| 11 | 3D EMA smoothing | raw → alpha=0.8 | depth 떨림 감소 |
| 12 | BONE_RANGES 완화 | 0.33-0.52 → 0.25-0.55 | OUT OF RANGE 감소 |
| 13 | 캘리브 중 E_STOP 방지 | 즉시 발동 → 리셋 | 닭/달걀 해결 |

## 실패한 것 + 원인 (12가지)

| # | 시도 | 원인 |
|---|------|------|
| 1 | AsyncCamera (기존) | ZED SDK thread-unsafe → segfault |
| 2 | AsyncCamera + _zed_lock | lock contention → depth 17ms |
| 3 | capture_depth=True (이전) | GPU 경합 → predict +5ms |
| 4 | SegmentLengthConstraint | 피드백 루프 → 왼쪽 keypoint 고착 |
| 5 | One Euro Filter 모델 내부 | 워밍업 고착 → Joints 0/6 |
| 6 | One Euro Filter 외부 | 2D 이동 → depth NaN → 0/6 |
| 7 | EMA on 2D keypoints | 2D 이동 → depth NaN → 0/6 |
| 8 | zero-copy (copy=False) | ZED 버퍼 덮어씌워짐 |
| 9 | get_3d_coords() | camera intrinsics 없음 → pixel을 3D로 |
| 10 | cv2.cuda | JetPack OpenCV가 CUDA 없이 빌드 |
| 11 | imgsz 480 ONNX → 640 TRT | 입력 shape 고정 불일치 |
| 12 | setattr joint_angle | @property라 setattr 불가 |

## 핵심 교훈 (7가지)

1. **2D keypoint를 건드리면 depth가 깨진다** — smoothing은 3D/각도에만 적용
2. **ZED SDK는 thread-unsafe** — Event 동기화 필수
3. **GPU 경합 vs fetch 절약** — 경합(+5ms) < fetch 절약(-9ms) = 파이프라인 이득
4. **sleep이 파이프라인을 방해** — Python sleep 제거, C++가 타이밍 담당
5. **Ultralytics 우회 효과 제한적** — torch upload 오버헤드로 3ms만 절약
6. **C++이 RT 타이밍 담당** — Python GC/sleep 지터로 정시성 불가
7. **ONNX→엔진 imgsz 고정** — imgsz 변경 시 ONNX 재export 필요

---

## Teensy 연결 상태

### 완료
- ✅ PlatformIO 설치
- ✅ Teensy 4.1 펌웨어 빌드 (readLoadcell → readLoadcellForceN 수정)
- ✅ 펌웨어 업로드 성공 → /dev/ttyACM0
- ✅ UDEV 규칙 설치 (버튼 없이 업로드 가능)
- ✅ C++ main_control_loop 빌드 성공 (goto scope 수정)
- ✅ SHM 통신 확인 (F_total 값 정상 출력)

### 미완료
- ⏸ pipeline release 즉시 호출 버전 테스트 (예상 15ms)
- ⏸ C++ 제어 루프 장시간 안정성
- ⏸ 실제 모터 구동 테스트 (impedance only)
- ⏸ CSV 로그 확인 (`hw_control_loop.csv`)

---

## 미해결 이슈

1. **One Euro Filter 적용 불가** — 2D keypoint 이동 시 depth NaN. 3D/각도 레벨에서만 가능
2. **한쪽 다리 가림 시 인식 실패** — 학습 데이터에 occlusion 케이스 부족
3. **thigh 길이 간헐적 OUT OF RANGE** — hip keypoint 위치 불안정 (depth 노이즈)
4. **cv2.cuda 비활성화** — OpenCV CUDA 빌드 필요 (30분+)
5. **PERFORMANCE depth deprecated** — ZED SDK가 NEURAL 권장
6. **pipeline fetch 6ms 잔존** — release 즉시 호출로 해결 예정 (미테스트)

---

## 내일 할 것 (우선순위)

1. **pipeline release 즉시 호출 테스트** — fetch 0ms 확인
2. **C++ 제어 루프 + Teensy 장시간 안정성**
3. **실제 모터 구동 테스트** (impedance only, ILC 없이, 저항값 낮게)
4. **Sagittal view 확인**
5. **데이터 저장 확인** (`hw_control_loop.csv`)
6. **학습 데이터 보강 계획** (swing phase, occlusion)

---

## 주요 파일 위치

### Jetson (`~/h-walker-ws`)
```
src/hw_perception/
  benchmarks/
    trt_pose_engine.py      ★ DirectTRT (최적화 핵심)
    zed_camera.py           ★ PipelinedCamera
    pose_models.py          (Ultralytics 경유)
    postprocess_accel.py    (C++ 확장 래퍼)
    cpp_ext/                (pybind11 모듈)
  realtime/
    verify_geometry.py      ★ 인식 검증 + sagittal view
    pipeline_main.py        ★ 제어용 (최소화)
    joint_3d.py             (BONE_RANGES)
    calibration.py          (StandingCalibration)
    shm_publisher.py        (POSIX SHM)
  models/
    yolo26s-lower6-v2.engine             (Ultralytics 빌드)
    yolo26s-lower6-v2-640.direct.engine  ★ DirectTRT용

src/hw_control/cpp/
  src/main_control_loop.cpp ★ 100Hz 제어
  include/
    pose_shm.h              (SHM 레이아웃 36 bytes)
    shm_reader.hpp
    impedance_controller.hpp
    ilc_controller.hpp
    serial_comm.hpp
  build/hw_control_loop     (빌드된 실행 파일)

firmware/
  src/Treadmill_main.ino    ★ Teensy 4.1 펌웨어
```

### 로그/데이터
- `/dev/shm/hwalker_pose` — Python → C++ SHM (36 bytes)
- `hw_control_loop.csv` — C++ 100Hz 로그 (Jetson 디스크)
  - time, gait_phase, 관절각도, reference, force, Teensy feedback

---

## 관련 커밋 (오늘)

```
67ca22c perf: capture depth in pipeline thread + release immediately
6fd1631 perf: remove sleep — max speed SHM write
49ceed5 perf: strip Safety+KF from pipeline — minimal grab→predict→3D→SHM
83f0672 tune: LOOP_WARN_MS 20→25
75f7fc8 perf: apply PipelinedCamera + DirectTRT to pipeline_main
805f350 fix: move variable declarations before goto label (C++ scope)
8341932 fix: readLoadcell → readLoadcellForceN
01a486a feat: sagittal plane visualization window
28a3877 tune: 3D EMA alpha=0.8
... (총 30+ 커밋)
```

---
*작성: 2026-04-15 EOD*
*브랜치: control*
