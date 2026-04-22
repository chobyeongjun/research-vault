# CUDA Stream 기반 H-Walker Perception 파이프라인 재구성 계획

## ⚠️ 사전 승인된 격리 규칙 (원격 push 스크린샷 기반)
원격 브랜치 `claude/distracted-margulis-74ddfc`에 이미 `src/hw_perception/CUDA_Stream/` 스켈레톤(README.md, PLAN.md, docs/, results/)이 push되어 있다. 본 계획은 그 규칙을 **그대로** 준수하며 확장한다.

1. **Mainline 수정 금지:** `src/hw_perception/realtime/`, `src/hw_perception/benchmarks/` 는 **읽기만**. 필요 로직은 `CUDA_Stream/` 내부로 **복사·래핑**
2. **SHM 이름 분리:** 새 경로는 `/hwalker_pose_cuda`. mainline의 `/hwalker_pose`와 네임스페이스 충돌 절대 금지
3. **실패해도 OK:** mainline 영향 0. 제어 루프는 언제든 기존 경로로 복귀 가능해야 함
4. **폐기 기준:** (a) segfault 재현 불가 / (b) 1주 진전 없음 / (c) mainline 대비 개선 없음 → 3개 중 하나 충족 시 폐기

**주의 — 브랜치 네이밍:** 사용자 글로벌 규칙상 `claude/`·AI 흔적 금지. 해당 브랜치는 외부 에이전트가 생성한 것으로 보이며, promote 단계에서 `feature/cuda-stream-perception` 등 재명명 필요.

## Context (왜 이 변경인가)

**현재 병목 (skiro-learnings + 탐색 결과):**
- `src/hw_perception/benchmarks/pose_models.py:928-946`에서 `model(rgb)` → `torch.cuda.synchronize()` 동기 호출 → predict 25ms + CPU contention 시 20–28ms spike
- YOLOv8/RTMPose 모두 **default CUDA stream**만 사용 → ZED depth retrieve, 전처리, 추론, 후처리가 **직렬**로 실행
- ZED SDK GPU 버퍼와 PyTorch 추론이 **같은 context**인지 불명확 → 잠재적 암묵 동기화
- `run_benchmark.py:355-437`의 Phase A(grab) → Phase B(infer) → Phase C(post) 순차 구조

**왜 지금까지 CUDA Stream으로 안 갔나 (정직한 분석):**
1. **단일 모델 단발 추론**에서는 default stream + `synchronize()`가 구현 비용 대비 이득이 적다 — stream 분리 이득은 "여러 단계 병렬화"에서 나옴
2. **race condition 디버깅 비용**이 높다 (실제로 ZED `copy=False` race로 캘리브 0% 고착 경험, skiro-learnings 참조)
3. **PyTorch는 암묵 stream 관리**를 잘 해서, 병목의 주범이 stream이라는 신호가 늦게 나타남 — CPU isolation·--no-display·copy 정책 같은 "큰 돌"을 먼저 치우는 게 ROI가 높았음
4. 이 세 가지가 치워진 **지금**이 CUDA Stream의 본격 이득 구간 (capture ⊥ inference ⊥ postprocess를 동시에 돌릴 조건이 됨)

**기대 효과 (스펙 기반 추산):**
- YOLO26s-pose TRT FP16 @ Orin NX Super Mode(157 TOPS): pure inference ≈ 6–9 ms (T4 2.5 ms × Orin NX/T4 factor × pose overhead)
- 3-stage overlap 이상적 경우: e2e latency가 max(stage) + ε로 수렴 → 18ms → **~9ms 수렴** 기대
- Outer 제어(10–30Hz)에 30ms 이상 마진 확보, Teensy inner(111Hz)와 안정적 동기

## 대상 하드웨어·소프트웨어 (조사 근거)

| 구성요소 | 스펙 | 핵심 제약 |
|---|---|---|
| **ZED X Mini** | Baseline 5cm, 1200p@60/30, 1080p@60/30, **SVGA 600p@120**; 2.2mm lens depth 0.1–8m; IMU 200Hz; GMSL2 FAKRA-Z (PoC); ZED SDK **5.0+** | USB 불가. GMSL2 capture card + JetPack 네이티브 드라이버 필요. ZED SDK **5.2+**에서 NV12 zero-copy RawBuffer API 제공 |
| **Jetson Orin NX 16GB** | 1024-core Ampere GPU + 32 Tensor Cores (GA10B, 8nm), 16GB LPDDR5, 8-core A78AE. 기본 100 TOPS → **MAXN_SUPER 157 TOPS (INT8 Sparse)**, 40W | **JetPack 6.2** 플래시 필수(Super Mode). 40W에서 열 스로틀링 주의 — 카트 내부 공기흐름/히트싱크 확인 |
| **YOLO26s-pose** | 10.4M params, mAPpose 63.0 (e2e), 17 keypoints(COCO). **DFL 제거 + NMS-free** → INT8 quant 친화적. 출시 2026-01-14 | `yolo26s-pose.pt` → ONNX → TRT engine. FP16은 즉시, INT8은 캘리브레이션 셋 필요 |
| **TRT Python API** | `execute_async_v3(stream_handle=torch_stream.cuda_stream)` 지원. default stream 피하고 explicit stream 권장 | Dynamic shape 금지 구간(CUDA Graph capture용). pinned host memory로 H2D 가속 |

## 변경 대상 파일 (생성·수정)

생성할 새 모듈: `src/hw_perception/CUDA_Stream/`
```
CUDA_Stream/
├── README.md                 # 목적, 현재 상태, 성능 목표 (사용자 요청 구조)
├── PLAN.md                   # 본 계획서 복사본 (상세 Phase)
├── docs/
│   ├── architecture.md       # stream 다이어그램 (mermaid)
│   ├── benchmarks.md         # 베이스라인 vs stream 결과
│   └── troubleshooting.md    # race / sync 디버깅 노트
├── results/                  # CSV / PNG (.gitkeep)
├── stream_manager.py         # 4개 stream 생성·컨텍스트 관리
├── trt_runner.py             # TRT engine load + execute_async_v3 래퍼
├── zed_gpu_bridge.py         # ZED NV12/BGRA → CUDA tensor (zero-copy)
├── gpu_preprocess.py         # resize/normalize (torchvision or custom kernel)
├── gpu_postprocess.py        # 2D keypoint → 3D (depth 샘플) GPU 버전
├── pipeline.py               # 3-stage (N-1 post ∥ N infer ∥ N+1 pre) 오케스트레이션
├── cuda_graph.py             # 고정 shape CUDA Graph capture
└── benchmark_stream.py       # run_benchmark.py 기반 비교 스크립트
```

기존 파일 **참조(읽기)만**(격리 규칙 #1 — mainline 수정 금지):
- `src/hw_perception/benchmarks/zed_camera.py:483-485` — ZED raw_bgra zero-copy view (로직 **복사**해서 `CUDA_Stream/zed_gpu_bridge.py`로)
- `src/hw_perception/benchmarks/zed_camera.py:776-872` — `AsyncCamera` 스레드/deque 구조 (패턴 **참고**, 새로 구현)
- `src/hw_perception/benchmarks/pose_models.py:922-1040` — YOLO predict 타이밍 측정 패턴 (`yolo_async_ms`/`gpu_sync_ms`) — 메트릭 key 명만 호환 유지
- `src/hw_perception/benchmarks/postprocess_accel.py` — 2D→3D C++ 후처리 (A/B 비교용 **외부 호출**, 수정 X)
- `src/hw_perception/benchmarks/run_benchmark.py:398-461` — 벤치마크 메트릭 수집 구조 (동일 CSV 컬럼으로 호환)

## 단계별 계획 (2일 = 총 16시간 예상)

### Phase 0 — 원격 스켈레톤 동기화 (30분)
**목표:** 이미 push된 `CUDA_Stream/README.md` + `PLAN.md`를 정합 기준점으로 확정.
1. 원격 브랜치 fetch → `README.md`, `PLAN.md` 내용 확인
2. 본 계획의 Phase 구조(0–5)와 원격 PLAN.md의 Phase(1–5: 조사 / 아키텍처 / 구현 / 검증 / 판정)를 **상위 매핑**:
   - 원격 Phase 1 ≈ 본 Phase 1 (환경·측정)
   - 원격 Phase 2 ≈ 본 Phase 2 (TRT + Stream 인프라)
   - 원격 Phase 3 ≈ 본 Phase 3 + 4 (ZED zero-copy + overlap)
   - 원격 Phase 4 ≈ 본 Phase 5 일부 (검증)
   - 원격 Phase 5 (판정/promote) = 본 계획 마지막 Gate (폐기 기준 3개 중 0개 충족 시 promote)
3. 충돌 시 **원격 PLAN.md 우선**, 본 계획은 세부 기술 스펙 보충

### Phase 1 — 환경·측정 기반 (Day 1 오전, 4h)
**목표:** Super Mode 활성화된 깨끗한 베이스라인 숫자 확보. 이 베이스라인 없이 최적화는 자기 기만.
1. **JetPack 6.2 확인·플래시**: `cat /etc/nv_tegra_release`, `sudo nvpmodel -m 0` → MAXN_SUPER, `sudo jetson_clocks`
   - 열 상태 `tegrastats`로 모니터, 40W 지속 시 throttle 여부 기록
2. **ZED SDK 5.2+ 확인**: `ZED_Explorer --version`, 안 되면 업그레이드 (사용자 확인 필요)
3. **의존성**: PyTorch (JetPack 6.2 대응 휠), `ultralytics>=8.3` (YOLO26 지원), `tensorrt` 10.x, `pycuda` 또는 `cuda-python`
4. **베이스라인 측정** (현재 YOLOv8 경로, SVGA 600p@120 + HD1080@60 두 가지):
   - `run_benchmark.py --model yolov8s-pose --no-display --duration 120` → p50/p95/p99 latency, grab/infer/post 분해, GPU util(`tegrastats`)
   - 결과 → `CUDA_Stream/results/baseline_*.csv`
5. **YOLO26s-pose 현재 경로 확인**: `ultralytics`에 YOLO26 지원 버전 설치 → `yolo26s-pose.pt` 다운로드 → 동일 벤치마크 (아직 stream 없이)
6. **산출물:** `baseline_yolov8s.csv`, `baseline_yolo26s.csv`, `thermal_log.csv`

**체크리스트 (Gate 1):**
- [ ] `nvpmodel -q` 가 MAXN_SUPER 출력
- [ ] `tegrastats` GPU freq ≥ 918MHz 지속
- [ ] 베이스라인 p95 latency 숫자 기록됨
- [ ] YOLO26s-pose .pt 로컬에 있음

### Phase 2 — TRT 엔진 + Stream 인프라 (Day 1 오후, 4h)
**목표:** 한 프레임 추론을 default stream 밖에서 확정적으로 실행.
1. **TRT export** (`trt_runner.py`):
   - `yolo model.export(format="engine", half=True, imgsz=640, device=0)` → `yolo26s-pose.engine` (FP16 먼저)
   - INT8은 Phase 4로 미룸 (calibration dataset 수집 뒤)
2. **StreamManager** (`stream_manager.py`):
   - `torch.cuda.Stream()` × 4: `capture_stream`, `preproc_stream`, `infer_stream`, `post_stream`
   - pinned host buffer pool (`torch.empty(..., pin_memory=True)`) — H2D 지연 감소
   - 이벤트 기반 동기화: `torch.cuda.Event()` × N_stages — 교차 의존성을 `stream.wait_event()`로만 표현 (host sync 금지)
3. **TRTRunner** (`trt_runner.py`):
   - engine load, `IExecutionContext` 1개, input/output GPU 버퍼 pre-allocate
   - `infer(input_gpu, stream)`: `set_tensor_address` → `execute_async_v3(stream.cuda_stream)` → **return 즉시** (sync 안 함)
4. **단일 프레임 검증**: baseline 이미지 1장으로 stream 경로 vs default 경로 keypoint 수치 일치 확인 (허용 오차 1px)

**체크리스트 (Gate 2):**
- [ ] `yolo26s-pose.engine` 생성됨, FP16
- [ ] `execute_async_v3` 호출이 `torch.cuda.synchronize()` 없이 리턴
- [ ] stream 경로 keypoint ≒ default 경로 (max err ≤ 1px)

### Phase 3 — ZED zero-copy + GPU 전/후처리 (Day 2 오전, 4h)
**목표:** capture→preprocess→inference 사이의 CPU/PCIe 왕복 제거.
1. **ZED CUDA context 공유** (`zed_gpu_bridge.py`):
   - `sl.InitParameters().sdk_cuda_ctx = <torch CUDA ctx ptr>` 시도 (ZED Python API 이슈 #35 참조 — 불가 시 fallback 경로 기록)
   - ZED SDK 5.2 `RawBuffer` NV12 경로가 가능하면 → NV12→RGB GPU 변환 커스텀 커널 (또는 `cv2.cuda.cvtColor`)
2. **GPU preprocess** (`gpu_preprocess.py`):
   - Center crop + letterbox resize(640) + normalize(1/255) — **모두 GPU**. `torchvision.transforms.v2` GPU 경로 또는 `nvjpeg`/custom kernel
   - 결과 tensor는 `infer_stream`에서 기다릴 입력 버퍼에 직접 쓰기
3. **GPU postprocess** (`gpu_postprocess.py`):
   - keypoint 2D → depth 샘플링: depth Mat의 GPU 버퍼에서 `grid_sample` 또는 직접 인덱싱
   - 3D 좌표 필터(OneEuro/MA) 벡터화 — torch 연산으로만
   - 최종 결과만 D2H (keypoints[17,3] + confidence[17] = 196 bytes) → pinned host buffer
4. **정합성 검증**: CPU 후처리 (`postprocess_accel.py`) 결과와 GPU 후처리 결과가 동일한지 (3D 좌표 허용 오차 1mm)

**체크리스트 (Gate 3):**
- [ ] ZED depth가 GPU에 머물거나 (또는 명시적 D2H가 post stream에서만 발생)
- [ ] preprocess·postprocess에서 `.cpu()` / `.numpy()` 호출이 마지막 keypoint 쓰기 외 없음
- [ ] GPU vs CPU postprocess 3D 좌표 오차 ≤ 1mm

### Phase 4 — 파이프라인 오버래핑 + CUDA Graph + INT8 (Day 2 오후 1/2, 2h)
**목표:** 3-stage를 실제로 동시에 돌려서 e2e latency를 stage max로 수렴.
1. **Triple-buffer 파이프라인** (`pipeline.py`):
   - 프레임 N에서: `capture(N+1)` on capture_stream, `preproc(N+1)` on preproc_stream (capture 끝나면), `infer(N)` on infer_stream, `post(N-1)` on post_stream
   - event `E_capture[N+1]`, `E_preproc[N+1]`, `E_infer[N]`로만 연결. host는 `post_stream.synchronize()`만 기다림 (결과 가져갈 시점)
2. **CUDA Graph capture** (`cuda_graph.py`):
   - 고정 shape 확정되면 infer + preproc를 graph capture → `cudaGraphLaunch`로 kernel launch overhead 제거 (특히 Orin NX CPU 단일 스레드 한계 완화)
   - capture 실패 시 fallback — Dynamic input 있으면 graph 포기
3. **INT8 quantization**:
   - calibration: 50-ground-truth 프레임 (실제 실험 영상 샘플) → TRT `IInt8EntropyCalibrator2`
   - keypoint 품질 gate: GPU FP16 대비 mAP-like 지표 drop < 2%면 채택
4. **CPU affinity + RT priority** (skiro-learnings 반영):
   - Python: `os.sched_setaffinity(0, {2,3,4,5})`
   - `sudo chrt -r 50 python ...` 옵션 지원

**체크리스트 (Gate 4):**
- [ ] `nsys profile` 타임라인에서 4개 stream이 시각적으로 overlap
- [ ] e2e p95 ≤ baseline × 0.5 (이상적으로 ≤ 12ms @ SVGA 120fps)
- [ ] CUDA Graph 사용 시 kernel launch 수 10× 감소

### Phase 5 — 실시간 제어 통합 + 안전 장치 + 검증 (Day 2 오후 2/2, 2h)
**목표:** 실제 Jetson → Teensy 경로에 붙여서 돌아가는지 확인, 실패 시 안전 복귀.
1. **SHM/queue 통합**:
   - 기존 `hw_common` IPC 구조 확인 (조사 후 보완) → keypoint 17×3 + timestamp + confidence를 SHM에 1-writer/1-reader로 publish
   - 제어 루프(outer 10–30Hz)가 최신 프레임 pull, 구프레임 버림
2. **Watchdog**:
   - stream 실패 감지: `cudaStreamQuery` timeout 50ms → fallback to default stream 경로 (기존 `pose_models.py`로 회귀), 제어 루프에 신호
   - depth invalid률 > 30% 유지 시 캘리브 재요청 (skiro-learnings: ZED copy 이슈 재발 방지)
3. **최종 벤치마크**:
   - 120s 연속 실행 × 3회, `results/stream_vs_baseline.csv` 생성
   - 메트릭: FPS avg/p95/p99, grab/pre/infer/post 분해, GPU util, GPU mem, 열 스로틀 로그
   - 제어 루프 jitter (outer 30Hz 목표 대비 실제 dt 분포)
4. **README.md / docs/benchmarks.md 작성** — 숫자 채워넣기

**체크리스트 (Gate 5 — 최종):**
- [ ] 제어 루프 outer 30Hz jitter CV < 5%
- [ ] 연속 10분 실행 중 watchdog 트리거 횟수 기록
- [ ] AK60 cable force 제한 로직 영향 없음 (perception 변경이 제어 안전에 회귀 일으키지 않음)

## 핵심 결정 사항 (기본값 제시, 필요 시 승인 후 조정)
- **해상도·FPS 초기 타깃:** SVGA 600p@120fps (제어 주기 관점 최적). HD1080@60은 Phase 5 이후 선택 벤치
- **정밀도 초기:** FP16 → Gate 4에서 INT8 승격(정확도 drop 확인 후)
- **ZED depth mode:** PERFORMANCE (속도 최우선). NEURAL은 GPU 경합 위험 높으므로 Phase 5 이후 A/B
- **sdk_cuda_ctx 공유 실패 시:** zero-copy 대신 `cudaMemcpyAsync` + separate stream, 여전히 overlap 이득 확보

## 하드웨어 안전·운용 주의
- Orin NX 40W: **팬 + 히트싱크** 없으면 1–2분 내 스로틀. 카트 enclosure 내부 공기흐름 확인
- ZED X Mini GMSL2: 핫플러그 금지. 전원 공급 순서 주의 (PoC 12V)
- Teensy 111Hz inner 루프는 **이 변경 범위 밖** — 제어 안전성(70N limit)은 기존 로직 유지

## 검증 방법 (end-to-end)
```bash
# Gate 1 베이스라인
cd src/hw_perception
python3 benchmarks/run_benchmark.py --model yolov8s-pose --resolution SVGA --duration 120 --no-display --out CUDA_Stream/results/baseline.csv

# Gate 4 stream 버전
python3 CUDA_Stream/benchmark_stream.py --model yolo26s-pose --engine yolo26s-pose.engine \
    --resolution SVGA --streams 4 --cuda-graph --duration 120 --no-display \
    --out CUDA_Stream/results/stream_fp16.csv

# 비교
python3 CUDA_Stream/benchmark_stream.py --compare CUDA_Stream/results/baseline.csv CUDA_Stream/results/stream_fp16.csv

# 실제 제어 루프 통합
python3 src/hw_control/run_impedance.py --perception-source cuda_stream --duration 600
```

합격 기준:
1. p95 e2e latency ≤ baseline × 0.5 (@ SVGA 120fps)
2. keypoint 정확도: FP16 vs baseline max 2D err ≤ 1px, 3D err ≤ 5mm
3. 10분 연속 실행: 열 스로틀링 < 5% 시간, watchdog 트리거 < 1회/분
4. 제어 루프 outer 30Hz jitter CV < 5%

## 공개된 질문 (실행 전 확인 권장)
1. ZED SDK 현재 버전 (`5.2+` 필수 — NV12 zero-copy). 아니면 업그레이드 승인
2. JetPack 현재 버전 (`6.2` 필수 — Super Mode). 아니면 플래시 승인
3. `yolo26s-pose.pt` 또는 ultralytics YOLO26 지원 버전(>=8.3.x) 설치 여부
4. INT8 calibration용 실제 실험 프레임 50장 경로

## Sources (조사 근거)
- [ZED X Mini — Stereolabs](https://www.stereolabs.com/store/products/zed-x-mini-stereo-camera)
- [ZED SDK 5.2 Release (NV12 zero-copy, RawBuffer)](https://www.stereolabs.com/developers/release)
- [Could I share my CUDA context with a PyZEDCamera? (zed-python-api #35)](https://github.com/stereolabs/zed-python-api/issues/35)
- [Jetson Orin NX 16GB 스펙 — TechPowerUp](https://www.techpowerup.com/gpu-specs/jetson-orin-nx-16-gb.c4086)
- [JetPack 6.2 Super Mode — NVIDIA Developer Blog](https://developer.nvidia.com/blog/nvidia-jetpack-6-2-brings-super-mode-to-nvidia-jetson-orin-nano-and-jetson-orin-nx-modules/)
- [Ultralytics YOLO26 — 공식 문서](https://docs.ultralytics.com/models/yolo26/)
- [YOLO26 Jetson + DeepStream + TensorRT 가이드](https://docs.ultralytics.com/guides/deepstream-nvidia-jetson/)
- [YOLO26 arXiv: Key Architectural Enhancements](https://arxiv.org/abs/2509.25164)
- [TensorRT Python API — execute_async_v3](https://docs.nvidia.com/deeplearning/tensorrt/latest/inference-library/python-api-docs.html)
- [TensorRT Best Practices (H2D/D2H overlap)](https://docs.nvidia.com/deeplearning/tensorrt/latest/performance/best-practices.html)
- [Multi-CUDA streams TensorRT on Jetson AGX Orin](https://forums.developer.nvidia.com/t/model-inference-on-multiple-cuda-streams-with-tensorrt-api/266371)
- [PyTorch stream → TensorRT execute_async_v3 이슈](https://github.com/NVIDIA/TensorRT/issues/4340)
