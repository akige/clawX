#!/bin/bash
# clawX Manager 安装脚本

CLAWX_DIR="$HOME/.openclaw/clawX"
MANAGER_DIR="$HOME/.openclaw/clawx-manager"
PORT=8080

echo "📦 安装 clawX Manager..."

# 1. 创建目录
mkdir -p "$MANAGER_DIR"

# 2. 复制文件
cp -r "$CLAWX_DIR/manager/"* "$MANAGER_DIR/"

# 3. 安装依赖
cd "$MANAGER_DIR"
npm install --silent 2>/dev/null

# 4. 创建启动脚本
cat > "$MANAGER_DIR/start.sh" << EOF
#!/bin/bash
cd "\$(dirname "\$0")"
# 使用 setsid 让进程在 SSH 断开后继续运行
setsid node index.js > /tmp/clawx-manager.log 2>&1 &
echo "clawX Manager started on port $PORT"
EOF
chmod +x "$MANAGER_DIR/start.sh"

# 5. 根据系统启动
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS - 使用 LaunchAgent
    LAUNCH_AGENT="$HOME/Library/LaunchAgents/ai.clawx.manager.plist"
    mkdir -p "$HOME/Library/LaunchAgents"
    cat > "$LAUNCH_AGENT" << EOPLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>ai.clawx.manager</string>
    <key>ProgramArguments</key>
    <array>
        <string>$MANAGER_DIR/start.sh</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
</dict>
</plist>
EOPLIST
    launchctl load "$LAUNCH_AGENT" 2>/dev/null || true
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux - 使用 systemd 或直接启动
    if command -v systemctl &> /dev/null && [ "$EUID" -eq 0 ]; then
        # 创建 systemd 服务
        cat > /etc/systemd/system/clawx-manager.service << 'EOSERVICE'
[Unit]
Description=clawX Manager
After=network.target

[Service]
Type=simple
User=as
WorkingDirectory=/home/as/.openclaw/clawx-manager
ExecStart=/usr/bin/node /home/as/.openclaw/clawx-manager/index.js
Restart=always

[Install]
WantedBy=multi-user.target
EOSERVICE
        systemctl daemon-reload
        systemctl enable clawx-manager
        systemctl start clawx-manager
    else
        # 直接启动
        bash "$MANAGER_DIR/start.sh"
    fi
fi

echo "✅ clawX Manager 已安装"
echo "🌐 访问 http://localhost:$PORT 管理配置"
