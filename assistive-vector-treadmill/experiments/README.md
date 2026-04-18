---
topic: assistive-vector-treadmill
created: 2026-04-18
tags: [topic, treadmill, assistive-force, cable-driven, vector-control]
status: active
---

# Assistive Vector Treadmill

## 주제 정의
**트레드밀 위 보행 환경에서 방향성 있는 assistive force vector 제어 연구.**
케이블 드리븐 워커(H-Walker)가 treadmill 보행 중 환자에게 전달하는 힘의 크기·방향을 시공간적으로 제어하는 것이 핵심.

## 포함 범위 (TBD — 사용자 보강)
- Treadmill 환경 제어 루프 (`src/hw_treadmill/`)
- Assistive force vector 설계 (시점·크기·방향)
- Cable 장력 분배 최적화 (다중 케이블 → 합성 벡터)
- 환자 보행 phase에 따른 힘 벡터 시간 프로파일
- 실험 프로토콜 (treadmill 속도·경사·지속시간)

## 포함 안 되는 것 (다른 주제)
- 카메라 자세 인식 / 임피던스·ILC 제어 일반 → `realtime-vision-control`
- 지면보행 (overground) 프로토콜 → 별도 검토 필요
- Exosuit 보드/회생/CAN 안전 → 별도 주제

## Paper 매핑
| ID | 제목 | 상태 |
|---|---|---|
| `assistive-vector-treadmill-*` | TBD | Planning |

## 실험 인벤토리
- (비어있음 — 첫 실험 등록 대기)

## Master Reference
- (TBD — 별도 wiki 마스터 문서 필요 시 작성)

## 관련 Raw 로그 / Wiki
- `10_Wiki/gait-analysis.md`
- `10_Wiki/cable-driven-mechanism.md`
- `10_Wiki/admittance-control.md`
- `10_Wiki/ak60-motor.md`
