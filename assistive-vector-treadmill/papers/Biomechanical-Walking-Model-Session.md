# Biomechanical Walking Model — 전체 세션 인수인계

## 세션 요약
3-Link Biomechanical Model 구축부터 Force Profile Timing 근거 도출까지 전 과정.
Cable-driven walker의 실험 설계를 위한 역학 모델과 분석 도구를 만들고 검증했음.

---

## Repository 받기

```bash
cd ~
git clone https://github.com/chobyeongjun/h-walker-ws.git
cd h-walker-ws
git checkout modeling
git pull origin modeling
```

## 실행 환경

```bash
pip install numpy scipy matplotlib sympy

# Mac/Linux
PYTHONPATH=src python <script>

# Windows PowerShell
$env:PYTHONPATH="src"
python <script>
```

---

## 이 세션에서 만든 것들

### 1. 3-Link Biomechanical Model
> 📁 `src/hw_control/biomechanical_model/`

Thigh-Shank-Foot 3-link planar model. Euler-Lagrange로 유도.

**핵심 수식**: $M(\vec{q})\ddot{\vec{q}} + C(\vec{q},\dot{\vec{q}})\dot{\vec{q}} + G(\vec{q}) = \tau$

**Cable mapping**: $\vec{\tau}_{\text{cable}} = J^T \cdot \vec{F}_{\text{cable}}$

**검증 완료**: SymPy 독립 유도, 에너지 보존 (drift=10⁻¹⁶), Coriolis 부호 오류 수정.

### 2. Force Profile Timing 근거
> 📁 `docs/obsidian_notes/Force-Profile-Timing-Justification.md` ★

**Onset**: $t_{\text{onset}}(d) = \max(t_{\text{toe-off}},\; t_{P_{\text{shank}}=0})$
- High=60%, Mid=63%, Low=68%

**Release**: $t_{\text{release}} = 85\%$ (hip moment flex→ext 전환 86.1% 직전)

### 3. Onset Model (P_shank 분해)
> 📁 `src/hw_control/biomechanical_model/onset_model.py`

$$v_{\text{cable}}(t, d) = P_{\text{thigh}}(t) + P_{\text{shank}}(t, d)$$

- P_thigh: thigh 회전 기여 (d 무관)
- P_shank: shank 회전 기여 (d 비례)
- 68% GCP에서 P_shank 부호 전환 (방해→도움)

### 4. Parameter Sweep + Optimizer
> 📁 `src/hw_control/biomechanical_model/optimizer.py`

Force, 부착위치, Anchor위치, 타이밍을 바꿔가며 τ_hip, τ_knee, stride 변화 분석.

### 5. 3×3 Factorial 실험 설계

```
방향 2개: 0° (수평), 30° (대각선)
부착 3개: High (7%), Mid (20%), Low (42% of shank)
+ Baseline = 7조건
```

### 6. LaTeX 문서
> 📁 `docs/latex/three_link_biomechanical_model.tex`

2000줄. 수식 전체 유도 + TikZ 다이어그램. `pdflatex` 2회 빌드.

---

## 파일 가이드

### 코드 (중요도순)

| 파일 | 뭘 하는 파일 | 언제 쓰나 |
|---|---|---|
| `onset_model.py` | ★ Onset/Release 계산 | Force profile timing 결정 |
| `three_link_dynamics.py` | M, C, G 행렬 | 모든 계산의 기반 |
| `cable_force_mapping.py` | Cable → 관절 토크 | τ = J^T·F |
| `optimizer.py` | 파라미터 sweep | 실험 조건 비교 |
| `gait_reference.py` | Winter 2009 보행 궤적 | 역동역학 입력 |
| `anthropometric.py` | 인체 파라미터 | 피험자 설정 |
| `simulation.py` | ODE 시뮬레이션 | 에너지 보존 검증 |
| `force_gait_analysis.py` | Force→Torque→Stride | 시간 도메인 분석 |
| `full_gait_simulation.py` | GCP 0~100% 시각화 | 그림 생성 |
| `verify_geometry.py` | Cable 기하학 검증 | 방향 확인 |
| `run_demo.py` | 전체 데모 | 처음 돌려볼 때 |

### 문서

| 파일 | 내용 | 읽는 시간 |
|---|---|---|
| `README.md` | 프로젝트 전체 구조 | 5분 |
| `docs/obsidian_notes/3-Link-Biomechanical-Model.md` | 모델 전체 요약 | 10분 |
| `docs/obsidian_notes/Force-Profile-Timing-Justification.md` | ★ Onset/Release 근거 | 20분 |
| `docs/HANDOVER.md` | 기술 인수인계서 | 30분 |
| `docs/latex/three_link_biomechanical_model.tex` | 수식 전체 유도 | 필요할 때 |

### 그림 (`docs/figures/`)

| 그림 | 내용 |
|---|---|
| `joint_power_analysis.png` | Hip/Knee/Ankle power (H3, K3, K4) |
| `force_profile_derivation.png` | F = τ/s(q) 유도 과정 |
| `full_gait_0_to_100.png` | GCP 0~100% 다리+cable 20프레임 |
| `force_gait_analysis.png` | Force→Torque→Stride 6-panel |
| `parameter_sweep_results.png` | 4가지 변수 sweep |
| `geometry_verification.png` | Cable 방향 시각 검증 |
| `gait_timeline_with_force.png` | 다리 + 그래프 타임라인 |

---

## 자주 쓰는 명령

```bash
# 전체 데모
PYTHONPATH=src python src/hw_control/biomechanical_model/run_demo.py

# Onset/Release 계산
PYTHONPATH=src python src/hw_control/biomechanical_model/onset_model.py

# 특정 조건 분석
PYTHONPATH=src python -c "
from hw_control.biomechanical_model.optimizer import analyze
import numpy as np
r = analyze(peak_force=50, attach_distance=0.08, frame_point=np.array([0.40, -0.43]))
print(f'τ_hip={r.peak_tau_hip:.1f}, τ_knee={r.peak_tau_knee:.1f}')
"

# 파라미터 전체 sweep
PYTHONPATH=src python src/hw_control/biomechanical_model/optimizer.py

# GCP 0~100% 시뮬레이션
PYTHONPATH=src python src/hw_control/biomechanical_model/full_gait_simulation.py

# LaTeX PDF 빌드
cd docs/latex && pdflatex three_link_biomechanical_model.tex && pdflatex three_link_biomechanical_model.tex
```

---

## 핵심 결론

### Force Profile Timing

```
부착      Onset    Release    주요 보조
High      60%      85%       Hip flexion (다리 앞으로)
Mid       63%      85%       Hip + Knee
Low       68%      85%       Knee extension (다리 펴기)
```

**Onset 근거**: $t_{\text{onset}} = \max(t_{\text{toe-off}}, t_{P_{\text{shank}}=0})$
- Toe-off = 60% (Perry & Burnfield, 2010)
- P_shank=0 = θ̇₂ zero-crossing (모델)

**Release 근거**: τ_hip flex→ext 전환 = 86.1% → 1% 전 = 85%
- Terminal swing 시작 = 87% (Perry & Burnfield, 2010)
- Hip flexor 활동 종료 = 85-87% (Krebs, 1998)
- Hip extensor 감속 활성화 (Brunner & Rutz, 2013)

### Cable이 부착 높이에 따라 다른 이유

$$v_{\text{cable}} = \underbrace{P_{\text{thigh}}}_{\text{모든 d 동일}} + \underbrace{P_{\text{shank}}(d)}_{\text{d에 비례}}$$

- High: P_shank 작음 → swing 전체에 고른 보조
- Low: P_shank 큼 → 60~68% 방해, 68~85% 집중 도움

### Shank 부착을 선택한 이유

| 부착 부위 | τ_hip | τ_knee | τ_ankle | 판정 |
|---|---|---|---|---|
| Thigh | 9.7 | 0 | 0 | hip 토크 작음, knee 불가 |
| **Shank** | **23.6** | **2.3** | **0** | **hip 최대 + knee 조절 + ankle 보존** |
| Foot | 24.7 | 14.2 | 1.9 | 3관절 동시, stance 방해 |

---

## 검증 상태

| 항목 | 방법 | 결과 |
|---|---|---|
| M(q) | SymPy 독립 유도 | ✅ err < 10⁻¹⁶ |
| C(q,q̇) | SymPy Christoffel | ✅ 부호 오류 수정 후 일치 |
| G(q) | SymPy | ✅ 일치 |
| 에너지 보존 | τ=0 simulation | ✅ drift = 3.38×10⁻¹⁶ |
| Gait 궤적 | Winter 2009 비교 | ✅ Fourier 계수 재피팅 완료 |
| Cable 방향 | verify_geometry.py | ✅ Walker 앞쪽으로 수정 완료 |

### 수정 이력

1. **Coriolis 부호 반전** — 모든 항 부호 오류 → SymPy로 확인 후 수정
2. **Fourier 계수 오류** — Hip/Knee/Ankle 궤적이 문헌과 불일치 → 재피팅
3. **Pulley 위치** — hip 뒤쪽 → 앞쪽(Walker)으로 수정
4. **Force profile** — 5N pretension → 0N으로 수정

---

## 알려진 한계

1. **2D sagittal plane만** — 좌우 비대칭, 회전 무시
2. **정상인 보행 기준** — 환자 보행은 다를 수 있음
3. **Perturbation 분석 (optimizer)** — Euler 적분으로 큰 force에서 절대값 부정확 (상대 비교는 유효)
4. **근육 반응 미반영** — 신경근 적응은 실험에서만 확인 가능

---

## 참고 문헌

| 문헌 | 사용한 내용 |
|---|---|
| Perry & Burnfield (2010) | Toe-off=60%, Terminal swing=87% |
| Winter (2009) | 인체 파라미터, 정상보행 궤적 |
| Winter (1991) | H3 power burst 정의 |
| Brunner & Rutz (2013) | Hip moment flex→ext, hamstring 감속 |
| Krebs (1998) | Iliopsoas 활동 종료 85-87% |
| Spong (2006) | Euler-Lagrange 유도 방법 |
| Wu et al. (2018) | Forward aiding force ~10% BW |
| Siegel et al. (2011) | 노인 H3 보상 메커니즘 |

---

#h-walker #biomechanics #3-link-model #cable-driven #force-profile #onset #release #experiment-design #인수인계
