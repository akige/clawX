#!/bin/bash
# clawX Manager 安装脚本

CLAWX_DIR="$HOME/.openclaw/clawX"
MANAGER_DIR="$HOME/.openclaw/clawx-manager"
LAUNCH_AGENT="$HOME/Library/LaunchAgents/ai.clawx.manager.plist"

echo "📦 安装 clawX Manager..."

# 1. 创建目录
mkdir -p "$MANAGER_DIR"

# 2. 复制文件
cp -r "$CLAWX_DIR/manager/"* "$MANAGER_DIR/"

# 3. 安装依赖
cd "$MANAGER_DIR"
npm install --silent 2>/dev/null

# 4. 创建启动脚本
cat > "$MANAGER_DIR/start.sh" << 'EOF'
#!/bin/bash
cd "$(dirname "$0")"
nohup node index.js > /tmp/clawx-manager.log 2>&1 &
echo "clawX Manager started"
EOF
chmod +x "$MANAGER_DIR/start.sh"

# 5. 创建 LaunchAgent (macOS)
mkdir -p "$HOME/Library/LaunchAgents"
cat > "$LAUNCH_AGENT" << EOF
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
EOF

# 6. 启动服务
launchctl load "$LAUNCH_AGENT" 2>/dev/null || true

echo "✅ clawX Manager 已安装"
echo "🌐 访问 http://localhost:19999 管理配置"
