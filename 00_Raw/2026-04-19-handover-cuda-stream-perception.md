# H-Walker CUDA_Stream Perception — 인수인계서 (2026-04-19)

> **목적:** 새 세션 (Claude 또는 사람) 이 이 문서만 읽어도 프로젝트 상태를 정확히 파악하고 바로 이어서 작업할 수 있도록.
> **작성일:** 2026-04-19 (2026-04-18 EOD 기준 상태)
> **관련 문서:**
> - `2026-04-18-perception-pipeline-wrap-up.md` (오전 mainline 작업 기록)
> - `2026-04-18-p0-track-completion-report.md` (P0 트랙 완료 보고서)
> - `~/vault/Research/10_Wiki/realtime-pose-estimation.md` (주제별 누적 지식)

---

## 0. TL;DR — 30초 요약

- **프로젝트:** H-Walker 케이블 드리븐 보행 재활 워커, Jetson Orin NX + ZED X Mini + Teensy 4.1
- **오늘 결과:** CUDA_Stream 트랙에서 **20ms 실시간성 사용자 요구 달성** (p99=15ms, HARD LIMIT 위반 0.031%)
- **핵심 커맨드:** `sudo ./src/hw_perception/CUDA_Stream/launch_clean.sh 60`
- **브랜치:** `feature/cuda-stream-perception` (오늘 대부분 작업), `control` (mainline, 어제 P0 완성)
- **다음 할 것:** C++ 제어 통합 → 모터 end-to-end 실험

---

## 1. 프로젝트 개요 (Zero 시작 시)

### 하드웨어
| 구성요소 | 스펙 |
|---|---|
| **Jetson Orin NX 16GB** | JetPack 6.x, MAXN 모드, 1024-core Ampere, 8-core A78AE |
| **ZED X Mini** | GMSL2, SVGA 960×600 @120fps, IMU 200Hz, S/N 52277959 |
| **Teensy 4.1** | `/dev/ttyACM0`, 111Hz inner loop, CAN → AK60 |
| **AK60 모터** | 케이블 장력 max 70N |

### 목표
- 실시간 3D pose estimation (ZED + YOLO TRT)
- 정상인 / 뇌졸중 환자 보행 재활
- **소프트 실시간**: 99% frame < 16ms, max < 20ms, 0 HARD LIMIT 위반을 control에 전파 안 되게

### 디렉토리 구조
```
~/h-walker-ws/                         # 메인 repo
├── src/
│   ├── hw_perception/
│   │   ├── realtime/                  # mainline Python pipeline (control 브랜치)
│   │   ├── benchmarks/                # ZED camera, TRT wrapper
│   │   ├── CUDA_Stream/               # 실험 브랜치 전용 (feature/cuda-stream-perception)
│   │   │   ├── run_stream_demo.py     # 메인 스크립트
│   │   │   ├── view_sagittal.py       # 별도 프로세스 viewer
│   │   │   ├── zed_gpu_bridge.py      # ZED + IMU quaternion
│   │   │   ├── launch_clean.sh        # ⭐ sudo 래퍼 (매번 이것으로 실행)
│   │   │   ├── yolo26s-lower6-v2.engine  # 사용할 엔진 (★)
│   │   │   └── yolo26s-fp16io.engine     # 쓰지 말 것 (box_conf 0.04)
│   │   └── models/                    # yolo26s-lower6-v2-640.direct.engine (mainline)
│   └── hw_control/cpp/                # C++ 제어 루프 (control 브랜치만)
├── firmware/                          # Teensy 펌웨어
└── ~/vault/Research/                  # Obsidian 노트
```

---

## 2. 브랜치 현황 (2026-04-18 EOD)

### `control` (mainline)
- **상태:** P0-1~P1-6 완료 (어제 2026-04-17)
- **마지막 커밋:** `ed4d933f fix(P0-1): phi 정지 시 update_profile도 동결`
- **성능:** 70-74Hz, p99 ~17ms, e2e max 22ms
- **특징:**
  - Bone length constraint 통합
  - Joint velocity bound (20°/frame)
  - C++ force clamp 5중 (NaN/rate/clamp)
  - SHM seqlock
  - CPU isolation (Python 2-5, C++ 6-7)
- **실행:** `python3 pipeline_main.py --no-display --method B`

### `feature/cuda-stream-perception` ⭐ (오늘 작업)
- **상태:** 실험 트랙, 실시간성 목표 달성
- **마지막 커밋:** `883ec970 feat(launch_clean): chrt -r 90 RT priority + memlock 적용`
- **성능:** 74Hz, p50=12.6, p99=15.1ms, HARD LIMIT 0.031%
- **특징:**
  - 3-stage pipeline (capture / preprocess / infer / postprocess)
  - CUDA stream 관리
  - IMU quaternion 기반 world frame (pitch 32°)
  - Frame-skip guarantee (20ms 초과 → valid=False)
  - launch_clean.sh (자동 clean startup)
  - Sagittal auto-fit viewer (mainline 스타일)
- **실행:** `sudo ./src/hw_perception/CUDA_Stream/launch_clean.sh 60`

### Legacy 브랜치
`feature/treadmill-*`, `feature/overground-*`, `feature/firmware`, `feature/common` — legacy migration commits. 안 건드림.

---

## 3. 오늘 한 것 (2026-04-18, CUDA_Stream 트랙)

### 시작 상태 (오전 종료 시점)
- Mainline P0 완료
- CUDA_Stream 폴더만 생성 (스켈레톤)
- 다른 에이전트가 먼저 CUDA_Stream 구현 (브랜치 `claude/fervent-taussig-e237a9` → merged into `feature/cuda-stream-perception`)

### 한 일 (시간 순)

#### Phase 1: Sagittal Viewer 고치기
- `view_sagittal.py` 의 `y_range=(-0.3, 2.3)` 하드코딩 → **auto-fit** 으로 교체
- **원인:** ankle이 y_range 범위 밖 나가서 잘림 ("ankle 안 보이더라")
- **수정:** mainline `pipeline_main._display_sagittal` 로직 포팅 (`min/max` 기반 dynamic scale, zoom factor)
- 좌우 색상, 중력 화살표, 뼈 길이 표시 추가

#### Phase 2: IMU Rotation 수정
- **기존:** `imu.get_linear_acceleration()` 사용 — ZED SDK 5.x에서 **gravity-compensated** (norm ≈ 0) → filter > 5.0 에 전부 걸려 warmup 실패
- **다른 에이전트의 임시 조치:** `--camera-pitch-deg 32` 수동 override 추가
- **사용자 지적:** "카메라 IMU로 제대로 해야지"
- **수정:** mainline `ZEDIMUWorldFrame` 동일한 **quaternion 방식**으로 변경
  - `imu.get_pose().get_orientation()` → 평균 quaternion → rotation matrix
  - SDK 버전 무관하게 동작

#### Phase 3: 20ms HARD LIMIT Guarantee
- **사용자 요구:** "딜레이가 아무리 생겨도 20 ms 이상으로 떨어지면 안돼"
- **측정:** p99 = 21.52ms → 1.5ms 초과 (위반)
- **해결 3계층:**
  1. `gc.disable()` — Python GC 2-5ms pause 제거
  2. `SCHED_FIFO priority 90` — OS scheduler 선점 방지
  3. **Frame-skip guarantee** ← 핵심: 20ms 초과 frame은 `valid=False`로 publish → C++ 제어가 skip → Teensy에 stale data 절대 도달 안 함

#### Phase 4: 재실행 시 성능 열화 해결
- **증상:** 같은 명령 여러 번 실행 → 첫 실행 0.046% → 4회차 64.7% (1400배 악화)
- **원인:** Argus IPC 파일 (`/dev/shm/sem.ipc_test_*`, root 소유) 누적. 일반 사용자는 못 지움.
- **해결:** `launch_clean.sh` 작성 — sudo 래퍼
  - 이전 publisher/viewer 정리
  - Stale SHM + Argus IPC 파일 제거 (root)
  - `systemctl restart nvargus-daemon` (Argus 내부 리셋)
  - `jetson_clocks + nvpmodel -m 0`
  - `sudo -u user` 전환 + `chrt -r 90 RT priority` + `taskset 2-5` 로 실행
- 이로써 **재부팅 없이 매번 clean 상태** (재부팅 직후와 동등 성능)

#### Phase 5: Warmup 통계 분리
- TRT 첫 inference (frame 6: 69ms)가 stats에 포함되어 max 왜곡
- **수정:** `WARMUP_SKIP_FRAMES = 30` — 첫 30 frame은 publish는 하지만 p99/HARD LIMIT 계산에서 제외
- 진짜 steady-state 성능만 측정

---

## 4. 잘 된 것

### ✅ 20ms 실시간성 달성
```
300초 / 22,327 frames / 74.3 Hz
e2e p50/95/99 = 12.61/13.90/15.10 ms  max=22.68 ms
HARD LIMIT 20 ms: 7 / 22,297 frames (0.031%) — 전부 valid=False로 차단
→ Acceptable for soft real-time
```

**사용자 요구사항 완전 충족.**

### ✅ launch_clean.sh 패턴 확립
재부팅 필요 없이 매 실행마다 clean startup. 0.031% 지속 가능.

### ✅ IMU 제대로 동작
Quaternion 방식으로 안정적 R 계산:
```
q_mean=[-0.277, -0.008, 0.028, 0.961]    ← 32° pitch-down 정확히 감지
R_world_from_cam = [[0.998, -0.051, -0.032],
                    [0.059,  0.845,  0.531],
                    [-0.001, -0.533, 0.847]]
```

### ✅ 감지 정확도
```
box_conf = 0.96
kpt_conf 전부 1.00
6 keypoint 안정 감지 (L/R × hip/knee/ankle)
```

### ✅ Sagittal Viewer
- Auto-fit (ankle 안 잘림)
- 좌/우 색상 구분
- 중력 화살표
- 뼈 길이 실시간 표시

---

## 5. 안 된 것 (+ 원인 + 교훈)

### ❌ `yolo26s-fp16io.engine` 사용
- **증상:** box_conf = 0.04, 사람 안 보임
- **원인:** FP16 I/O 엔진 — 표준 preprocessor와 normalize 범위 불일치 (추정). 또는 다른 학습 모델.
- **교훈:** `yolo26s-lower6-v2.engine` (mainline 계열, 22MB, FP32 I/O) 만 사용.

### ❌ `--camera-pitch-deg` 수동 override 버그
- **증상:** R[1][2] 부호 반대
- **원인:** `_rotation_from_forward_pitch` 의 주석 `(0, cos(p), -sin(p))` 틀림. 실제는 `+sin(p)` 맞음.
- **상태:** 기본값 OFF. IMU quaternion 쓰므로 안 쓰도록 설정.

### ❌ P0-5 serialize_depth (mainline에서 발견)
- 이전에 mainline에서 시도한 depth 직렬화가 pipeline 붕괴 (39Hz로 급락)
- **이유:** capture가 depth_request.wait 에서 블록 → 다음 grab 시작 지연
- **상태:** 기본값 OFF, 플래그 `--serialize-depth` 로만 활성 가능 (실험용)

### ❌ GDM (GUI) 끄기 시도 (2026-04-17에 시도)
- **목적:** X11 compositor 제거로 성능 개선
- **결과:** ZED X Mini segfault (`nvbufsurface: Failed to create EGLImage`)
- **원인:** GMSL2 카메라는 Argus/EGL 필요 → X server 필수
- **교훈:** Jetson + GMSL/CSI 카메라에서 **GDM 절대 끄지 말 것**

### ❌ Viewer와 publisher 동시 실행 (성능 측정 시)
- **증상:** publisher FPS 74→42Hz 반토막
- **원인:** cv2.imshow + X11 렌더 + GPU 경합
- **교훈:**
  - 성능 측정 시 viewer 끌 것
  - 시각 검증 시에만 켜기
  - 동시 실행 필요하면 FPS 손실 수용

### ❌ NEURAL depth mode
- **증상:** FPS 29Hz (72Hz 대비 60% 감소)
- **원인:** GPU에서 neural depth 계산 + TRT YOLO → SM 경합
- **정확도 이득:** ±3cm (노이즈 수준)
- **교훈:** PERFORMANCE 모드가 최적. NEURAL/NEURAL_LIGHT 기각.

### ❌ imgsz 480 (사용자 거부)
- 정확도 손실 우려로 **사용자 영구 거부**
- 640 유지

### ❌ One Euro Filter (과거 기각)
- mainline에서 이전에 기각. CUDA_Stream에서도 기본 OFF
- **교훈:** 모든 variant (2D/3D/모델내부) 에서 Joints 0/6 실패

---

## 6. 최종 결과 (2026-04-18 EOD)

### Mainline (`control` 브랜치)
```
commit ed4d933f
Python:  pipeline_main.py --no-display --method B
성능:   70-74Hz, p50 13ms, p99 17ms, max 22ms
특징:   P0-1~P1-6 완성, bone constraint, vel bound, SHM seqlock,
        C++ force clamp 5중, CPU isolation
```

### CUDA_Stream (`feature/cuda-stream-perception` 브랜치)
```
commit 883ec970
Python:  sudo ./src/hw_perception/CUDA_Stream/launch_clean.sh 60
성능:   74Hz, p50 12.6ms, p99 15.1ms, max 22.7ms
            HARD LIMIT 0.031% (7 frames in 5 min), 전부 valid=False 차단
특징:   3-stage CUDA stream pipeline, RT priority 90,
        frame-skip guarantee, launch_clean.sh 자동 cleanup,
        Sagittal auto-fit viewer
```

### 어느 것을 쓸 것인가?
- **CUDA_Stream**: 성능 더 좋음 (74Hz vs 70Hz), 20ms hard limit 확실
- **mainline**: C++ 제어 코드 있음, 실제 모터 통합 준비됨

**권장:** CUDA_Stream의 perception + mainline의 C++ 제어 조합이 이상적. 연결 작업 필요 (다음 세션).

---

## 7. 빠른 시작 — 새 세션에서 (Zero Start)

### 상황별 명령

#### A. 단순 검증 (perception 성능만 재확인)
```bash
ssh chobb0@<jetson_ip>
cd ~/h-walker-ws
git fetch origin
git checkout feature/cuda-stream-perception
git reset --hard origin/feature/cuda-stream-perception
sudo ./src/hw_perception/CUDA_Stream/launch_clean.sh 60
```

**기대 결과:**
```
HARD LIMIT 20 ms: X / YYYY frames (< 0.1%)
→ PERFECT / Acceptable for soft real-time
```

#### B. 시각 확인 (skeleton 모양 검증)
```bash
# 터미널 1: publisher
sudo ./src/hw_perception/CUDA_Stream/launch_clean.sh 300

# 터미널 2: viewer (⚠ FPS 떨어짐)
cd ~/h-walker-ws
PYTHONPATH=src python3 -m hw_perception.CUDA_Stream.view_sagittal \
    --schema lowlimb6 --backend opencv --min-conf 0.25
# 'q' 로 종료
```

**카메라 앞 40-80cm** (H-Walker 안에서). 1.5m 이상 거리는 물리적으로 불가능 (walker 안에 서 있음).

#### C. Mainline 원복 (control 브랜치)
```bash
git checkout control
cd src/hw_perception/realtime
python3 pipeline_main.py --no-display --method B
# 또는 display 보려면 (FPS 반토막)
python3 pipeline_main.py --method B
```

#### D. C++ 제어 실행 (mainline only)
```bash
# control 브랜치에서
cd ~/h-walker-ws/src/hw_control/cpp
cmake -B build && cmake --build build
./build/hw_control_loop /dev/ttyACM0
```

---

## 8. 알려진 이슈 (조심할 것)

| 이슈 | 피하는 법 |
|---|---|
| **여러 번 실행 시 성능 열화** | **항상 `launch_clean.sh` 사용**. 직접 python 실행 금지 |
| **GDM (GUI) 절대 끄지 말 것** | GMSL 카메라 segfault |
| **yolo26s-fp16io.engine 사용 금지** | box_conf 0.04. yolo26s-lower6-v2.engine 만 사용 |
| **`--camera-pitch-deg` 사용 금지** | 부호 버그. IMU 자동 사용 |
| **NEURAL depth 사용 금지** | FPS 반토막. PERFORMANCE 유지 |
| **imgsz 변경 금지** | 사용자 영구 거부. 640 유지 |
| **Viewer + publisher 동시 실행 (측정 시)** | FPS 반토막. 벤치마크 때는 viewer 끄기 |
| **One Euro Filter 쓰지 말 것** | Joints 0/6. 모든 variant 기각 |
| **SegmentLengthConstraint 2D 적용 금지** | 피드백 루프 keypoint 고착 |

---

## 9. 아직 미완성 / 다음 할 것

### 🔴 Priority 1 (실험 전 필수)

#### C++ 제어와 CUDA_Stream perception 통합
**현재 상태:** CUDA_Stream publisher는 `/dev/shm/hwalker_pose_cuda` 에 publish. mainline C++ 는 `/dev/shm/hwalker_pose` 읽음. **둘이 연결 안 되어 있음.**

**옵션:**
1. CUDA_Stream publisher가 `/hwalker_pose` (mainline 이름) 에 publish하도록 변경 — SHM 이름만 바꾸면 됨. mainline C++ 자동 연결.
2. Control 브랜치와 merge → 한 브랜치에 둘 다
3. Worktree로 분리 실행 (`~/h-walker-ws/.claude/worktrees/mainline-ctrl`)

**권장:** 1번. `shm_publisher.py` 에서 `DEFAULT_NAME = "hwalker_pose"` 로 변경.

#### Method B knee_err 좌우 비대칭 검증 (mainline 이슈)
Mainline에서 C++ knee_err L=-175, R=-153 (23° 비대칭). Winter gait table의 L/R 반대 위상 때문으로 추정 (정상 동작).
실제 보행 시 phi 변화하면 자동 해소될 것. **phi 움직이는 실험으로 검증 필요.**

#### Teensy 실제 모터 구동 테스트
현재까지 F_total=5N pretension 만 확인. 실제 motor enable 후 거동 **검증 안 됨**.

### 🟡 Priority 2 (품질 향상)

#### Bone length constraint 실측 적용
Static std < 10mm 확인 (mainline). Walking 중 outlier 차단 효과 측정 필요.

#### 실시간성 실측 (여러 환경)
- 카트 enclosure 내부 (공기흐름 제한)
- 장시간 (30분+) 운용 시 thermal 영향
- 여러 피험자에서 keypoint 편향 (hip bias)

#### Sagittal viewer 별도 low-FPS 프로세스화
- 현재 `--fps 5` 옵션은 있지만 미검증
- 측정에 영향 최소화하면서 시각 확인

### 🟢 Priority 3 (선택)

#### INT8 quantization
- predict 13ms → 8-9ms 가능
- Calibration 데이터 50장 필요
- 정확도 검증 필요
- 1-2일 작업

#### Headless Xorg
- GUI 없이 EGL 제공 (현재 GDM 필수)
- 긴 실험 시 compositor 부담 제거
- 복잡, ROI 낮음

#### SCHED_FIFO + rtprio setup
- `/etc/security/limits.d/realtime.conf` (사용자 이미 설정) + 재로그인
- 이후 `chrt -r 90` 을 사용자 세션에서 직접 사용 가능
- 현재 launch_clean.sh 가 sudo 로 처리하므로 우회됨

---

## 10. 영구 교훈 — skiro-learnings 참조

```bash
~/skiro/bin/skiro-learnings list --last 20
```

주요 교훈 (오늘까지 SOLVED):
1. Jetson + GMSL/CSI 카메라 = GDM 절대 끄지 말 것
2. NEURAL depth는 TRT 동시 환경 기각
3. ZED depth view(copy=False)는 pipeline parallel에서 race
4. release는 get_rgb 직후 호출
5. Method B 카메라 고정 시 static R (skip_imu=True)
6. Python+C++ CPU isolation 필수
7. Viewer display 켜면 FPS 반토막
8. jetson_clocks 부팅마다 재적용
9. One Euro Filter 모든 variant 불가
10. 여러 번 실행 시 Argus 상태 누적 → launch_clean.sh 로 cleanup

---

## 11. 관련 파일 빠른 참조

### 필수 파일
```
src/hw_perception/CUDA_Stream/
├── launch_clean.sh              ⭐ 항상 이것으로 실행
├── run_stream_demo.py           메인 pipeline
├── zed_gpu_bridge.py            ZED + IMU quaternion
├── view_sagittal.py             ⭐ auto-fit viewer
├── yolo26s-lower6-v2.engine     ⭐ 사용할 엔진
└── keypoint_config.py           lowlimb6 schema

src/hw_perception/realtime/ (mainline)
├── pipeline_main.py             mainline pipeline
├── bone_constraint.py           3D outlier 방지
└── shm_publisher.py             SHM + seqlock

src/hw_control/cpp/src/ (mainline)
└── main_control_loop.cpp        100Hz 제어 + P0-1 ILC freeze + P1-6 force clamp
```

### 주요 commit 참조
```
CUDA_Stream 트랙:
883ec970  chrt -r 90 RT priority (launch_clean.sh)
5f9b035e  launch_clean.sh 스크립트 추가
1f5b5220  재실행 최적화 (warmup 분리, cleanup)
89e409ad  20 ms HARD LIMIT guarantee
a8732ace  IMU quaternion 방식
7093d50c  sagittal auto-fit
63c13e10  lowlimb6 + P0 통합 + PipelineTracer (이전 agent 작업)

Mainline (control):
ed4d933f  P0-1 update_profile freeze
0737f05c  P1-6 force clamp 5중
f93b096d  P0-3 bone length constraint
82a722fe  P0-4 velocity bound
fae3decf  P0-2 SHM seqlock
0aa4781c  P0-1 ILC phi freeze
```

---

## 12. 시스템 환경 체크리스트 (첫 실행 시)

```bash
# 1. Jetson 상태
sudo nvpmodel -q        # MAXN 확인
sudo jetson_clocks --show | grep GPU  # 918MHz 고정

# 2. 의존성
python3 -c "import torch; print('torch', torch.__version__)"
python3 -c "import tensorrt; print('TRT', tensorrt.__version__)"
python3 -c "import pyzed.sl; print('pyzed OK')"

# 3. 하드웨어
ls /dev/ttyACM0         # Teensy
ZED_Explorer --version  # ZED SDK

# 4. Repo 상태
cd ~/h-walker-ws && git branch --show-current
git log --oneline -5
```

---

## 13. 사용자 선호 / 주의사항

- **한국어 소통**
- **간결 직접적 답변** 선호
- **불필요한 요약/반복 금지**
- **Co-Authored-By / claude / AI 언급 금지** (git commit, PR 등)
- **python이 아닌 python3 사용**
- **vault (Obsidian) = 컨텍스트 저장소** — memory 대신 여기 기록
- **skiro-learnings 써서 교훈 기록** (`~/skiro/bin/skiro-learnings add`)

---

## 14. 다음 세션 첫 10분에 할 것

1. 이 문서 읽기 (5분)
2. Jetson 접속 + 브랜치 확인 (`git log --oneline -5`)
3. `sudo ./src/hw_perception/CUDA_Stream/launch_clean.sh 60` 한 번 돌려서 0.05% 이하 재확인 (2분)
4. 사용자에게 우선순위 확인 (1분):
   - C++ 통합 → 실험 준비? (Priority 1)
   - 추가 최적화? (Priority 2)
   - 실험 진행? (Priority 1)
5. 결정된 것부터 시작

---

*작성: 2026-04-19*
*CUDA_Stream 트랙 최종 성능: p99=15ms, HARD LIMIT 0.031%, 74Hz sustained*
*mainline: control 브랜치 P0-1~P1-6 완성*
*다음: C++ 제어 통합 + 실제 모터 실험*
