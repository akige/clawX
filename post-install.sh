#!/bin/bash
# clawX 安装后配置脚本
# 此脚本在官方 OpenClaw 安装完成后运行

set -e

CLAWX_DIR="$HOME/.openclaw/clawX"
BACKUP_DIR="$HOME/.openclaw/config-backups"
WORKSPACE_DIR="$HOME/.openclaw/workspace"

echo "🦞 开始配置 clawX..."

# 1. 创建必要的目录
echo "📁 创建目录结构..."
mkdir -p "$BACKUP_DIR"
mkdir -p "$WORKSPACE_DIR/memory"
mkdir -p "$WORKSPACE_DIR/scripts"
mkdir -p "$WORKSPACE_DIR/docs"

# 2. 复制配置备份脚本
echo "📦 安装配置备份脚本..."
if [ -f "$CLAWX_DIR/scripts/config-backup.sh" ]; then
    cp "$CLAWX_DIR/scripts/config-backup.sh" "$WORKSPACE_DIR/scripts/"
    chmod +x "$WORKSPACE_DIR/scripts/config-backup.sh"
    echo "  ✅ 配置备份脚本已安装"
fi

# 3. 创建记忆系统文件
echo "🧠 初始化记忆系统..."
if [ ! -f "$WORKSPACE_DIR/MEMORY.md" ]; then
    cat > "$WORKSPACE_DIR/MEMORY.md" << 'EOF'
# 长期记忆

## 关于用户
- 名字：（请修改）
- 常用语言：中文

## 重要配置
（在此记录你的重要配置）

---
更新：$(date +%Y-%m-%d)
EOF
    echo "  ✅ 长期记忆已创建"
fi

# 4. 创建文档
echo "📚 安装文档..."
if [ -d "$CLAWX_DIR/docs" ]; then
    cp -r "$CLAWX_DIR/docs/"* "$WORKSPACE_DIR/docs/"
    echo "  ✅ 文档已安装"
fi

# 5. 创建首次备份
echo "💾 创建配置备份..."
if [ -f "$WORKSPACE_DIR/scripts/config-backup.sh" ]; then
    "$WORKSPACE_DIR/scripts/config-backup.sh" backup
fi

# 6. 检查 Whisper
echo "🎙️ 检查语音转录..."
if command -v whisper &> /dev/null; then
    echo "  ✅ Whisper 已安装"
else
    echo "  ⚠️ Whisper 未安装，如需语音转录请运行: brew install openai-whisper"
fi

echo ""
echo "🎉 clawX 配置完成！"
echo ""
echo "下一步："
echo "  1. 编辑 ~/.openclaw/workspace/MEMORY.md 填写你的信息"
echo "  2. 运行 openclaw gateway start 启动服务"
echo "  3. 查看文档: cat ~/.openclaw/workspace/docs/README.md"
echo ""
