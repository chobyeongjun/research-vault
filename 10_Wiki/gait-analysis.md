---
title: Gait Analysis
created: 2026-04-13
updated: 2026-04-13
sources: []
tags: [gait, biomechanics, rehabilitation]
summary: 보행 분석 기법으로, 이벤트 검출(HS/HO/TO)과 대칭성/리듬 지표를 통해 보행 패턴을 정량화한다.
confidence_score: 0.8
---

# [[Gait Analysis]]

## Brief Summary
보행 주기의 이벤트를 검출하고 대칭성, 리듬, 속도 등의 지표를 정량화하여 재활 효과를 평가하는 분석 기법이다.

## Core Content

### 보행 이벤트
- **Heel Strike (HS):** 발뒤꿈치 접지 - 보행 주기의 시작
- **Heel Off (HO):** 발뒤꿈치 이지
- **Toe Off (TO):** 발가락 이지 - 유각기(Swing Phase) 시작

### Gait Cycle Percentage (GCP)
한 보행 주기(HS ~ 다음 HS)를 0~100%로 정규화하여 시점 비교 가능

### 핵심 지표

#### 대칭성 지수 (Symmetry Index)
```
SI = |ST_ipsi - ST_contra| / (0.5 * (ST_ipsi + ST_contra)) * 100
```
- SI = 0%: 완전 대칭
- 뇌졸중 환자의 경우 건측/환측 비대칭이 핵심 평가 항목

#### 기타 지표
- **Cadence:** 분당 걸음 수 (steps/min)
- **Stride Length:** 한 보행 주기의 이동 거리
- **걸음 주기 변동계수 (CV):** 보행 리듬의 일관성 지표, CV가 낮을수록 안정적

## Knowledge Connections
- **Related Topics:** [[h-walker]], [[stroke-gait-experiment]], [[realtime-pose-estimation]]
- **Projects/Contexts:** [[h-walker]] Exosuit 보행 재활 효과 평가
- **Contradictions/Notes:** IMU 기반 이벤트 검출은 Force Plate 대비 정확도가 떨어질 수 있음

---
*Last updated: 2026-04-13*
