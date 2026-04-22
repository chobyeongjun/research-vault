# H-Walker 연구 컨텍스트

> 프로젝트 허브: [[README]] · 상위 플랫폼: [[h-walker]] · 상위 개념: [[exosuit]]

## 연구 제목
케이블 드리븐 워커 장착형 보행 재활 로봇 제어 시스템

## 연구 목표
트레드밀 및 지면보행 환경에서 [[cable-driven-mechanism|케이블 기반 보행 보조 로봇]]의 제어 성능 검증.

## 시스템 개요
- 로봇 타입: 케이블 드리븐 워커 장착형 ([[cable-driven-mechanism]])
- 실험 환경: Treadmill / Overground
- 제어 주기: [[teensy-4-1]] inner 111Hz / [[jetson-orin-nx]] outer 10-30Hz
- 액추에이터: [[ak60-motor]] (max cable force ~70N)
- 센서: [[zed-x-mini|ZED 카메라]] + [[realtime-pose-estimation|MediaPipe 포즈 추정]]

## 제어 방법론
- [[admittance-control|임피던스 제어]]
- ILC (Iterative Learning Control)
- MPC-ILC

## 핵심 제약
- [[ak60-motor|AK60]] cable force 70N 초과 시 즉시 0으로 설정 ([[exosuit-safety]])
- [[zed-x-mini|ZED]]: HD1080/HD1200만 사용, 초기화 실패 시 reset_zed
- 보호 회로: [[robot-hardware-protection]] 참조

## 관련
- 자매 프로젝트: [[realtime-vision-control/README|realtime-vision-control]]
- 보행 분석: [[gait-analysis]]
- 환자 실험: [[stroke-gait-experiment]]

---
> 이 파일은 meeting-ppt와 research-paper 스킬이 자동으로 읽습니다.
> 연구 방향이 바뀌거나 새로운 내용이 추가되면 업데이트해 주세요.
