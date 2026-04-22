---
title: Skiro Learnings
created: 2026-04-15
updated: 2026-04-18
tags: [skiro, h-walker, exosuit, hardware, safety, control, pose-estimation]
summary: 로봇 개발 문제-해결 교훈. Research 전용. Reward/Punish 패턴 포함.
---

# Skiro Learnings

## Hardware

### [CRITICAL] AP62200WU VIN 최대 24V, 6S LiPo 완충 25.2V → 정격 초과, AP63205WU-7로 교체 필요
- **상태:** 미해결
- **컨텍스트:** 2026-04-12 stm_board 보드 설계 검토

### [CRITICAL] INA333(3.3V 단전원) + 5V 여기 로드셀 조합 → VCM=2.5V가 허용 2.1V 초과, 측정 불가
- **상태:** 미해결
- **컨텍스트:** 2026-04-12 stm_board 아날로그 신호 체인 검토

### [CRITICAL] ADS1234 AVDD 최소 4.75V 요구인데 3.3V 공급 계획 → ADC 미동작
- **상태:** 미해결
- **컨텍스트:** 2026-04-12 stm_board 아날로그 신호 체인 검토

## Safety

### [CRITICAL] hw_perception/realtime/pipeline_main
- **상태:** 미해결
- **컨텍스트:** 2026-04-14 hook-prompt

### [SOLVED] Hip angle과 Knee angle은 동일한 3점(hip, knee, ankle)에서 나옵니다
- **해결:** 외골격 보드 파손 원인: 4모터 동시 회생 1J → 버스 캐패시터 부족 시 V=143V 폭주. 대책: 11,280μF 벌크 + 26.5V 제동저항 + ISO1050 격리 CAN
- **해결일:** 2026-04-12

### [WARNING] AVAILABLE: jlink, teensy-cli, teensy-gui
- **상태:** 미해결
- **컨텍스트:** 2026-04-15 hook-prompt
- **기록일:** 2026-04-15

### [WARNING] firmware 에서 고쳐야할 부분이 아니라 하나를 더 만들어줬으면 좋겠어
- **상태:** 미해결
- **컨텍스트:** 2026-04-17 hook-prompt
- **기록일:** 2026-04-17

### [critical] p99 latency가 20ms 초과 시 stale keypoint가 AK60 70N까지 밀어올릴 위험
- **상태:** 미해결
- **컨텍스트:** 2026-04-19 CUDA_Stream 실시간성 요구 — 단일 지연 프레임이 제어 루프로 흘러가면 안됨
- **기록일:** 2026-04-18

## Control

### [WARNING] Kd가 필요한 상황이 되면 (실험에서 진동 발생 시) 그때 유한차분으로
- **상태:** 미해결
- **컨텍스트:** 2026-04-11 hook-prompt

### [WARNING] Loading /home/chobb0/h-walker-ws/src/hw_perception/realtime/
- **상태:** 미해결
- **컨텍스트:** 2026-04-14 hook-prompt

### [SOLVED] error 발생했는데  도중에 일단 꺼져서 이거는 내일 이어서 해보자
- **해결:** SegmentConstraint OFF + smoothing OFF + AsyncCamera 제거 → 동기 모드로 인식 정상화. pipeline_main.py 캘리브 중 safety guard 리셋으로 E_STOP 방지
- **해결일:** 2026-04-14

## Software

### [WARNING] fetch    10ms (grab 동기 대기) 여기속도 줄이게 해주고
- **상태:** 미해결
- **컨텍스트:** 2026-04-14 hook-prompt

### [SOLVED] yolo26s-lower6-v2 모델 왼쪽 하체 keypoint 인식 불량 — left_hip→left_knee 9px vs right 31px, SegmentConstraint 피드백 루프 의심
- **해결:** cd ~/RealTime_Pose_Estimation
- **해결일:** 2026-04-14

### [WARNING] 한쪽 다리 가려지거나 2개 이상 keypoint 가려지면 인식 실패 — 학습 데이터에 occlusion 케이스 부족
- **상태:** 미해결
- **컨텍스트:** 2026-04-15 yolo26s-lower6-v2 워커 환경 테스트
- **기록일:** 2026-04-15

## Process

### [WARNING] 수정: GPU에서 직접 torch tensor로 변환하면 왕복 제거 좋다 그렇게 나도 복붙 + 중복 이런 건 제일 싫어
- **상태:** 미해결
- **컨텍스트:** 2026-04-14 hook-prompt

### [SOLVED] 오차 -> 토크 -> F_desired로 가는 거를 정확하게 이해가 안돼 우리는 그냥 Force 를 때려버리잖아 기존의 시스템에서는 말이야
- **해결:** MIT 모드: τ = KP*(p_des-p) + KD*(v_des-v) + T_ff. 순수 토크는 KP=0, KD=0.1, T_ff=원하는값. 어드미턴스 출력은 p_des에 연결하고 KP=30~50, KD=0.5~1.0. 토크를 직접 계산할 필요 없음
- **해결일:** 2026-04-12

### [WARNING] [04/15/2026-11:18:34] [TRT] [I] [MemUsageStats] Peak memory usage of TRT CPU/GPU memory allocators: CPU 2 MiB, GPU 56 Mi
- **상태:** 미해결
- **컨텍스트:** 2026-04-15 hook-prompt
- **기록일:** 2026-04-15

### [WARNING] smoothing=1.0, min_cutoff=1.0, beta=0.05
- **상태:** 미해결
- **컨텍스트:** 2026-04-15 hook-prompt
- **기록일:** 2026-04-15

### [WARNING] ㅍㅣㄹ터 넣으니까 또 안되네 ;;
- **상태:** 미해결
- **컨텍스트:** 2026-04-15 hook-prompt
- **기록일:** 2026-04-15

### [WARNING] 한쪽 다리 가려지거나 2개 이상 가려지면 인식 못함 = >학습 개선시켜야 지
- **상태:** 미해결
- **컨텍스트:** 2026-04-15 hook-prompt
- **기록일:** 2026-04-15

### [WARNING] 음 피드백이라고 함은, 끊기는 게 확실히 덜하긴 하는데 조금 딜레이가 발생해버리는 상황엔 어떡해
- **상태:** 미해결
- **컨텍스트:** 2026-04-15 hook-prompt
- **기록일:** 2026-04-15

### [WARNING] 그래도 딜레이가 있으면 안돼 나는 일반인 대상으로 실험할거야
- **상태:** 미해결
- **컨텍스트:** 2026-04-15 hook-prompt
- **기록일:** 2026-04-15

### [WARNING] @/var/folders/vd/dq1y7b317qg5j1ty0x97nydr0000gn/T/TemporaryItems/NSIRD_screencaptureui_SP5XSn/스크린샷 2026-04-16 10.1
- **상태:** 미해결
- **컨텍스트:** 2026-04-16 hook-prompt
- **기록일:** 2026-04-16

### [WARNING] ⚠ casual failed for 'Force 그래프 보여줘': Expecting value: line 1 column 1 (char 0)
- **상태:** 미해결
- **컨텍스트:** 2026-04-17 hook-prompt
- **기록일:** 2026-04-17

### [INFO] ech_short/clinical_09: Failed to connect to Ollama
- **상태:** 미해결
- **컨텍스트:** 2026-04-17 hook-prompt
- **기록일:** 2026-04-17

### [WARNING] 아마 옛날이랑 동일하게 했던 것 같은데
- **상태:** 미해결
- **컨텍스트:** 2026-04-17 hook-prompt
- **기록일:** 2026-04-17

### [WARNING] 내가 잘 안됐던 것들 + 안하겠다고 하겠던 것들 기록 있지 않아
- **상태:** 미해결
- **컨텍스트:** 2026-04-17 hook-prompt
- **기록일:** 2026-04-17

### [WARNING] ipeline] DirectTRT 모드 (imgsz=480)
- **상태:** 미해결
- **컨텍스트:** 2026-04-17 hook-prompt
- **기록일:** 2026-04-17

### [SOLVED] Jetson+GMSL/CSI 카메라에서 GDM(X server) 끄면 Argus/EGL 실패로 ZED 카메라 segfault
- **해결:** GDM 절대 끄지 말 것. 끄면 Argus daemon 내부 상태까지 깨져 리부팅 강제
- **해결일:** 2026-04-18

### [SOLVED] jetson_clocks 미적용 시 GPU 306MHz(max 918MHz의 33%)로 떨어져 predict spike, 부팅마다 재적용 필요
- **해결:** sudo jetson_clocks 부팅 후 매번 실행. persistent 아님. --show는 확인만, lock 명령 아님
- **해결일:** 2026-04-18

### [WARNING] 딜레이가 아무리 생겨도 20 ms 이상으로 떨어지면 안돼
- **상태:** 미해결
- **컨텍스트:** 2026-04-18 hook-prompt
- **기록일:** 2026-04-18

### [WARNING] W] frame 341: e2e=18.31 ms (soft warn 18, hard 20)
- **상태:** 미해결
- **컨텍스트:** 2026-04-18 hook-prompt
- **기록일:** 2026-04-18

### [WARNING] n, N=20): q_mean=[-0.277, -0.008, 0.028, 0.961]
- **상태:** 미해결
- **컨텍스트:** 2026-04-18 hook-prompt
- **기록일:** 2026-04-18

## Reward Patterns

### [REWARD] Tustin 이산화가 오일러보다 위상 지연 적음
- **왜 잘 됐나:** 111Hz 제어 루프에서 오일러는 위상 오차 누적, Tustin은 주파수 응답 보존
- **카테고리:** control
- **기록일:** 2026-04-15

### [REWARD] 동기 모드 카메라가 비동기보다 안정적
- **왜 잘 됐나:** AsyncCamera 큐 오버플로 없음, 프레임 드롭 제로
- **카테고리:** control
- **기록일:** 2026-04-15

### [REWARD] KP=30 KD=0.5 조합이 안정적
- **왜 잘 됐나:** 응답 빠르고 진동 없음, 부하 변동에도 안정
- **카테고리:** control
- **기록일:** 2026-04-15

### [REWARD] 일단 오늘은 배터리가 다 돼서 여기까지 하고,
- **왜 잘 됐나:** auto-detected positive signal
- **카테고리:** process
- **기록일:** 2026-04-15
- **컨텍스트:** 2026-04-15 hook-prompt

### [REWARD] 지금 정확하게 작동하도록 코드 확실하게 점검하고 진행해
- **왜 잘 됐나:** auto-detected positive signal
- **카테고리:** process
- **기록일:** 2026-04-17
- **컨텍스트:** 2026-04-17 hook-prompt

### [REWARD] 아니 빠르게 됐던 잘 됐던 그 기록이 어떤 방식으로  그렇게 빨라지게 됐던 거냐고
- **왜 잘 됐나:** auto-detected positive signal
- **카테고리:** process
- **기록일:** 2026-04-17
- **컨텍스트:** 2026-04-17 hook-prompt

### [REWARD] 이거 다시 검증하면서 정확하게 작동하는 지 봐봐
- **왜 잘 됐나:** auto-detected positive signal
- **카테고리:** protocol
- **기록일:** 2026-04-18
- **컨텍스트:** 2026-04-18 hook-prompt

### [REWARD] PyTorch: starting from '/home/chobb0/h-walker-ws/src/hw_perception/models/yolo26s-lower6-v2.pt' with input shape (1, 3, 
- **왜 잘 됐나:** auto-detected positive signal
- **카테고리:** software
- **기록일:** 2026-04-18
- **컨텍스트:** 2026-04-18 hook-prompt

### [REWARD] launch_clean.sh 래퍼 패턴 (sudo + pkill + rm Argus IPC + systemctl restart nvargus-daemon + exec chrt -r 90 sudo -u user taskset)
- **왜 잘 됐나:** CUDA_Stream 재시작 시 누적되던 Argus state 완전 제거 → HARD LIMIT 위반율 60%+ → 0.031% 복원, 재부팅 불필요
- **카테고리:** perception
- **기록일:** 2026-04-18

### [REWARD] 20ms HARD LIMIT frame-skip: e2e > 20ms면 publish_valid=False로 마킹하여 C++ 제어 루프가 해당 프레임 skip
- **왜 잘 됐나:** stale keypoint가 AK60 70N까지 밀어올리는 경로 차단, 300s 실측 0.031% 위반 모두 motor 도달 불가 확인
- **카테고리:** safety
- **기록일:** 2026-04-18

### [REWARD] IMU 쿼터니언 평균(N=20) → R 행렬 방식
- **왜 잘 됐나:** 수동 --camera-pitch-deg 덮어쓰기는 부호 버그 위험, camera IMU get_pose().get_orientation()이 SDK 버전 무관 정답
- **카테고리:** perception
- **기록일:** 2026-04-18

### [REWARD] 뭔가 잘 됐다	skiro-learnings reward --what
- **왜 잘 됐나:** auto-detected positive signal
- **카테고리:** control
- **기록일:** 2026-04-18
- **컨텍스트:** 2026-04-18 hook-prompt

## Punish Patterns

### [PUNISH] 오일러 이산화로 임피던스 제어 하면 고주파에서 발산
- **왜 안 됐나:** 오일러 근사는 Nyquist 근처에서 위상 왜곡이 심해 불안정
- **카테고리:** control
- **기록일:** 2026-04-15

### [PUNISH] KP=100으로 올리면 진동 발생
- **왜 안 됐나:** 오버슈트 + 고주파 진동, KP>80은 위험
- **카테고리:** control
- **기록일:** 2026-04-15

---

### [PUNISH] m Manager: Installing teensy
- **왜 안 됐나:** auto-detected negative cause analysis
- **카테고리:** control
- **기록일:** 2026-04-15
- **컨텍스트:** 2026-04-15 hook-prompt


### [PUNISH] 이미 모델들이랑 다 옮겨놨던 것 같은데
- **왜 안 됐나:** auto-detected negative cause analysis
- **카테고리:** safety
- **기록일:** 2026-04-18
- **컨텍스트:** 2026-04-18 hook-prompt

## Perception

### [SOLVED] NEURAL depth mode는 TRT YOLO와 동시 실행 시 predict 30ms (x2.4), 29Hz로 급락
- **해결:** PERFORMANCE 유지. NEURAL_LIGHT도 30% 손실이라 기각. ZED SDK deprecated 경고는 무시
- **해결일:** 2026-04-18

### [SOLVED] ZED depth view(copy=False)는 PipelinedCamera release 즉시 호출 시 race condition → state.valid=False 캘리브 0% 고착
- **해결:** capture 스레드에서 get_depth(copy=True) 강제. SVGA 2.3MB copy=0.5ms 오버헤드
- **해결일:** 2026-04-18

### [SOLVED] PipelinedCamera에서 release를 프레임 끝(shm 뒤)에 호출하면 fetch 7ms 그대로
- **해결:** release는 get_rgb 직후에 호출. capture가 predict와 병렬로 다음 grab 시작 → fetch 0ms
- **해결일:** 2026-04-18

### [SOLVED] Method B ZEDIMUWorldFrame은 카메라 고정이면 static R로 충분, 매 프레임 IMU retrieve 불필요
- **해결:** skip_imu=True를 Method A/B 양쪽에 적용. capture 스레드 get_gravity_vector 호출 제거로 1ms 절감
- **해결일:** 2026-04-18

### [SOLVED] Python+C++ 동시 실행 시 cores 공유하면 predict spike (20-28ms) 클러스터 발생
- **해결:** CPU isolation: Python cores 2-5 (os.sched_setaffinity), C++ cores 6-7 (taskset -c 6,7), system 0-1. sudo chrt -r 50으로 RT priority 추가 가능
- **해결일:** 2026-04-18

### [SOLVED] cv2.imshow 있는 sagittal display 켜면 Python perception FPS 74→42Hz 반토막
- **해결:** 실험 중엔 반드시 --no-display. X11 렌더 + waitKey 블록 + GPU 경합 누적. 디버깅 전용
- **해결일:** 2026-04-18

### [high] CUDA_Stream publisher 재시작 시마다 HARD LIMIT 위반율이 0.05% → 60%+로 악화
- **상태:** 미해결
- **컨텍스트:** 2026-04-19 CUDA_Stream track — Argus IPC 파일(root 소유)이 /dev/shm에 누적되어 카메라 초기화 경로가 점진적으로 느려짐
- **기록일:** 2026-04-18

### [medium] sudo chrt로 RT priority 올리면 torch ModuleNotFoundError (user env 소실)
- **상태:** 미해결
- **컨텍스트:** 2026-04-19 sudo가 root env로 전환하여 user의 pip 패키지 경로 접근 불가
- **기록일:** 2026-04-18

## Related
- [[h-walker]]
- [[exosuit-safety]]
- [[ak60-motor]]
- [[realtime-pose-estimation]]
- [[can-communication]]
- [[admittance-control]]
