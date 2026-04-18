---
title: Admittance Control
created: 2026-04-13
updated: 2026-04-13
sources: []
tags: [control, impedance, admittance, force-control]
summary: 외력을 측정하여 원하는 운동을 생성하는 제어 방식으로, Exosuit에서 사용자 의도(힘)를 궤적으로 변환한다.
confidence_score: 0.8
---

# [[Admittance Control]]

## Brief Summary
외력을 측정하여 원하는 운동(위치/속도)을 생성하는 제어 방식. Impedance Control과 듀얼 관계이며, Exosuit에서 사용자 의도 기반 보조에 핵심적으로 사용된다.

## Core Content

### Impedance vs Admittance
- **Impedance Control:** 운동(위치 오차)을 입력으로 받아 힘을 출력
- **Admittance Control:** 힘을 입력으로 받아 운동(위치/속도)을 출력
- 환경과의 상호작용 특성에 따라 선택: 강성 환경에서는 Admittance, 유연 환경에서는 Impedance가 유리

### Exosuit에서의 적용
1. 사용자 의도(힘)를 측정 (로드셀 또는 토크 센서)
2. Admittance 모델을 통해 원하는 궤적(p_des) 생성
3. 생성된 p_des를 위치 제어기에 전달

### MIT 모드 토크 공식
```
tau = KP * (p_des - p) + KD * (v_des - v) + T_ff
```
- Admittance 출력은 `p_des`에 연결
- 권장 게인: KP = 30~50, KD = 0.5~1.0
- T_ff: 피드포워드 토크 (중력 보상 등)

### 참고 문헌
- "Unified Impedance and Admittance Control" 논문
- 임피던스/어드미턴스 제어의 통합적 프레임워크 제시

## Knowledge Connections
- **Related Topics:** [[h-walker]], [[ak60-motor]], [[gait-analysis]]
- **Projects/Contexts:** [[h-walker]] Exosuit 보행 보조 제어
- **Contradictions/Notes:** 순수 어드미턴스 제어는 힘 센서 노이즈에 민감하여 필터링 필수

---
*Last updated: 2026-04-13*
