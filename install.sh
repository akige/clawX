#!/bin/bash
# clawX 一键安装脚本
# 基于官方 OpenClaw + clawX 定制配置

set -e

echo "🦞 clawX 安装脚本"
echo "================"
echo ""

# 检查系统
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
else
    echo "❌ 暂不支持此操作系统: $OSTYPE"
    exit 1
fi

echo "📋 检测到系统: $OS"

# 1. 检查并安装 Node.js
echo ""
echo "📦 检查 Node.js..."
if command -v node &> /dev/null; then
    NODE_VERSION=$(node -v)
    echo "  ✅ Node.js 已安装: $NODE_VERSION"
    
    # 检查版本是否 >= 22
    NODE_MAJOR=$(echo $NODE_VERSION | cut -d'.' -f1 | tr -d 'v')
    if [ "$NODE_MAJOR" -lt 22 ]; then
        echo "  ⚠️ Node.js 版本过低，需要 22+"
        echo "  请运行: brew install node@22 或手动升级"
        exit 1
    fi
else
    echo "  ❌ Node.js 未安装"
    echo "  请先安装 Node.js 22+: https://nodejs.org/"
    exit 1
fi

# 2. 检查并安装 pnpm
echo ""
echo "📦 检查 pnpm..."
if command -v pnpm &> /dev/null; then
    echo "  ✅ pnpm 已安装"
else
    echo "  📥 安装 pnpm..."
    npm install -g pnpm
    echo "  ✅ pnpm 安装完成"
fi

# 3. 安装 OpenClaw
echo ""
echo "🦞 安装 OpenClaw..."
if command -v openclaw &> /dev/null; then
    echo "  OpenClaw 已安装，检查更新..."
    npm update -g openclaw
else
    npm install -g openclaw
fi
echo "  ✅ OpenClaw 安装完成"

# 4. 克隆 clawX 配置
echo ""
echo "📥 克隆 clawX 配置..."
CLAWX_DIR="$HOME/.openclaw/clawX"
if [ -d "$CLAWX_DIR" ]; then
    echo " clawX 已存在，更新中..."
    cd "$CLAWX_DIR"
    git pull origin main
else
    git clone https://github.com/akige/clawX.git "$CLAWX_DIR"
fi
echo "  ✅ clawX 配置已准备"

# 5. 运行安装后配置
echo ""
echo "⚙️ 应用 clawX 配置..."
chmod +x "$CLAWX_DIR/post-install.sh"
bash "$CLAWX_DIR/post-install.sh"

# 6. 提示用户运行 onboard
echo ""
echo "================================"
echo "🎉 安装完成！"
echo "================================"
echo ""
echo "下一步："
echo "  1. 运行配置向导: openclaw onboard"
echo "  2. 按照向导完成基础配置"
echo "  3. 启动服务: openclaw gateway start"
echo ""
echo "文档位置: ~/.openclaw/workspace/docs/"
echo ""
