# 3-Link Biomechanical Model — 전체 정리

## 한 줄 요약
Cable-driven walker의 **cable이 다리에 어떤 토크를 만드는지** 계산하는 모델. 실험 설계의 근거로 사용.

---

## 핵심 수식 1개만 기억하면 됨

$$\vec{\tau}_{cable} = J^T(\vec{q}) \cdot \vec{F}_{cable}$$

- $J$: 부착점의 Jacobian (다리 자세 $\vec{q}$에 따라 변함)
- $\vec{F}_{cable}$: cable이 당기는 힘 벡터
- $\vec{\tau}$: 결과로 나오는 관절 토크 [hip, knee, ankle]

**의미**: 같은 50N이라도 **다리 자세**와 **cable 방향**에 따라 각 관절에 걸리는 토크가 다르다.

---

## 이 모델로 알아낸 것들

### 1. 왜 Shank에 부착하는가
> 📁 `src/hw_control/biomechanical_model/cable_force_mapping.py`

| 부착 부위 | τ_hip | τ_knee | τ_ankle |
|---|---|---|---|
| Thigh 50% | 9.7 Nm | 0 | 0 |
| **Shank 20%** | **23.6 Nm** | **2.3 Nm** | **0** |
| Foot 50% | 24.7 Nm | 14.2 Nm | 1.9 Nm |

- Thigh: hip에 가까워서 moment arm 짧음 → 토크 작음
- Foot: 3관절 동시 영향 + stance에서 방해
- **Shank: hip 토크 최대 + knee 조절 가능 + ankle 보존**

### 2. Anchor 높이(방향)에 따른 효과
> 📁 `src/hw_control/biomechanical_model/optimizer.py`

| Anchor | Cable 각도 | 효과 |
|---|---|---|
| Hip 높이 | +53° (위로) | τ_hip = 16 Nm, clearance↑ |
| Knee 높이 | +6° (수평) | τ_hip = 23 Nm, stride↑ |
| Ankle 높이 | -46° (아래) | τ_hip = 14 Nm, τ_knee↑ |

**핵심**: Anchor가 낮을수록 수평으로 당김 → hip flexion 보조에 효과적

### 3. Attach × Anchor Interaction
> 📁 동일

Anchor가 낮을 때 Attach 변경 효과가 커짐:
- Anchor=Hip: Attach 바꿔도 각도 3° 차이 (무시)
- Anchor=Ankle: Attach 바꾸면 각도 19° 차이 (유의미)

→ **3×3 factorial로 실험해야 interaction 볼 수 있음**

### 4. Force Profile 유도
> 📁 `src/hw_control/biomechanical_model/force_gait_analysis.py`

```
기존:  "Half-sine이니까 half-sine" (근거 없음)
유도:  F(t) = τ_desired(t) / sensitivity(q(t))
       → 보조 목표에서 모양이 자동으로 나옴
```

### 5. 보조 구간 (60-85% GCP) 근거
> 📁 역동역학 분석 결과

| 제약 | 근거 | 확실도 |
|---|---|---|
| Onset ≥ 60% | Toe-off. 발이 땅에서 떨어지는 시점 | 확실 |
| Release ≤ 86% | Hip flex→ext 토크 전환 | 확실 |
| Cable Power > 0 | 55~93%에서 에너지 추가 가능 | 확실 |
| 정확한 Peak | 실험으로 결정 필요 | 모름 |

### 6. Hip Power (H3) 보강
> 📁 `docs/figures/joint_power_analysis.png`

- H3: hip이 다리를 앞으로 던지는 power burst (55-67% GCP)
- Cable이 하는 것 = H3를 외부에서 보강
- 노인/환자는 ankle push-off(A2) 약화 → H3로 보상 (문헌)
- **Cable = 이 보상 메커니즘을 외부에서 도와주는 것**

---

## 파일 위치 가이드

### 코드 (`src/hw_control/biomechanical_model/`)

| 파일 | 뭘 하는 파일 | 언제 쓰나 |
|---|---|---|
| `three_link_dynamics.py` | M, C, G 행렬 계산 | 다른 모든 파일의 기반 |
| `anthropometric.py` | 인체 파라미터 (Winter 2009) | 피험자 체형 입력 |
| `gait_reference.py` | 정상보행 궤적 (Fourier) | 역동역학 입력 |
| `cable_force_mapping.py` | Cable tension → joint torque | ★ 핵심. J^T·F 계산 |
| `simulation.py` | ODE 시뮬레이션 | 에너지 보존 검증 |
| `optimizer.py` | 파라미터 sweep + 최적화 | ★ 실험 조건 비교 |
| `force_gait_analysis.py` | Force→Torque→Stride 분석 | 시간 도메인 분석 |
| `full_gait_simulation.py` | GCP 0~100% 전체 시각화 | 그림 생성 |
| `verify_geometry.py` | Cable 기하학 검증 | 방향 맞는지 시각 확인 |
| `run_demo.py` | 전체 데모 | 처음 돌려볼 때 |

### 문서 (`docs/`)

| 파일 | 내용 |
|---|---|
| `latex/three_link_biomechanical_model.tex` | 수식 전체 유도 (2000줄) |
| `HANDOVER.md` | 인수인계서 (실행법, 검증결과, 제한사항) |
| `figures/` | 생성된 그림 14개 |

### 핵심 그림 (`docs/figures/`)

| 그림 | 보여주는 것 |
|---|---|
| `joint_power_analysis.png` | Hip/Knee/Ankle power (H3, K3, K4) |
| `force_profile_derivation.png` | F = τ/s(q) 유도 과정 |
| `full_gait_0_to_100.png` | GCP 0~100% 다리 자세 + cable |
| `force_gait_analysis.png` | Force→Torque→Stride 6-panel |
| `parameter_sweep_results.png` | 4가지 변수 sweep |
| `geometry_verification.png` | Cable 방향 시각 검증 |

---

## 실행 방법

```bash
# Mac
cd ~/h-walker-ws
git checkout modeling
git pull origin modeling
PYTHONPATH=src python src/hw_control/biomechanical_model/run_demo.py

# Windows PowerShell
cd C:\Users\user\h-walker-ws
git checkout modeling
$env:PYTHONPATH="src"
python src\hw_control\biomechanical_model\run_demo.py
```

### 자주 쓰는 명령

```bash
# 특정 조건 분석
PYTHONPATH=src python -c "
from hw_control.biomechanical_model.optimizer import analyze
import numpy as np
r = analyze(peak_force=50, attach_distance=0.08,
            frame_point=np.array([0.40, -0.43]))
print(f'τ_hip={r.peak_tau_hip:.1f}, τ_knee={r.peak_tau_knee:.1f}')
print(f'Stride Δ={r.stride_delta*100:+.1f}cm')
"

# 전체 sweep
PYTHONPATH=src python src/hw_control/biomechanical_model/optimizer.py

# GCP 0~100% 시뮬레이션
PYTHONPATH=src python src/hw_control/biomechanical_model/full_gait_simulation.py
```

---

## 검증 상태

| 항목 | 방법 | 결과 |
|---|---|---|
| M(q) 질량행렬 | SymPy 독립 유도 | ✅ err < 10⁻¹⁶ |
| C(q,q̇) Coriolis | SymPy Christoffel | ✅ 부호 오류 수정 후 일치 |
| G(q) 중력 | SymPy | ✅ 일치 |
| 에너지 보존 | τ=0 simulation | ✅ drift = 10⁻¹⁶ |
| Gait 궤적 | Winter 2009 비교 | ✅ Fourier 계수 재피팅 완료 |
| Cable 방향 | verify_geometry.py | ✅ Walker 앞쪽으로 수정 완료 |

---

## 실험 설계 (3×3 Factorial)

### 고정값
- Force: 50N peak, half-sine, 60-85% GCP
- Treadmill: 1.0 m/s
- Attach 정의: shank 길이의 7%, 20%, 42%
- Anchor 정의: 대전자, 무릎 관절선, 외과 높이

### 9조건 + baseline
| | Anchor Hip | Anchor Knee | Anchor Ankle |
|---|---|---|---|
| **Attach 7%** | +54°, τk=-0.4 | +4°, τk=+0.9 | -40°, τk=+1.5 |
| **Attach 20%** | +53°, τk=-0.9 | +9°, τk=+2.3 | -33°, τk=+4.1 |
| **Attach 42%** | +52°, τk=-1.6 | +16°, τk=+3.9 | -21°, τk=+8.0 |

### Block randomization
- Block 1 (A1 고정): N1→N2→N3 random
- Block 2 (A2 고정): N1→N2→N3 random
- Block 3 (A3 고정): N1→N2→N3 random
- Attach 변경 = 2번만
- 총 65분

---

## 논문에서 모델이 쓰이는 곳

Methods 2.2절 (~1.5페이지):
1. **Shank 부착 근거** — τ 비교 테이블 (1문단)
2. **9조건 예측 토크** — Table 1개
3. **Force profile 근거** — F = τ/s(q) (1문단)
4. **Foot clearance** — 3-link인 이유 (1문장)

수식 전체 유도 → supplementary or GitHub 링크

---

## 핵심 문헌

| 문헌 | 뭘 가져왔나 |
|---|---|
| Winter (2009) | 인체 파라미터, 정상보행 궤적 |
| Perry & Burnfield (2010) | Power burst 명명 (H1-H3, K1-K4) |
| Spong (2006) | Euler-Lagrange 유도 방법 |
| Wu et al. (2018) | Forward aiding force ~10% BW |
| Siegel et al. (2011) | 노인 H3 보상 메커니즘 |
| Hsiao et al. (2015) | Hip power 부족 → 보행속도 제한 |

---

## 한계 (알고 있어야 할 것)

1. **2D sagittal plane만** — 좌우 비대칭, 회전 무시
2. **정상인 보행 기준** — 환자 보행은 다를 수 있음
3. **Perturbation 분석의 Euler 적분** — 큰 force에서 절대값 부정확 (상대 비교는 유효)
4. **근육 반응 미반영** — 환자가 cable에 어떻게 적응하는지는 실험에서만 알 수 있음

---

#h-walker #biomechanics #3-link-model #cable-driven #gait-rehabilitation #experiment-design
