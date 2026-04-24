---
title: H-Walker Graph Web — 아키텍처 & 상태
updated: 2026-04-24
tags: [h-walker, graph-app, web, architecture]
summary: h-walker-graph-web 현재 그래프 시스템 전체 구조, 알려진 버그, 개선 방향.
---

# H-Walker Graph Web

연구자용 단일 페이지 웹앱. CSV 실험 데이터 → 자연어 분석·시각화 → 논문 Figure Export.

**경로:** `~/h-walker-graph-web`  
**스택:** React 19 + FastAPI + matplotlib + Anthropic Haiku 4.5

---

## 그래프 템플릿 (16개)

### 실데이터 지원 ✅
| key | 설명 |
|-----|------|
| `debug_ts` | Raw time-series + heel-strike markers (항상 먼저) |
| `force` | GRF L vs R 즉시값 (Actual+Desired) |
| `force_avg` | GRF mean ± SD (stride-averaged) |
| `force_lr_subplot` | L/R side-by-side subplot · 논문 Figure 1 |
| `asymmetry` | 비대칭 지수 per stride |
| `peak_box` | Peak GRF boxplot L vs R |
| `trials` | Trial overlay |
| `imu` | Joint angle time series (첫 8s) |
| `imu_avg` | Joint angle mean ± SD per gait cycle |
| `cyclogram` | Phase portrait (L vs R pitch) |
| `stride_time_trend` | Stride time per stride (fatigue) |
| `stance_swing_bar` | Stance/swing phase % |
| `rom_bar` | ROM by joint/plane |
| `symmetry_radar` | Multi-metric asymmetry polar chart |

### Mockup only ❌ (실데이터 없음)
| key | 이유 |
|-----|------|
| `cop` | Force-plate grid 데이터 필요 |
| `cv_bar` | Trial 구분 데이터 없음 |

---

## 렌더 계층 (3단계 fallback)

```
POST /api/graphs/render
  1. _render_multi_dataset()  ← datasets[] ≥ 2 (subject overlay)
     지원 템플릿: force_avg, imu_avg, stride_time_trend, asymmetry, cyclogram
  2. _render_real_data()      ← dataset_id (실 CSV → analyze_cached)
  3. render()                  ← mockup bezier (데이터 없을 때)
```

---

## 저널 Export 검증 스펙

| 저널 | 1-col | 2-col | 폰트 | DPI |
|------|-------|-------|------|-----|
| IEEE | 88.9mm | 181mm | Times New Roman | 600 |
| Nature | 89mm | 183mm | Helvetica | 300 |
| APA | 85mm | 174mm | Arial | 300 |
| Elsevier | 90mm | 190mm | Arial | 300 |
| MDPI | 85mm | 170mm | Palatino | 1000 |
| JNER | 85mm | 170mm | Arial | 300 |

---

## 피드백 시스템 (백엔드 완성, UI 미연결)

- `POST /api/feedback/positive` — 👍
- `POST /api/feedback/correction` — 👎 + 수정안
- 저장: `~/.hw_graph/feedback/`
- LLM system prompt에 few-shot 자동 주입 (`format_as_few_shot()`)
- **프론트 버튼 아직 없음** → GraphCell / LlmCell에 추가 필요

---

## 개선 방향 (우선순위)

1. **LLM codegen** — Haiku가 실데이터 보고 matplotlib 코드 생성 → 즉시 렌더 (`/api/graphs/codegen`)
2. **피드백 UI** — 각 셀에 👍/👎 버튼 추가 (백엔드 이미 있음)
3. **L/R/Both 토글** — 기존 그래프에 side 파라미터 추가
4. **MATLAB-like 인터랙션** — zoom/pan/data cursor (SVG inline + JS)
5. **cop, cv_bar** — UI에서 숨기기 (mockup only라 사용자 혼란)

---

## 수정 이력

| 날짜 | 내용 |
|------|------|
| 2026-04-24 | `force_lr_subplot` std=None crash 수정 |
| 2026-04-24 | `backendRender` series overlay 미전달 수정 |
| 2026-04-24 | `bundle` 항상 mockup → 실데이터 fallback 추가 |
| 2026-04-24 | 그래프 드롭다운 optgroup 분류 (Force/IMU/Summary) |

---

## Gotchas

- `cop`, `cv_bar` → UI 드롭다운에서 제거했으나 GRAPH_SPECS에 남아있음
- bundle cells[] → `dataset_id`, `datasets`, `title` 전달해야 실데이터 렌더
- Zustand persist key: `hw_workspace_v1` — 스키마 바뀌면 bump 필요
