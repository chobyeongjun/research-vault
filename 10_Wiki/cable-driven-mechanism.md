---
title: Cable-Driven Mechanism
created: 2026-04-13
updated: 2026-04-13
sources: []
tags: [cable-driven, mechanism, bowden-cable, friction]
summary: Bowden cable 기반 힘 전달 메커니즘. 액추에이터를 원격 배치하여 경량화를 달성한다.
confidence_score: 0.8
---

# [[Cable-Driven Mechanism]]

## Brief Summary
Bowden cable과 sheath를 이용해 액추에이터의 힘을 원격으로 전달하는 메커니즘으로, Exosuit에서 경량화와 착용성 향상에 핵심적이다.

## Core Content

### 구성 요소
- **Bowden Cable:** 강선 케이블 (인장력 전달)
- **Sheath:** 외피 튜브 (압축력 반력 제공)
- **Pulley:** 케이블 방향 전환 및 힘 배분

### Capstan Equation (Euler-Eytelwein)
케이블과 풀리 사이의 마찰 관계:
```
T_hold = T_load * e^(mu * theta)
```
- mu: 마찰 계수
- theta: 감김 각도 (rad)
- 마찰이 지수적으로 증가하므로 감김 각도 최소화가 중요

### 장점
- 액추에이터를 몸통 등 원격 위치에 배치 가능
- 관절부 경량화 → 관성 감소
- 유연한 경로 설정 가능

### 단점
- 마찰에 의한 효율 저하
- 히스테리시스: 방향 전환 시 데드존 발생
- 비선형성: 케이블 탄성, sheath 압축 등
- 수명: 반복 굽힘에 의한 피로 파괴

### Exosuit 적용
- Hip/Knee 관절 보조에 사용
- 모터(허리/등 장착) → Bowden cable → 관절 어태치먼트
- 마찰 보상 알고리즘 필요

## Knowledge Connections
- **Related Topics:** [[h-walker]], [[3d-assistance]], [[admittance-control]]
- **Projects/Contexts:** [[h-walker]] Exosuit 힘 전달 경로 설계
- **Contradictions/Notes:** 직접 구동(Direct Drive) 대비 제어 정밀도가 낮으나 착용성에서 우위

---
*Last updated: 2026-04-13*
