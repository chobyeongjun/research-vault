---
title: Obsidian Sync Setup
updated: 2026-04-22
tags: [meta, setup, sync, obsidian-git]
summary: Obsidian Git 플러그인으로 vault 자동 싱크 설정. 설정 파일은 repo에 포함되어 있으니 Mac에서 플러그인만 설치하면 자동 적용.
---

# Obsidian Sync Setup — Obsidian Git 플러그인

## 지금 어떤 상태인가

- ✅ `.obsidian/plugins/obsidian-git/data.json` — **자동 싱크 설정이 이미 저장되어 있음** (10분마다 pull/commit/push, rebase 방식, main 브랜치)
- ⚠️ 플러그인 자체(main.js 등)는 아직 설치 안 됨 → **Mac에서 1회만 설치 필요**

## Mac에서 해야 할 것 (3분)

### 1. 일단 최신 main 받기
```bash
cd ~/research-vault
git checkout main
git pull origin main
```

### 2. Obsidian에서 Community plugins 활성화 (처음 한 번만)
1. Obsidian 열기
2. **Settings (⌘,) → Community plugins**
3. "Turn on community plugins" 클릭 (이미 켜져있으면 skip)

### 3. Obsidian Git 설치
1. **Settings → Community plugins → Browse**
2. 검색: `Obsidian Git`
3. 설치자: **Vinzent03** (또는 최신 maintainer) 확인
4. **Install** → **Enable**

### 4. 확인
설치/enable하면 플러그인이 `data.json`을 자동 로드. 아래 설정이 이미 적용된 상태로 시작됩니다:

| 항목 | 값 |
|---|---|
| Commit message | `vault sync {{date}}` |
| Auto pull interval | 10 min |
| Auto commit interval | 10 min |
| Auto push interval | 10 min |
| Auto pull on boot | ON |
| Sync method | `rebase` (merge 커밋 안 만듦) |
| Pull before push | ON |

Settings → Community plugins → Obsidian Git → (톱니바퀴) 로 확인/수정 가능.

### 5. 상태바 확인
Obsidian 우하단에 git 상태 아이콘이 표시되어야 함 (브랜치명 + 변경 파일 수).

## 작동 방식

```
[파일 수정 in Obsidian]
        ↓
  10분 대기 (autoSaveInterval)
        ↓
   git add -A
        ↓
   git commit -m "vault sync 2026-04-22 15:30:00"
        ↓
   git pull --rebase origin main  (pullBeforePush=true)
        ↓
   git push origin main
        ↓
  10분 대기 → 반복
```

## 기존 `sync.sh`와의 관계

- `sync.sh`는 **수동 실행용으로 유지** (터미널에서 강제 싱크 필요할 때)
- Obsidian이 켜져 있으면 → Obsidian Git이 자동 처리
- Obsidian이 꺼져 있으면 → Mac에서 `./sync.sh` 한 번 돌리거나, launchd로 주기 실행 (옵션)

## 주의사항 / Lessons에 추가될 것들

- **main 브랜치만 싱크됨**: feature 브랜치 작업은 Claude Code 세션에서 별도로, 검증 후 main으로 merge ([[Lessons]] AR-6 후보)
- **충돌 발생 시**: Obsidian 하단에 에러 popup. 터미널에서 `git status` → 수동 resolve → 커밋 → 정상화
- **민감파일 보호**: `.gitignore`에 `.env`, `credentials.json` 등 이미 추가되어 있는지 확인. 현재는 `workspace.json`, `.trash/`, `*.tmp`만 제외.

## 대안: Obsidian Sync (유료 $8/mo)

- `.obsidian/core-plugins.json`에서 `"sync": true`로 이미 켜져있으나 Obsidian 계정 구독 필요
- 장점: 모바일 포함 Obsidian 간 실시간 싱크
- 단점: GitHub 히스토리 없음, 유료, 벤더 락인
- 본 vault는 **Obsidian Git 우선** 사용 (GitHub 히스토리 + 무료)

## 백업: launchd 자동 실행 (Obsidian 꺼져있을 때 보험)

`~/Library/LaunchAgents/com.user.vault-sync.plist` 생성 후 `launchctl load ...` 로 등록하면 Mac OS가 10분마다 `sync.sh` 실행. **필요 시** 별도 요청.
