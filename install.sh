#!/bin/bash
# clawX 一键安装脚本
# 基于官方 OpenClaw + clawX 定制配置

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo ""
echo "========================================"
echo "🦞 clawX 安装向导"
echo "========================================"
echo ""

# 检测系统
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macOS"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="Linux"
else
    echo -e "${RED}❌ 暂不支持此操作系统: $OSTYPE${NC}"
    exit 1
fi

echo -e "${BLUE}📋${NC} 检测到系统: $OS"

# ============ 安装 Node.js ============
echo ""
echo -e "${BLUE}📦${NC} 检查 Node.js..."

install_node() {
    echo -e "  ${YELLOW}安装 Node.js 22...${NC}"
    
    if [[ "$OS" == "macOS" ]]; then
        if command -v brew &> /dev/null; then
            brew install node@22
        else
            echo -e "${RED}❌ 请先安装 Homebrew: https://brew.sh${NC}"
            exit 1
        fi
    elif [[ "$OS" == "Linux" ]]; then
        if command -v apt-get &> /dev/null; then
            curl -fsSL https://deb.nodesource.com/setup_22.x | bash -e
            apt-get install -y nodejs
        elif command -v yum &> /dev/null; then
            curl -fsSL https://rpm.nodesource.com/setup_22.x | bash -e
            yum install -y nodejs
        elif command -v apk &> /dev/null; then
            apk add --no-cache nodejs npm
        else
            echo -e "${RED}❌ 不支持的 Linux 发行版${NC}"
            exit 1
        fi
    fi
}

if command -v node &> /dev/null; then
    NODE_VERSION=$(node -v)
    echo -e "  ${GREEN}✓${NC} Node.js 已安装: $NODE_VERSION"
    
    NODE_MAJOR=$(echo $NODE_VERSION | cut -d'.' -f1 | tr -d 'v')
    if [ "$NODE_MAJOR" -lt 22 ]; then
        echo -e "  ${YELLOW}⚠️${NC} 版本过低 (需要 22+)"
        install_node
    fi
else
    echo -e "  ${RED}❌${NC} Node.js 未安装"
    install_node
fi

# ============ 安装 pnpm ============
echo ""
echo -e "${BLUE}📦${NC} 检查 pnpm..."
if command -v pnpm &> /dev/null; then
    echo -e "  ${GREEN}✓${NC} pnpm 已安装"
else
    echo -e "  安装 pnpm..."
    npm install -g pnpm
    echo -e "  ${GREEN}✓${NC} pnpm 安装完成"
fi

# ============ 安装 OpenClaw ============
echo ""
echo -e "${BLUE}🦞${NC} 安装 OpenClaw..."

# 尝试不用 sudo，用 --unsafe-perm
if command -v openclaw &> /dev/null; then
    echo -e "  OpenClaw 已安装，更新中..."
    npm update -g openclaw --unsafe-perm=true --allow-root 2>/dev/null || npm update -g openclaw
else
    npm install -g openclaw --unsafe-perm=true --allow-root 2>/dev/null || npm install -g openclaw
fi
echo -e "  ${GREEN}✓${NC} OpenClaw 安装完成"

# ============ 获取用户目录 ============
# 记录原始用户目录（不是 sudo 后的 /root）
if [ -n "$SUDO_USER" ]; then
    USER_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)
else
    USER_HOME="$HOME"
fi

# ============ 克隆/更新 clawX 配置 ============
echo ""
echo -e "${BLUE}📥${NC} 准备 clawX 配置..."
CLAWX_DIR="$USER_HOME/.openclaw/clawX"

# 直接删除旧版本，重新克隆最新
if [ -d "$CLAWX_DIR" ]; then
    echo -e "  删除旧版本..."
    rm -rf "$CLAWX_DIR"
fi

echo -e "  克隆最新版本..."
git clone https://github.com/akige/clawX.git "$CLAWX_DIR"
echo -e "  ${GREEN}✓${NC} clawX 配置已准备 (最新版本)"

# ============ 运行安装后配置 ============
echo ""
echo -e "${BLUE}⚙️${NC} 应用 clawX 配置..."
chmod +x "$CLAWX_DIR/post-install.sh"
echo ""

# 切换回原始用户运行配置脚本
if [ -n "$SUDO_USER" ]; then
    sudo -u "$SUDO_USER" bash "$CLAWX_DIR/post-install.sh"
else
    bash "$CLAWX_DIR/post-install.sh"
fi
