# Graph Report - research-vault  (2026-04-23)

## Corpus Check
- 90 files · ~58,368 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 714 nodes · 867 edges · 67 communities detected
- Extraction: 87% EXTRACTED · 13% INFERRED · 0% AMBIGUOUS · INFERRED: 115 edges (avg confidence: 0.79)
- Token cost: 27,247 input · 11,856 output

## Community Hubs (Navigation)
- [[_COMMUNITY_Realtime Pose Pipeline (Skiro)|Realtime Pose Pipeline (Skiro)]]
- [[_COMMUNITY_Camera Stream & 3D Projection|Camera Stream & 3D Projection]]
- [[_COMMUNITY_CUDA Stream Architecture|CUDA Stream Architecture]]
- [[_COMMUNITY_Exosuit Assistance & Grants|Exosuit Assistance & Grants]]
- [[_COMMUNITY_Motor Control & Admittance|Motor Control & Admittance]]
- [[_COMMUNITY_Perception Safety Chain|Perception Safety Chain]]
- [[_COMMUNITY_Exosuit Hardware Stack|Exosuit Hardware Stack]]
- [[_COMMUNITY_Knowledge Graph & LLM Wiki|Knowledge Graph & LLM Wiki]]
- [[_COMMUNITY_H-Walker LLM Fine-tuning|H-Walker LLM Fine-tuning]]
- [[_COMMUNITY_0xHenry Dev Identity|0xHenry Dev Identity]]
- [[_COMMUNITY_CAN Bus & Motor Drivers|CAN Bus & Motor Drivers]]
- [[_COMMUNITY_Biomechanical Walking Model|Biomechanical Walking Model]]
- [[_COMMUNITY_Gait Analysis & Assessment|Gait Analysis & Assessment]]
- [[_COMMUNITY_Assistive Vector Treadmill|Assistive Vector Treadmill]]
- [[_COMMUNITY_Graph App & Stride Analysis|Graph App & Stride Analysis]]
- [[_COMMUNITY_Gemma4 & LoRA Fine-tuning|Gemma4 & LoRA Fine-tuning]]
- [[_COMMUNITY_Cable-Driven Motor Selection|Cable-Driven Motor Selection]]
- [[_COMMUNITY_4-Stage CUDA Pipeline|4-Stage CUDA Pipeline]]
- [[_COMMUNITY_Hip Power & Cable Force|Hip Power & Cable Force]]
- [[_COMMUNITY_Stroke Gait Experiment|Stroke Gait Experiment]]
- [[_COMMUNITY_Graphify & RL Concepts|Graphify & RL Concepts]]
- [[_COMMUNITY_Regenerative Energy Protection|Regenerative Energy Protection]]
- [[_COMMUNITY_Wiki Template System|Wiki Template System]]
- [[_COMMUNITY_Vault Meta & Index|Vault Meta & Index]]
- [[_COMMUNITY_GPU Model Lightweighting|GPU Model Lightweighting]]
- [[_COMMUNITY_Graph App Analysis Features|Graph App Analysis Features]]
- [[_COMMUNITY_Pipeline Optimization Phases|Pipeline Optimization Phases]]
- [[_COMMUNITY_ZED & Depth Rejections|ZED & Depth Rejections]]
- [[_COMMUNITY_2D Keypoint Depth Coupling|2D Keypoint Depth Coupling]]
- [[_COMMUNITY_Latency Benchmarks|Latency Benchmarks]]
- [[_COMMUNITY_Graph App UI Features|Graph App UI Features]]
- [[_COMMUNITY_Antigravity ADK Stack|Antigravity ADK Stack]]
- [[_COMMUNITY_Jetson Baseline Perf|Jetson Baseline Perf]]
- [[_COMMUNITY_RL Gait Sim2Real|RL Gait Sim2Real]]
- [[_COMMUNITY_Phase 3 Perf Metrics|Phase 3 Perf Metrics]]
- [[_COMMUNITY_GDM & Neural Depth|GDM & Neural Depth]]
- [[_COMMUNITY_CUDA Stream Feature Branch|CUDA Stream Feature Branch]]
- [[_COMMUNITY_P99 Hard Limit|P99 Hard Limit]]
- [[_COMMUNITY_Determinism & Watchdog|Determinism & Watchdog]]
- [[_COMMUNITY_Obsidian & Claude Rules|Obsidian & Claude Rules]]
- [[_COMMUNITY_Paper & Raw Templates|Paper & Raw Templates]]
- [[_COMMUNITY_LLM Eval & Regression CI|LLM Eval & Regression CI]]
- [[_COMMUNITY_Optimizer|Optimizer]]
- [[_COMMUNITY_JetPack Software|JetPack Software]]
- [[_COMMUNITY_YOLO11s Pose Model|YOLO11s Pose Model]]
- [[_COMMUNITY_YOLO8n Pose Model|YOLO8n Pose Model]]
- [[_COMMUNITY_MediaPipe Model|MediaPipe Model]]
- [[_COMMUNITY_RTMPose Lightweight|RTMPose Lightweight]]
- [[_COMMUNITY_Perception Pipeline Wrap-up|Perception Pipeline Wrap-up]]
- [[_COMMUNITY_Standing Calibration|Standing Calibration]]
- [[_COMMUNITY_Bone Length Stability|Bone Length Stability]]
- [[_COMMUNITY_CUDA Stream Handover|CUDA Stream Handover]]
- [[_COMMUNITY_Final Handover 2026-04-21|Final Handover 2026-04-21]]
- [[_COMMUNITY_Full Journey Summary|Full Journey Summary]]
- [[_COMMUNITY_Obsidian Sync Setup|Obsidian Sync Setup]]
- [[_COMMUNITY_Treadmill Firmware|Treadmill Firmware]]
- [[_COMMUNITY_Vault CMake Rules|Vault CMake Rules]]
- [[_COMMUNITY_Session Log|Session Log]]
- [[_COMMUNITY_Antigravity Models|Antigravity Models]]
- [[_COMMUNITY_H-Walker Platform|H-Walker Platform]]
- [[_COMMUNITY_CAN Communication Bus|CAN Communication Bus]]
- [[_COMMUNITY_EBIMU IMU Sensor|EBIMU IMU Sensor]]
- [[_COMMUNITY_Elmo SoloTwitter|Elmo Solo/Twitter]]
- [[_COMMUNITY_Elmo Whistle|Elmo Whistle]]
- [[_COMMUNITY_Exosuit Hardware Stack|Exosuit Hardware Stack]]
- [[_COMMUNITY_EBIMU V5|EBIMU V5]]
- [[_COMMUNITY_Elmo CANopen|Elmo CANopen]]

## God Nodes (most connected - your core abstractions)
1. `H-Walker Realtime Vision Control` - 33 edges
2. `Lessons (RL-loop Memory)` - 23 edges
3. `Jetson Orin NX 16GB Edge SBC` - 22 edges
4. `H-Walker Platform` - 19 edges
5. `Exosuit Hardware Overview` - 17 edges
6. `H-Walker Research Context` - 15 edges
7. `AK60 Motor (CAN bus, 70N max cable force)` - 15 edges
8. `P0 Track Completion Report - Mainline H-Walker Real-time Safety (2026-04-18)` - 15 edges
9. `CUDA Stream 4-Stage Overlapped Pipeline` - 14 edges
10. `Real-time Pose Estimation` - 14 edges

## Surprising Connections (you probably didn't know these)
- `MediaPipe BlazePose` --conceptually_related_to--> `Jetson Orin NX 16GB Edge SBC`  [INFERRED]
  10_Wiki/perception/perception-evolution-master.md → realtime-vision-control/research_context.md
- `Jetson Orin NX 16GB Edge SBC` --conceptually_related_to--> `h-walker Exosuit Project`  [INFERRED]
  realtime-vision-control/research_context.md → 10_Wiki/exosuit/ak60-motor.md
- `MIT Mode CAN Protocol` --implements--> `AK60 Motor (CAN bus, 70N max cable force)`  [INFERRED]
  10_Wiki/exosuit/can-communication.md → realtime-vision-control/research_context.md
- `Servo Mode CAN Protocol` --implements--> `AK60 Motor (CAN bus, 70N max cable force)`  [INFERRED]
  10_Wiki/exosuit/can-communication.md → realtime-vision-control/research_context.md
- `Teensy 4.1 MCU (111 Hz inner loop)` --conceptually_related_to--> `AK60 Motor Benchmark Testbed`  [INFERRED]
  realtime-vision-control/research_context.md → 10_Wiki/exosuit/motor-benchmark.md

## Hyperedges (group relationships)
- **H-Walker Hardware-Software Integration** — h_walker, cable_driven_exosuit, h_walker_graph_app, h_walker_5090_finetuning_guide [INFERRED 0.80]
- **LLM Fine-tuning Complete Pipeline** — gemma4_llm, unsloth, lora_finetuning, gguf_conversion, ollama_deployment [EXTRACTED 0.90]
- **Cable-Driven Exosuit Force Control System** — cable_driven_exosuit, capstan_equation, pid_control, ft_sensor [INFERRED 0.85]
- **Complete LLM Training & Deployment Pipeline** — DataAugmentation_Script, BuildDataset_Script, LoRA_Training_Script, GGUF_Conversion_Script, Ollama_Integration [EXTRACTED 1.00]
- **LLM Quality Improvement System (Phase 1)** — Intent_Classifier, AnalysisRequest_Generator, Feedback_Detector, SessionState_Manager, LLM_Eval_Framework [EXTRACTED 1.00]
- **H-Walker Graph App Analysis Feature Suite** — Force_Analysis, GaitAnalysis_Feature, IMU_Analysis, ComparisonMode, GCP_Normalization [EXTRACTED 1.00]
- **H-Walker Graph App Rendering Pipeline** — analysis_engine_stride_detection, graph_quick_plotly, graph_publication_svg [EXTRACTED 1.00]
- **LLM Domain Knowledge Injection Pipeline** — llm_client_service, knowledge_loader_service, h_walker_korean_terminology [EXTRACTED 1.00]
- **Gait Cycle Normalization & Analysis** — heel_strike_detection_gcp, gcp_normalization_resampling, gcp_gait_cycle_percentage [EXTRACTED 0.95]
- **Knowledge Management Tools Ecosystem** — hub_llm_wiki, hub_p_reinforce, hub_obsidian, hub_graphify [INFERRED 0.80]
- **AI Tools and Models** — hub_antigravity, hub_gemma4, antigravity_supported_models [INFERRED 0.80]
- **0xHenry Development Context** — 0xhenry_0xhenry_dev, 0xhenry_exosuit, 0xhenry_h_walker [EXTRACTED 1.00]
- **Knowledge Management Ecosystem (LLM Wiki → Graphify)** — llm_wiki_concept, graphify_tool, llm_wiki_token_efficiency [INFERRED 0.75]
- **Gemma 4 Model Family** — gemma4_e2b_variant, gemma4_e4b_variant, gemma4_26b_moe_variant, gemma4_31b_dense_variant [EXTRACTED 1.00]
- **Cable-Driven vs Direct-Drive Trade-off (Portability vs Precision)** — cable_driven_mechanism, cable_driven_advantages, cable_driven_disadvantages [EXTRACTED 1.00]
- **Motor→Driver→Battery Selection Chain** — motor_selection_blocker, elmo_twitter_driver_detail, battery_voltage_options [EXTRACTED 1.00]
- **Multi-Layer Hardware Protection System** — bulk_capacitor_11280uf, braking_resistor_3ohm, iso1050_can_isolation, tvs_diode_600w, preemptive_derating [EXTRACTED 1.00]
- **Confirmed Hardware Component Stack** — stm32h743_confirmed, jetson_orin_nx_16gb, ebimu_imu_confirmed, zed_x_mini_camera [EXTRACTED 1.00]
- **h-walker Embedded Control Stack** — teensy_4_1_mcu, ebmotion_v5_product, ak60_motor, can_communication [INFERRED 0.85]
- **Motor Driver Selection Decision Tree** — elmo_gold_twitter, elmo_gold_solo_twitter, elmo_gold_whistle [EXTRACTED 0.95]
- **Exosuit Real-Time Sensor Integration** — teensy_4_1_mcu, ebmotion_v5_product, ebimu_9dofv6_wired [INFERRED 0.75]
- **Exosuit Hardware Control Stack** — teensy_4_1, ak60_motor, can_communication, teensy_inner_loop [INFERRED 0.85]
- **Critical Safety Vulnerabilities** — bus_voltage_overshoot, ap62200wu_regulator, emergency_stop_system, communication_timeout_monitoring [EXTRACTED 0.90]
- **H-Walker Bimodal Environment Support** — h_walker, treadmill_environment, overground_environment [EXTRACTED 0.95]
- **Exosuit Control Loop Stack (Admittance → Motor → Feedback)** — admittance_control, ak60_6_motor, force_sensor_feedback, admittance_mit_mode_formula [INFERRED 0.80]
- **Exosuit Hardware Integration (MCU → Driver → Motor)** — stm32h743, elmo_gold_twitter, ak60_6_motor, canopen_communication [INFERRED 0.75]
- **Regenerative Energy Mitigation Strategies** — ak60_regenerative_braking_hazard, bulk_capacitor_mitigation, braking_resistor_mitigation, iso1050_isolated_can_transceiver [EXTRACTED 1.00]
- **Exosuit Motor Selection Evaluation** — motor_selection_exosuit, tmotor_u8_lite_kv85, cubemars_ri60_kv120, maxon_ec_i_40_70w [EXTRACTED 1.00]
- **Realtime Vision-Based Perception Pipeline** — realtime_vision_control_project, zed_x_mini_camera, jetson_orin_nx, vision_pipeline_cuda [EXTRACTED 1.00]
- **Stroke Gait Experiment Outcome Metrics** — gait_symmetry_index, gait_speed_measure, cable_peak_assist_force [EXTRACTED 1.00]
- **Core Perception Pipeline (H-Walker)** — realtime_pose_estimation, zed_x_mini_camera, yolo26s_lower6_v2, pipelined_camera, direct_trt, tensorrt_fp16 [EXTRACTED 0.95]
- **ZED Depth Mode Selection Trade-offs** — zed_depth_mode_performance, zed_depth_mode_neural, yolo26s_lower6_v2, tensorrt_fp16 [EXTRACTED 0.90]
- **Pose Library Selection Process** — mediapipe_blazepose, openpose_library, movenet_library, yolov8_pose, yolo26s_lower6_v2 [EXTRACTED 0.95]
- **Realtime Hard Limit Achievement Stack** — cuda_stream_pipeline, gc_disable_optimization, cpu_affinity_isolation, sched_fifo_priority, 20ms_hard_limit [EXTRACTED 0.90]
- **Wheeled Walker as Gait Intervention** — wheeled_walker, spatiotemporal_gait_parameters, sagittal_gait_parameters, risk_of_falling [EXTRACTED 1.00]
- **Jetson Orin Perception and Control Stack** — jetson_orin_nx, zed_x_mini, zed_link_duo, stm32h743, ebimu_v5, jetpack_6 [EXTRACTED 1.00]
- **Comprehensive Gait and Mobility Assessment Battery** — functional_mobility_assessment, mmse_test, falls_efficacy_scale, poma_test, tug_test, barthel_index [EXTRACTED 1.00]

## Communities

### Community 0 - "Realtime Pose Pipeline (Skiro)"
Cohesion: 0.04
Nodes (67): Argus IPC Cleanup, Bone Length Constraint, Category 5: Contention Removal, C++ Control + Teensy Integration, C++ Watchdog Timer (0.2s), CPU Isolation (taskset + affinity), CUDA Stream Architecture Document, CUDA Stream Perception Pipeline (+59 more)

### Community 1 - "Camera Stream & 3D Projection"
Cohesion: 0.06
Nodes (47): AsyncCamera (Deprecated), BoneLengthConstraint (3D Bone Length Validation), BoneLengthConstraint Module, C++ batch_2d_to_3d Pybind11, CPU Affinity Isolation (Python cores 2-5, C++ cores 6-7), CUDA_Stream Stable Baseline (2026-04-21), CUDA_Stream Optimization Track (Spike Reduction), Depth copy=False race condition (+39 more)

### Community 2 - "CUDA Stream Architecture"
Cohesion: 0.06
Nodes (39): Watchdog Stream Pause/Resume, Decision: Method B IMU World Frame, Decision: Track A Mainline (Python+C++), 3-Stage Pipeline Architecture, Evolution: CUDA_Stream p99 Spike 22-25→19.8ms, Evolution: Python Latency 33.4→13.7ms (9 steps), Evolution: Library Comparison & Selection, 12 Model E2E Benchmark Comparison (+31 more)

### Community 3 - "Exosuit Assistance & Grants"
Cohesion: 0.06
Nodes (39): 2026 범부처 보행재활로봇 과제, 3D 보조력 전달 연구, Bowden Cable, Cable-Driven Advantages (remote placement, lightweight, flexible routing), Cable-Driven Disadvantages (friction, hysteresis, nonlinearity, fatigue), Cable-Driven Exosuit, Exosuit Cable-Driven Application (Hip/Knee actuation), Cable-Driven Mechanism (+31 more)

### Community 4 - "Motor Control & Admittance"
Cohesion: 0.06
Nodes (38): Admittance Control, MIT Mode Torque Formula (Admittance), AK60-6 BLDC Motor, AK60-6 CAN Bus 1Mbps, AK60-6 KV80 Variant, AK60-6 Planetary Gearbox (6.0 ratio), AK60-6 Regenerative Braking Hazard, Antigravity Config (Gemma 4 E4B local setup) (+30 more)

### Community 5 - "Perception Safety Chain"
Cohesion: 0.07
Nodes (35): 20ms HARD LIMIT, 3D EMA Smoothing, Bone Constraint (P0-3), CUDA_Stream 3-stage Pipeline, DirectTRT (TensorRT GPU Inference Engine), Gait Analysis, Heel Strike (HS), Toe Off (TO) (+27 more)

### Community 6 - "Exosuit Hardware Stack"
Cohesion: 0.08
Nodes (35): ADS1234 24-bit 4ch ADC, AK60 Motor (CAN bus, 70N max cable force), AP62200WU Regulator, Assistive Force Vector Control (Direction & Magnitude), Assistive Vector Treadmill Research Topic Definition, 26.5V Braking Resistor, 11,280uF Bulk Capacitor, Bus Voltage Overshoot (143V) (+27 more)

### Community 7 - "Knowledge Graph & LLM Wiki"
Cohesion: 0.08
Nodes (32): Graphify, LLM Wiki, RL-loop (Reinforcement Learning Loop), Graphify query interface with RL-loop memory, Graphify Setup, Lessons (RL-loop Memory), Miss: Unverified alias causes broken links, Miss: Misunderstanding of sync.sh branch handling (+24 more)

### Community 8 - "H-Walker LLM Fine-tuning"
Cohesion: 0.08
Nodes (30): AnalysisRequest Generator, Build Dataset (build_dataset.py), Configuration Centralization (config.py), Continuous Learning Feedback Loop, Data Augmentation (augment.py), Dataset JSONL Format (training data), Domain Knowledge Base (h-walker-graph-app-knowledge.md), Feedback Detector (Natural Language) (+22 more)

### Community 9 - "0xHenry Dev Identity"
Cohesion: 0.1
Nodes (29): 0xHenry Dev, 0xHenry Blog, Exosuit Project, H-Walker Project, Agent-First Architecture, Agent Skills, Antigravity IDE, Claude Opus 4.6 (+21 more)

### Community 10 - "CAN Bus & Motor Drivers"
Cohesion: 0.08
Nodes (29): AS5047P Position Encoder (U8 Lite variant), Battery Voltage Options (24V vs 48V), Battery Voltage vs Performance (24V vs 48V), CANopen CiA 402 Stack (CANopenNode), CANopen CST Protocol (500Hz), Critical Issue C1: Buck Converter VIN (→TPS54560B), CubeMars RI60 KV120 (Motor Candidate #2), CubeMars RI60 KV120 (Secondary Choice) (+21 more)

### Community 11 - "Biomechanical Walking Model"
Cohesion: 0.08
Nodes (28): Biomechanical Walking Model Session Handover, Brunner & Rutz (2013) - Hip Moment Transition, cable_force_mapping.py - Jacobian-based Force to Torque, Cable Velocity Decomposition (P_thigh + P_shank), Euler-Lagrange Equation for 3-Link Model, Force Profile Timing Justification Document, Winter 2009 Gait Reference (Fourier Trajectory Model), Hip Moment Flexion-to-Extension Transition (+20 more)

### Community 12 - "Gait Analysis & Assessment"
Cohesion: 0.1
Nodes (26): Barthel Index for Activities of Daily Living, Double Support Time Variability, eGAIT (Embedded Gait Analysis System), Falls Efficacy Scale International (FES-I), FTU (First Time Wheeled Walker Users), FU (Frequent Wheeled Walker Users), Functional Mobility Assessment Battery, Instrumented Gait Analysis via Mobile Gait Analysis System (+18 more)

### Community 13 - "Assistive Vector Treadmill"
Cohesion: 0.09
Nodes (24): Assistive Vector Treadmill, H-Walker Research Context, 3D Assistance, Admittance Control, Cable-Driven Mechanism, CAN Communication, Gait Analysis, Real-time Pose Estimation (+16 more)

### Community 14 - "Graph App & Stride Analysis"
Cohesion: 0.13
Nodes (23): Admittance Control - KP/KD Tuning, analysis_engine.py - Heel Strike & Stride Detection, H-Walker CSV Schema (60 cols @ 111Hz), Plot Style Rules: Des=dashed, Act=solid, GCP - Gait Cycle Percentage Signal, GCP-based Signal Normalization & Resampling, graph_publication.py - SVG Publication Rendering, graph_quick.py - Plotly Interactive Rendering (+15 more)

### Community 15 - "Gemma4 & LoRA Fine-tuning"
Cohesion: 0.13
Nodes (19): Gemma4 LLM Model, GGUF Model Conversion, H-Walker 5090 Fine-tuning Setup Guide, H-Walker AI Hub, H-Walker Graph App, H-Walker Graph App Knowledge Base, H-Walker Graph App LLM Plotting Validation, H-Walker Graph App Usage Guide (+11 more)

### Community 16 - "Cable-Driven Motor Selection"
Cohesion: 0.11
Nodes (19): Cable-Driven External Force Assistance, Cable Force from Torque and Moment Arm, Required Continuous Current Calculation Task, CubeMars RI60 KV120 (0.080 Nm/A, 180g), Exosuit Board Handoff Documentation, Exosuit Hub (Domain Node), FreeRTOS for STM32H7, GND Bounce Board Failure (4x Motor Release) (+11 more)

### Community 17 - "4-Stage CUDA Pipeline"
Cohesion: 0.12
Nodes (18): CUDA Stream 4-Stage Overlapped Pipeline, Capture Stream (ZED H2D), Constraint Gate (Bone Length + Velocity), Infer Stream (TRT high-priority), launch_clean.sh (Argus IPC + RT Scheduler), Post Stream (3D+Median+D2H), Preproc Stream (Letterbox+Normalize), Decision: Track B CUDA_Stream (20ms Guarantee) (+10 more)

### Community 18 - "Hip Power & Cable Force"
Cohesion: 0.18
Nodes (15): Cable Force Mapping, Hip Power (H3) Burst, 3x3 Factorial Design Required, Anchor Height Effects on Torque, Assistance Window 60-85% GCP, Force Profile Derived from Torque, Shank Attachment is Optimal, Three-Link Dynamics Model (+7 more)

### Community 19 - "Stroke Gait Experiment"
Cohesion: 0.27
Nodes (11): 결론 (Conclusion), 환경 (Environment), 방법 (Method), 다음 액션 (Next Actions), 목적 (Objective), 결과 (Results), Experiment Template, 액션 아이템 (Action Items) (+3 more)

### Community 20 - "Graphify & RL Concepts"
Cohesion: 0.27
Nodes (10): Andrej Karpathy, 2-Hop Neighborhood Extraction, Adoption Gate (100+ notes), Graph-Based Extension Pattern, Graphify, LLM Wiki, Three-Layer Architecture (raw/wiki/schema), Three Core Tasks (ingest/query/lint) (+2 more)

### Community 21 - "Regenerative Energy Protection"
Cohesion: 0.2
Nodes (10): Braking Resistor 3Ω/50W, Bulk Capacitor 11,280μF, Critical Issue C7: CAN GND Bounce (→ISO1050), Back-EMF Voltage Spike Problem (24V→140V+), 5-Layer Defense Architecture, Health Monitoring via CAN Error Counter, ISO1050 Isolated CAN (5000Vrms), Preemptive Derating (26.0V Threshold) (+2 more)

### Community 22 - "Wiki Template System"
Cohesion: 0.33
Nodes (9): Knowledge Connections, Core Content, Brief Summary, Wiki Concept Template, 동작 원리 (Operating Principle), 프로젝트 적용 맥락 (Project Application Context), 참고 링크 (References), Spec (공식 출처) (+1 more)

### Community 23 - "Vault Meta & Index"
Cohesion: 0.25
Nodes (8): Wiki Index (MOC), Assistive Vector Treadmill, Realtime Vision Control, Wiki Category: Concepts, Wiki Category: Exosuit, Wiki Category: Grants, Wiki Category: H-Walker AI, Wiki Category: Perception

### Community 24 - "GPU Model Lightweighting"
Cohesion: 0.4
Nodes (5): BGRA Pass-through (color conversion), GPU Output Parsing (top-1 only), Head Keypoint Reduction 17kpt → 6kpt, Category 1: Model Lightweighting, YOLO26s-Lower6 Model

### Community 25 - "Graph App Analysis Features"
Cohesion: 0.4
Nodes (5): Comparison Mode (Multi-Trial Analysis), Force Analysis (Des/Act), Gait Cycle Phase (GCP) Normalization, Gait Analysis Feature, IMU Data Analysis (Pitch/Roll/Yaw)

### Community 26 - "Pipeline Optimization Phases"
Cohesion: 0.5
Nodes (4): Phase 2: TRT Engine + Stream Infrastructure, Phase 3: ZED Zero-Copy + GPU Pre/Post-Processing, Phase 4: Pipeline Overlap + CUDA Graph + INT8, Phase 5: Realtime Control Integration & Safety

### Community 27 - "ZED & Depth Rejections"
Cohesion: 0.67
Nodes (3): Lesson: ZED SDK is Thread-Unsafe, Rejected: GDM Disable (Segfault+Lockup), Rejected: Zero-Copy Depth (Race Condition)

### Community 28 - "2D Keypoint Depth Coupling"
Cohesion: 0.67
Nodes (3): Lesson: 2D Keypoints Affect Depth, Rejected: EMA on 2D Keypoints (Depth NaN), Rejected: One Euro Filter (2D keypoint collision)

### Community 29 - "Latency Benchmarks"
Cohesion: 0.67
Nodes (3): Final Latency 13.7ms (3.24× improvement), Initial Latency 44.4ms, p99 Latency 17ms (stable)

### Community 30 - "Graph App UI Features"
Cohesion: 0.67
Nodes (3): Sagittal Viewer Auto-fit, Walking-Direction Auto-Calibration, Warmup Skip Frames = 30

### Community 31 - "Antigravity ADK Stack"
Cohesion: 0.67
Nodes (3): Agent Development Kit (ADK), Local Model Support, Ollama

### Community 32 - "Jetson Baseline Perf"
Cohesion: 1.0
Nodes (2): Jetson Baseline Performance, Phase 1: Environment & Measurement

### Community 33 - "RL Gait Sim2Real"
Cohesion: 1.0
Nodes (2): RL Policy Control, RL Sim-to-Real Gait Policy Paper

### Community 34 - "Phase 3 Perf Metrics"
Cohesion: 1.0
Nodes (2): Phase 3: FPS 30→73Hz (2.43× improvement), Phase 3: Mean Latency 33.4→13.7ms

### Community 35 - "GDM & Neural Depth"
Cohesion: 1.0
Nodes (2): GDM Off FATAL Failure (GMSL segfault), NEURAL Depth Mode Rejection

### Community 36 - "CUDA Stream Feature Branch"
Cohesion: 1.0
Nodes (2): control Branch (mainline), feature/cuda-stream-perception Branch

### Community 37 - "P99 Hard Limit"
Cohesion: 1.0
Nodes (2): HARD LIMIT Violation 0.031%, p99 Latency 15.1ms (CUDA_Stream)

### Community 38 - "Determinism & Watchdog"
Cohesion: 1.0
Nodes (1): Watchdog Pause/Resume During Graph Capture

### Community 39 - "Obsidian & Claude Rules"
Cohesion: 1.0
Nodes (2): Claude Rules - Research Vault, Obsidian Git Auto-Sync (10min intervals)

### Community 40 - "Paper & Raw Templates"
Cohesion: 1.0
Nodes (2): Paper Reference Template, Raw Paper Template

### Community 41 - "LLM Eval & Regression CI"
Cohesion: 1.0
Nodes (2): LLM Evaluation Framework (100 test cases), Regression Testing (check_regression.py)

### Community 42 - "Optimizer"
Cohesion: 1.0
Nodes (1): optimizer.py - Parameter Sweep Analysis

### Community 43 - "JetPack Software"
Cohesion: 1.0
Nodes (1): JetPack (Nvidia)

### Community 44 - "YOLO11s Pose Model"
Cohesion: 1.0
Nodes (1): YOLO11s-Pose

### Community 45 - "YOLO8n Pose Model"
Cohesion: 1.0
Nodes (1): YOLOv8n-Pose

### Community 46 - "MediaPipe Model"
Cohesion: 1.0
Nodes (1): MediaPipe Pose

### Community 47 - "RTMPose Lightweight"
Cohesion: 1.0
Nodes (1): RTMPose Lightweight

### Community 48 - "Perception Pipeline Wrap-up"
Cohesion: 1.0
Nodes (1): Perception Pipeline Wrap-Up

### Community 49 - "Standing Calibration"
Cohesion: 1.0
Nodes (1): Method A: Standing Calibration

### Community 50 - "Bone Length Stability"
Cohesion: 1.0
Nodes (1): Bone Length Stability Logging

### Community 51 - "CUDA Stream Handover"
Cohesion: 1.0
Nodes (1): CUDA_Stream Perception Handover

### Community 52 - "Final Handover 2026-04-21"
Cohesion: 1.0
Nodes (1): Final Handover 2026-04-21

### Community 53 - "Full Journey Summary"
Cohesion: 1.0
Nodes (1): Full Journey Summary Document

### Community 54 - "Obsidian Sync Setup"
Cohesion: 1.0
Nodes (1): Obsidian Git Sync Setup

### Community 55 - "Treadmill Firmware"
Cohesion: 1.0
Nodes (1): Teensy Treadmill Firmware

### Community 56 - "Vault CMake Rules"
Cohesion: 1.0
Nodes (1): Vault Operations Rules (wikilink, naming, git)

### Community 57 - "Session Log"
Cohesion: 1.0
Nodes (1): Work Log

### Community 58 - "Antigravity Models"
Cohesion: 1.0
Nodes (1): Supported Models

### Community 59 - "H-Walker Platform"
Cohesion: 1.0
Nodes (1): H-Walker Prototype Platform

### Community 60 - "CAN Communication Bus"
Cohesion: 1.0
Nodes (1): CAN Bus Communication

### Community 61 - "EBIMU IMU Sensor"
Cohesion: 1.0
Nodes (1): EBIMU IMU Sensor

### Community 62 - "Elmo Solo/Twitter"
Cohesion: 1.0
Nodes (1): Elmo Gold Solo Twitter 70A

### Community 63 - "Elmo Whistle"
Cohesion: 1.0
Nodes (1): Elmo Gold Whistle 20A

### Community 64 - "Exosuit Hardware Stack"
Cohesion: 1.0
Nodes (1): Exosuit Hardware Stack

### Community 65 - "EBIMU V5"
Cohesion: 1.0
Nodes (1): EBIMU V5 IMU Receiver

### Community 66 - "Elmo CANopen"
Cohesion: 1.0
Nodes (1): Elmo CANopen Motor Driver

## Knowledge Gaps
- **362 isolated node(s):** `ZED X Mini Camera`, `Cable-Driven Mechanism`, `Admittance Control`, `Real-time Pose Estimation`, `Gait Analysis` (+357 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **Thin community `Jetson Baseline Perf`** (2 nodes): `Jetson Baseline Performance`, `Phase 1: Environment & Measurement`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `RL Gait Sim2Real`** (2 nodes): `RL Policy Control`, `RL Sim-to-Real Gait Policy Paper`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Phase 3 Perf Metrics`** (2 nodes): `Phase 3: FPS 30→73Hz (2.43× improvement)`, `Phase 3: Mean Latency 33.4→13.7ms`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `GDM & Neural Depth`** (2 nodes): `GDM Off FATAL Failure (GMSL segfault)`, `NEURAL Depth Mode Rejection`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `CUDA Stream Feature Branch`** (2 nodes): `control Branch (mainline)`, `feature/cuda-stream-perception Branch`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `P99 Hard Limit`** (2 nodes): `HARD LIMIT Violation 0.031%`, `p99 Latency 15.1ms (CUDA_Stream)`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Determinism & Watchdog`** (2 nodes): `Non-Determinism Root Cause: Watchdog Stream.query()`, `Watchdog Pause/Resume During Graph Capture`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Obsidian & Claude Rules`** (2 nodes): `Claude Rules - Research Vault`, `Obsidian Git Auto-Sync (10min intervals)`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Paper & Raw Templates`** (2 nodes): `Paper Reference Template`, `Raw Paper Template`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `LLM Eval & Regression CI`** (2 nodes): `LLM Evaluation Framework (100 test cases)`, `Regression Testing (check_regression.py)`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Optimizer`** (1 nodes): `optimizer.py - Parameter Sweep Analysis`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `JetPack Software`** (1 nodes): `JetPack (Nvidia)`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `YOLO11s Pose Model`** (1 nodes): `YOLO11s-Pose`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `YOLO8n Pose Model`** (1 nodes): `YOLOv8n-Pose`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `MediaPipe Model`** (1 nodes): `MediaPipe Pose`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `RTMPose Lightweight`** (1 nodes): `RTMPose Lightweight`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Perception Pipeline Wrap-up`** (1 nodes): `Perception Pipeline Wrap-Up`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Standing Calibration`** (1 nodes): `Method A: Standing Calibration`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Bone Length Stability`** (1 nodes): `Bone Length Stability Logging`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `CUDA Stream Handover`** (1 nodes): `CUDA_Stream Perception Handover`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Final Handover 2026-04-21`** (1 nodes): `Final Handover 2026-04-21`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Full Journey Summary`** (1 nodes): `Full Journey Summary Document`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Obsidian Sync Setup`** (1 nodes): `Obsidian Git Sync Setup`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Treadmill Firmware`** (1 nodes): `Teensy Treadmill Firmware`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Vault CMake Rules`** (1 nodes): `Vault Operations Rules (wikilink, naming, git)`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Session Log`** (1 nodes): `Work Log`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Antigravity Models`** (1 nodes): `Supported Models`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `H-Walker Platform`** (1 nodes): `H-Walker Prototype Platform`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `CAN Communication Bus`** (1 nodes): `CAN Bus Communication`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `EBIMU IMU Sensor`** (1 nodes): `EBIMU IMU Sensor`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Elmo Solo/Twitter`** (1 nodes): `Elmo Gold Solo Twitter 70A`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Elmo Whistle`** (1 nodes): `Elmo Gold Whistle 20A`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Exosuit Hardware Stack`** (1 nodes): `Exosuit Hardware Stack`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `EBIMU V5`** (1 nodes): `EBIMU V5 IMU Receiver`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Elmo CANopen`** (1 nodes): `Elmo CANopen Motor Driver`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `H-Walker Realtime Vision Control` connect `Realtime Pose Pipeline (Skiro)` to `CUDA Stream Architecture`, `Exosuit Assistance & Grants`, `Perception Safety Chain`, `Exosuit Hardware Stack`?**
  _High betweenness centrality (0.099) - this node is a cross-community bridge._
- **Why does `Jetson Orin NX 16GB Edge SBC` connect `Realtime Pose Pipeline (Skiro)` to `Camera Stream & 3D Projection`, `Exosuit Assistance & Grants`, `Motor Control & Admittance`, `Perception Safety Chain`, `Biomechanical Walking Model`?**
  _High betweenness centrality (0.066) - this node is a cross-community bridge._
- **Why does `AK60 Motor (CAN bus, 70N max cable force)` connect `Exosuit Hardware Stack` to `Realtime Pose Pipeline (Skiro)`, `Camera Stream & 3D Projection`, `Exosuit Assistance & Grants`, `Motor Control & Admittance`, `Perception Safety Chain`?**
  _High betweenness centrality (0.057) - this node is a cross-community bridge._
- **Are the 5 inferred relationships involving `Jetson Orin NX 16GB Edge SBC` (e.g. with `launch_clean.sh Script` and `CUDA-Stream Vision Pipeline`) actually correct?**
  _`Jetson Orin NX 16GB Edge SBC` has 5 INFERRED edges - model-reasoned connections that need verification._
- **What connects `ZED X Mini Camera`, `Cable-Driven Mechanism`, `Admittance Control` to the rest of the system?**
  _362 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Realtime Pose Pipeline (Skiro)` be split into smaller, more focused modules?**
  _Cohesion score 0.04 - nodes in this community are weakly interconnected._
- **Should `Camera Stream & 3D Projection` be split into smaller, more focused modules?**
  _Cohesion score 0.06 - nodes in this community are weakly interconnected._