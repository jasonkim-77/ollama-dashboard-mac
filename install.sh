#!/bin/bash

# 현재 터미널이 열려 있는 실제 절대 경로 계산
CURRENT_DIR=$(pwd)

echo "⏳ Mac Ollama 대시보드 백그라운드 서비스 등록을 시작합니다..."
echo "📂 감지된 로컬 설치 경로: $CURRENT_DIR"

# 템플릿 파일의 TARGET_DIR을 현재 경로로 자동 치환하여 에이전트 서비스 생성
sed "s|TARGET_DIR|$CURRENT_DIR|g" com.ollama.dashboard.plist > ~/Library/LaunchAgents/com.ollama.dashboard.plist

echo "✅ 시스템 템플릿 동적 치환 완료 완료!"

# 기존 구동 중이던 서비스 인스턴스가 있다면 안전하게 중지 및 리프레시
launchctl bootout gui/$(id -u) ~/Library/LaunchAgents/com.ollama.dashboard.plist 2>/dev/null

# 백그라운드 백엔드 등록 및 즉시 가동 명령
launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.ollama.dashboard.plist
launchctl kickstart -k gui/$(id -u)/com.ollama.dashboard

echo "🚀 백그라운드 상시 서비스 활성화 완료!"
echo "🌐 이제 브라우저를 열고 http://localhost:9999 주소로 접속해 확인하세요."
