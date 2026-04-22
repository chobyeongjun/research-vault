---
title: CUDA Stream 3-stage + 20ms HARD LIMIT 실시간성 보장
date: 2026-04-18
project: realtime-vision-control
status: completed
tier: raw
tags: [experiment, cuda, realtime]
---

# CUDA Stream 3-stage + 20ms HARD LIMIT

## 목적
- Python+C++ 동시 실행 시 p99 > 20ms spike 제거
- stale keypoint → AK60 70N 경로 차단

## 환경
- Jetson Orin NX 16GB, MAXN

## 합격 기준
1. p95 e2e latency ≤ baseline × 0.5 (SVGA 120fps)
2. keypoint 정확도: max 2D err ≤ 1px, 3D err ≤ 5mm
3. 10분 연속: 열 스로틀 < 5%, watchdog < 1회/분
4. 제어 루프 outer 30Hz jitter CV < 5%

## 관련 파일
- [[plan]] — 5단계 구현 계획 (Phase 1~5)
- [[2026-04-19-handover-cuda-stream-perception]] — 인수인계
