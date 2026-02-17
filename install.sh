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
if command -v openclaw &> /dev/null; then
    echo -e "  OpenClaw 已安装，更新中..."
    npm update -g openclaw
else
    npm install -g openclaw
fi
echo -e "  ${GREEN}✓${NC} OpenClaw 安装完成"

# ============ 克隆 clawX 配置 ============
echo ""
echo -e "${BLUE}📥${NC} 克隆 clawX 配置..."
CLAWX_DIR="$HOME/.openclaw/clawX"
if [ -d "$CLAWX_DIR" ]; then
    echo -e "  clawX 已存在，更新中..."
    cd "$CLAWX_DIR"
    git pull origin main 2>/dev/null || true
else
    git clone https://github.com/akige/clawX.git "$CLAWX_DIR"
fi
echo -e "  ${GREEN}✓${NC} clawX 配置已准备"

# ============ 运行安装后配置 ============
echo ""
echo -e "${BLUE}⚙️${NC} 应用 clawX 配置..."
chmod +x "$CLAWX_DIR/post-install.sh"
echo ""

# 运行交互式配置
bash "$CLAWX_DIR/post-install.sh"
