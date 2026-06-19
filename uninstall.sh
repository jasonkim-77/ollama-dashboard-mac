#!/bin/bash

echo "🗑️ Mac Ollama 대시보드 백그라운드 서비스 삭제를 시작합니다..."

# 1. 실행 중인 launchd 백그라운드 서비스 중지 및 언로드
if [ -f ~/Library/LaunchAgents/com.ollama.dashboard.plist ]; then
    launchctl bootout gui/$(id -u) ~/Library/LaunchAgents/com.ollama.dashboard.plist 2>/dev/null
    echo "✅ 백그라운드 서비스 가동 중지 완료."
else
    echo "ℹ️ 실행 중인 백그라운드 서비스가 없습니다."
fi

# 2. Mac 시스템 등록 파일(plist) 삭제
if [ -f ~/Library/LaunchAgents/com.ollama.dashboard.plist ]; then
    rm ~/Library/LaunchAgents/com.ollama.dashboard.plist
    echo "✅ 시스템 등록 파일(plist) 삭제 완료."
fi

# 3. 현재 폴더에 남은 실행 및 에러 로그 파일 자산 정리
CURRENT_DIR=$(pwd)
rm -f "$CURRENT_DIR/dashboard.log" "$CURRENT_DIR/dashboard_err.log"
echo "✅ 생성되었던 대시보드 구동 로그 파일(.log) 삭제 완료."

echo "🚀 모든 서비스가 안전하게 해제 및 삭제되었습니다! (9999번 포트가 개방되었습니다.)"
