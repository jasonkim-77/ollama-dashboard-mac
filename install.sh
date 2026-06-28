#!/bin/bash

# 1. 현재 터미널이 열려 있는 실제 절대 경로 계산
CURRENT_DIR=$(pwd)
PLIST_PATH="$HOME/Library/LaunchAgents/com.ollama.dashboard.plist"

echo "⏳ Mac Ollama 대시보드 자동 빌드 및 서비스 등록을 시작합니다..."
echo "📂 감지된 로컬 설치 경로: $CURRENT_DIR"

# 2. 독립 가상환경 생성 및 필수 패키지 올인원 설치 (1회 자동화)
if [ ! -d ".venv" ]; then
    echo "📦 [1/4] 파이썬 독립 가상환경(.venv)을 생성 중..."
    python3 -m venv .venv
fi

echo "📥 [2/4] 대시보드 필수 라이브러리 설치 중 (Streamlit, Plotly, Pandas, Ollama, Watchdog)..."
./.venv/bin/pip install --upgrade pip
./.venv/bin/pip install streamlit plotly pandas requests ollama watchdog psutil

# 3. Streamlit 이메일 입력창 무조건 건너뛰도록 글로벌 자격증명 강제 생성 (1회 수동 입력 대체)
echo "🔒 [3/4] 대시보드 이메일 입력 및 웰컴 문구 자동 우회 셋팅 중..."
mkdir -p ~/.streamlit
cat << EOF > ~/.streamlit/credentials.toml
[general]
email = ""
EOF

# 4. com.ollama.dashboard.plist 파일 내부의 가상환경 파이썬 및 타겟 경로 고정 치환
echo "⚙️ [4/4] 시스템 서비스 등록 파일 동적 치환 및 최적화 중..."
sed -e "s|TARGET_DIR|$CURRENT_DIR|g" \
    -e "s|<string>/usr/bin/python3</string>|<string>$CURRENT_DIR/.venv/bin/python3</string>|g" \
    com.ollama.dashboard.plist > "$PLIST_PATH"

# 5. 기존 구동 중이던 서비스 인스턴스가 있다면 안전하게 중지 및 리프레시
launchctl bootout gui/$(id -u) "$PLIST_PATH" 2>/dev/null
pkill -f streamlit

# 6. 백그라운드 상시 서비스 가동 명령어 실행
launchctl bootstrap gui/$(id -u) "$PLIST_PATH"
launchctl kickstart -k gui/$(id -u)/com.ollama.dashboard

echo "--------------------------------------------------------"
echo "🚀 모든 가상환경 구축 및 백그라운드 상시 서비스 활성화 완료!"
echo "🌐 다른 기기(스마트폰/PC)에서 브라우저를 열고 아래 주소로 접속하세요."
echo "🔗 주소: http://localhost:9999"
echo "--------------------------------------------------------"
