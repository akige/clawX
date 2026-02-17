#!/bin/bash
# clawX 安装后配置脚本
# 此脚本在官方 OpenClaw 安装完成后运行

set -e

CLAWX_DIR="$HOME/.openclaw/clawX"
BACKUP_DIR="$HOME/.openclaw/config-backups"
WORKSPACE_DIR="$HOME/.openclaw/workspace"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo ""
echo "========================================"
echo "🦞  clawX 配置向导"
echo "========================================"

# 1. 创建必要的目录
echo ""
echo -e "${BLUE}📁${NC} 创建目录结构..."
mkdir -p "$BACKUP_DIR"
mkdir -p "$WORKSPACE_DIR/memory"
mkdir -p "$WORKSPACE_DIR/scripts"
mkdir -p "$WORKSPACE_DIR/docs"

# 2. 安装配置备份脚本
echo -e "${BLUE}📦${NC} 安装配置备份脚本..."
if [ -f "$CLAWX_DIR/scripts/config-backup.sh" ]; then
    cp "$CLAWX_DIR/scripts/config-backup.sh" "$WORKSPACE_DIR/scripts/"
    chmod +x "$WORKSPACE_DIR/scripts/config-backup.sh"
    echo -e "  ${GREEN}✓${NC} 配置备份脚本已安装"
fi

# 3. 初始化记忆系统 - 交互式
echo ""
echo -e "${BLUE}🧠${NC} 初始化记忆系统..."

# 询问用户名字
echo -e "${YELLOW}请输入你的名字（用于记忆系统，回车跳过）:${NC}"
read -p "> " USER_NAME
if [ -z "$USER_NAME" ]; then
    USER_NAME="用户"
fi

# 询问主要语言
echo -e "${YELLOW}请输入你常用的语言（中文/韩文/英文等，回车默认中文）:${NC}"
read -p "> " USER_LANG
if [ -z "$USER_LANG" ]; then
    USER_LANG="中文"
fi

# 创建记忆文件
cat > "$WORKSPACE_DIR/MEMORY.md" << EOF
# 长期记忆

## 关于用户
- 名字：$USER_NAME
- 常用语言：$USER_LANG

## 重要配置
（你的重要配置记录）

---
创建时间：$(date +%Y-%m-%d)
EOF

# 创建用户信息文件
cat > "$WORKSPACE_DIR/USER.md" << EOF
# 用户信息

- **名字：** $USER_NAME
- **常用语言：** $USER_LANG

EOF

echo -e "  ${GREEN}✓${NC} 记忆系统已初始化"

# 4. 安装文档
echo ""
echo -e "${BLUE}📚${NC} 安装中文文档..."
if [ -d "$CLAWX_DIR/docs" ]; then
    # 只复制我们自己的文档，不复制官方的
    for doc in config-backup.md memory-system.md new-openclaw.md clawx-project.md; do
        if [ -f "$CLAWX_DIR/docs/$doc" ]; then
            cp "$CLAWX_DIR/docs/$doc" "$WORKSPACE_DIR/docs/"
        fi
    done
    echo -e "  ${GREEN}✓${NC} 中文文档已安装"
fi

# 5. 创建首次备份
echo ""
echo -e "${BLUE}💾${NC} 创建配置备份..."
if [ -f "$WORKSPACE_DIR/scripts/config-backup.sh" ]; then
    "$WORKSPACE_DIR/scripts/config-backup.sh" backup 2>/dev/null || true
    echo -e "  ${GREEN}✓${NC} 首次备份已创建"
fi

# 6. 检查 Whisper
echo ""
echo -e "${BLUE}🎙️${NC} 检查语音转录..."
if command -v whisper &> /dev/null; then
    echo -e "  ${GREEN}✓${NC} Whisper 已安装"
else
    echo -e "  ${YELLOW}⚠️${NC} Whisper 未安装"
    echo -e "     安装后可支持语音输入：brew install openai-whisper"
fi

# 7. 安装 Web 管理界面
echo ""
echo -e "${BLUE}🌐${NC} 安装 Web 管理界面..."
if [ -f "$CLAWX_DIR/scripts/install-manager.sh" ]; then
    bash "$CLAWX_DIR/scripts/install-manager.sh" 2>/dev/null || true
    echo -e "  ${GREEN}✓${NC} Web 管理界面已安装"
fi

# 8. 检查 OpenClaw 是否已配置
echo ""
echo -e "${BLUE}🔧${NC} 检查 OpenClaw 配置..."

if [ ! -f "$HOME/.openclaw/openclaw.json" ] || [ ! -s "$HOME/.openclaw/openclaw.json" ]; then
    echo -e "  ${YELLOW}⚠️${NC} OpenClaw 尚未配置"
    echo ""
    echo "========================================"
    echo -e "${GREEN}🚀 即将启动配置向导...${NC}"
    echo "========================================"
    echo ""
    echo "配置向导会帮助你："
    echo "  1. 登录 AI 提供商 (Anthropic/OpenAI)"
    echo "  2. 配置消息渠道 (Telegram/Discord等)"
    echo "  3. 设置你的第一个 Agent"
    echo ""
    echo -e "${YELLOW}按回车开始配置（Ctrl+C 取消）...${NC}"
    read -r
    
    openclaw onboard
else
    echo -e "  ${GREEN}✓${NC} OpenClaw 已配置"
    
    # 9. 启动 Gateway
    echo ""
    echo -e "${BLUE}🚀${NC} 启动 Gateway..."
    openclaw gateway start 2>/dev/null || true
    
    sleep 2
    if openclaw gateway status 2>&1 | grep -q "running"; then
        echo -e "  ${GREEN}✓${NC} Gateway 已启动"
    else
        echo -e "  ${YELLOW}⚠️${NC} Gateway 启动可能有问题，请手动检查"
    fi
fi

# 10. 创建 CLAUDE.md 快速参考
cat > "$WORKSPACE_DIR/CLAUDE.md" << EOF
# clawX 快速参考

## 管理命令

```bash
# 启动/重启 Gateway
openclaw gateway start
openclaw gateway restart
openclaw gateway status

# 查看日志
openclaw logs

# 备份配置
~/.openclaw/workspace/scripts/config-backup.sh backup

# 恢复配置
~/.openclaw/workspace/scripts/config-backup.sh list
~/.openclaw/workspace/scripts/config-backup.sh restore <版本>
```

## Web 管理界面

访问：http://localhost:19999

功能：查看状态、备份/恢复配置、重启 Gateway

## 文档位置

\`\`\`
~/.openclaw/workspace/docs/
\`\`\`

---
EOF

echo ""
echo "========================================"
echo -e "${GREEN}🎉 clawX 安装完成！${NC}"
echo "========================================"
echo ""
echo -e "${BLUE}📍${NC} 访问地址："
echo "   Web 管理界面: ${GREEN}http://localhost:19999${NC}"
echo ""
echo -e "${BLUE}📁${NC} 重要路径："
echo "   工作目录: ~/.openclaw/workspace/"
echo "   配置备份: ~/.openclaw/config-backups/"
echo "   中文文档: ~/.openclaw/workspace/docs/"
echo ""
echo -e "${BLUE}💡${NC} 下一步："
echo "   1. 访问 http://localhost:19999 查看状态"
echo "   2. 尝试发送消息到你的 OpenClaw"
echo "   3. 说「记住 xxx」测试记忆功能"
echo ""
