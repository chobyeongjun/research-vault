# Force Profile Timing 근거 — 완전 정리

## 한 줄 요약
Onset은 **P_shank이 cable을 방해하지 않는 시점**, Release는 **hip이 감속을 시작하는 시점**으로 결정. 둘 다 물리적 근거가 있음.

---

## 1. 핵심 수식

### 부착점 속도 분해

$$\vec{v}_{\text{attach}}(t, d) = \underbrace{l_1 \dot\theta_1 \begin{bmatrix}\cos\theta_1 \\ \sin\theta_1\end{bmatrix}}_{\vec{v}_{\text{thigh}} \text{ (d 무관)}} + \underbrace{d \cdot \dot\theta_2 \begin{bmatrix}\cos\theta_2 \\ \sin\theta_2\end{bmatrix}}_{\vec{v}_{\text{shank}}(d) \text{ (d 비례)}}$$

### Cable 방향 속도

$$v_{\text{cable}}(t, d) = \hat{u} \cdot \vec{v}_{\text{attach}} = P_{\text{thigh}}(t) + P_{\text{shank}}(t, d)$$

- $P_{\text{thigh}} = l_1 \dot\theta_1 (\hat{u}_x \cos\theta_1 + \hat{u}_y \sin\theta_1)$
- $P_{\text{shank}} = d \cdot \dot\theta_2 (\hat{u}_x \cos\theta_2 + \hat{u}_y \sin\theta_2)$

### Power Transfer

$$P_{\text{cable}} = F \cdot v_{\text{cable}}$$

- $P > 0$: 에너지 추가 (속도 증가)
- $P < 0$: 에너지 흡수 (브레이크)

---

## 2. ONSET 결정

### 수식

$$t_{\text{onset}}(d) = \max\Big(t_{\text{toe-off}},\;\; t_{P_{\text{shank}}=0}(d)\Big)$$

### 제약 1: Toe-off (문헌)

> "Pre-swing takes place during 50-62% GCP. Initial swing begins at 60% as defined from toe-off."
> — Perry & Burnfield (2010)

발이 땅에 있으면 cable이 당길 수 없음. → $t_{\text{onset}} \geq 60\%$

### 제약 2: P_shank ≥ 0 (모델)

60~68% GCP에서 knee가 빠르게 굽혀지면서 shank 하단이 **뒤로** 회전:

```
θ̇₂ (shank 절대 각속도):
  60%: -223°/s  (뒤로)
  65%:  -64°/s  (뒤로, 감속 중)
  68%:   +4°/s  (앞으로 전환!) ← 여기가 θ̇₂ = 0
  73%:  +84°/s  (앞으로)
```

- 68% 이전: $\dot\theta_2 < 0$ → $P_{\text{shank}} < 0$ → cable 방해
- 68% 이후: $\dot\theta_2 > 0$ → $P_{\text{shank}} > 0$ → cable 도움

**이 전환점(68%)은 모든 부착 높이에서 동일** (θ̇₂는 d와 무관).

### 왜 부착 높이마다 Onset이 다른가

$P_{\text{shank}} < 0$의 **크기**가 d에 비례하기 때문:

```
GCP 60%에서:
  High (3cm):  P_shank = -0.083  → v_cable = 0.855 (거의 영향 없음)
  Mid (8.6cm): P_shank = -0.217  → v_cable = 0.711 (약간 감소)
  Low (18cm):  P_shank = -0.394  → v_cable = 0.511 (크게 감소!)
```

- **High**: P_shank가 작아서 60%부터 효과적 → Onset = 60% (toe-off 지배)
- **Low**: P_shank가 커서 68%까지 기다려야 효율적 → Onset = 68% (P_shank 지배)

### 결과

| 부착 | t_toe-off | t_{P_shank=0} | **Onset** | 지배 제약 |
|---|---|---|---|---|
| **High** (shank 7%) | 60% | 52% | **60%** | Toe-off |
| **Mid** (shank 20%) | 60% | 63% | **63%** | P_shank |
| **Low** (shank 42%) | 60% | 68% | **68%** | P_shank |

### 물리적 해석

- **High (60%)**: 무릎 바로 아래라 shank 회전 영향 작음 → toe-off 직후부터 hip flexion 보조
- **Mid (63%)**: shank 영향 중간 → toe-off 후 약간 대기
- **Low (68%)**: shank 하단이 아직 뒤로 가는 동안 cable이 앞으로 당기면 "잡혀서 안 움직이는" 느낌 → knee가 펴지기 시작할 때(68%) onset

### 논문 근거

| 내용 | 출처 |
|---|---|
| Toe-off = 60% GCP | Perry & Burnfield (2010) |
| H3 hip power = 50-87% | Winter (1991), Brunner & Rutz (2013) |
| Iliopsoas 활동 = pre-swing ~ mid-swing | Hip Flexor Activation Study (2024) |
| Peak knee flexion ≈ 73% | Winter (2009) |

---

## 3. RELEASE 결정

### 수식

$$t_{\text{release}} = t_{\tau_{\text{hip}} \text{ flex→ext}} - \Delta t_{\text{safety}}$$

### 역동역학에서 확인

$$\tau_{\text{hip}}^{\text{required}}(t) = M_{11}\ddot\theta_1 + M_{12}\ddot\theta_2 + b_1 + G_1$$

이 값이 양수(flexion 필요) → 음수(extension 필요)로 전환되는 시점:

```
84%: τ_hip = +24.5 Nm  (flexion 필요 → cable 도움 ✓)
85%: τ_hip = +13.2 Nm  (flexion 필요 → cable 도움 ✓)  ← release
86%: τ_hip =  +0.3 Nm  (거의 0, 전환 직전)
87%: τ_hip = -12.6 Nm  (extension 필요 → cable 방해 ✗!)
88%: τ_hip = -23.9 Nm  (extension 필요 → cable 방해 ✗✗!)
```

**전환점 = 86.1% GCP**

### 왜 85%인가

- Cable은 항상 **hip flexion 방향**으로 토크를 줌
- 86% 이후 hip은 **extension 토크(감속)가 필요**
- Cable이 계속 작동하면 **감속을 방해** → heel strike 준비 불가
- 85%에서 release → 86% 전에 force ≈ 0

### Release가 모든 부착에서 동일한 이유

τ_hip의 flex→ext 전환은 **보행 궤적이 결정**하는 것이지 부착 높이(d)와 무관.

→ **Release = 85% (전부 동일)**

### 문헌 근거

| 내용 | 출처 |
|---|---|
| Terminal swing 시작 = 87% | Perry & Burnfield (2010) |
| Hip flexor(iliopsoas) 활동 종료 = 85-87% | Krebs (1998) |
| Hip extensor(hamstring, glut max) 활성화 → 감속 | Brunner & Rutz (2013), PM&R KnowledgeNow |
| Hip moment flex→ext 전환 = 86.1% | 모델 역동역학 |

### 논문 문장

> "The force release was set at 85% GCP, immediately before the hip flexion-to-extension torque transition (86.1% GCP, inverse dynamics). At this point, the hip flexor muscles cease concentric activity (Krebs, 1998), and hip extensors begin eccentric activation to decelerate the limb for heel strike (Brunner & Rutz, 2013; Perry & Burnfield, 2010). Continued cable force would oppose the required deceleration, compromising gait stability."

---

## 4. 최종 Force Profile

```
  GCP:  50    55    60    63    68    73    78    85    87    95
         │     │     │     │     │     │     │     │     │     │
  High:  │ TFF │▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓│     │     │
         │     │ onset=60%             release=85% │     │     │
         │     │ (toe-off)             (τ flex→ext) │    │     │
         │     │                                    │    │     │
  Mid:   │ TFF    │▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓│     │     │
         │        │ onset=63%           release=85%│     │     │
         │        │ (P_shank=0)                    │     │     │
         │        │                                │     │     │
  Low:   │  TFF      │▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓│    │     │
         │           │ onset=68%       release=85%  │     │
         │           │ (P_shank=0)     (τ flex→ext) │     │
         │           │                              │     │
                                                   86.1%
                                              (τ_hip flex→ext)
```

### 요약 테이블

| 부착 | Onset | Release | 보조 구간 | Onset 근거 | Release 근거 |
|---|---|---|---|---|---|
| **High** | **60%** | **85%** | 25% | toe-off (Perry 2010) | τ flex→ext (모델+문헌) |
| **Mid** | **63%** | **85%** | 22% | P_shank=0 (모델) | τ flex→ext (모델+문헌) |
| **Low** | **68%** | **85%** | 17% | P_shank=0 (모델) | τ flex→ext (모델+문헌) |

### 보조 특성

| 부착 | 주요 보조 구간 | 보조 대상 |
|---|---|---|
| **High** | 60~68% (P_shank≈0) + 68~85% (P_shank>0) | **Hip flexion 전체 보조** |
| **Mid** | 63~68% (P_shank≈0) + 68~85% (P_shank>0) | **Hip + Knee 보조** |
| **Low** | 68~85% (P_shank>0만) | **Knee extension 집중 보조** |

---

## 5. 실험에서의 의미

### High에서 60% onset이 잘 됐던 이유
P_shank가 작아서 (-0.083) v_cable에 거의 영향 없음. 60%부터 바로 효과적인 hip flexion 보조 가능.

### Low에서 60% onset이 문제였던 이유
P_shank가 커서 (-0.394) v_cable을 크게 깎아먹음. 부착점이 아직 뒤로 움직이는 속도가 강한데 cable이 앞으로 당김 → "잡혀서 안 움직이는" 느낌.

### Release를 85%로 통일하는 이유
Cable은 hip flexion 토크를 줌. 86.1%부터 hip은 extension 토크(감속)가 필요. Cable이 계속 작동하면 감속을 방해 → heel strike 불안정. 이 전환점은 보행 궤적이 결정하므로 부착 높이와 무관 → 모든 부착에서 85%.

---

## 6. 참고 문헌

| 문헌 | 내용 | 어디에 사용 |
|---|---|---|
| Perry & Burnfield (2010) | Toe-off=60%, Terminal swing=87% | Onset 제약 1, Release 맥락 |
| Winter (1991, 2009) | H3 power, 정상보행 궤적, joint moment | 모델 입력 데이터 |
| Brunner & Rutz (2013) | Hip moment flex→ext, hamstring 감속 | Release 근거 |
| Krebs (1998) | Iliopsoas 활동 종료 85-87% | Release 근거 |
| PM&R KnowledgeNow | Terminal swing hip extensor 활성화 | Release 물리적 해석 |
| Hip Flexor Activation (2024) | Iliopsoas 활성 구간 | Onset H3 구간 |

---

## 7. 코드 위치

| 파일 | 내용 |
|---|---|
| `onset_model.py` | OnsetModel 클래스, v_cable 분해, onset/release 계산 |
| `three_link_dynamics.py` | M, C, G 계산, 역동역학 |
| `gait_reference.py` | Winter 2009 보행 궤적 (Fourier) |
| `cable_force_mapping.py` | Cable tension → joint torque |

### 실행

```bash
PYTHONPATH=src python -c "
from hw_control.biomechanical_model.onset_model import OnsetModel
import numpy as np

m = OnsetModel(attach_distance=0.18, anchor_point=np.array([0.40, -0.43]))
print(f'Onset: {m.find_onset():.1f}%')
print(f'Release: {m.find_release():.1f}%')
m.print_analysis()
"
```

---

#h-walker #force-profile #onset #release #biomechanics #P_shank #timing
