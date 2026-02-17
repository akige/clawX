#!/bin/bash
# OpenClaw 配置备份脚本
# 用法: ./config-backup.sh [restore|list|cleanup]

set -e

CONFIG_DIR="$HOME/.openclaw"
BACKUP_DIR="$CONFIG_DIR/config-backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# 需要备份的配置文件
FILES=(
    "openclaw.json"
    "agents/main/agent/config.yaml"
    "agents/main/agent/config.json"
)

mkdir -p "$BACKUP_DIR"

case "$1" in
    backup)
        echo "📦 创建配置备份: $TIMESTAMP"
        BACKUP_NAME="backup_$TIMESTAMP"
        BACKUP_PATH="$BACKUP_DIR/$BACKUP_NAME"
        mkdir -p "$BACKUP_PATH"
        
        for file in "${FILES[@]}"; do
            if [ -f "$CONFIG_DIR/$file" ]; then
                cp -r "$CONFIG_DIR/$file" "$BACKUP_PATH/"
                echo "  ✅ $file"
            fi
        done
        
        # 记录版本信息
        echo "$TIMESTAMP" > "$BACKUP_PATH/version.txt"
        echo "OpenClaw $(openclaw --version 2>/dev/null || echo 'unknown')" >> "$BACKUP_PATH/version.txt"
        
        echo "📁 备份位置: $BACKUP_PATH"
        echo "完成！"
        ;;
        
    restore)
        if [ -z "$2" ]; then
            echo "❌ 请指定备份版本 (用 list 查看)"
            exit 1
        fi
        BACKUP_PATH="$BACKUP_DIR/backup_$2"
        
        if [ ! -d "$BACKUP_PATH" ]; then
            echo "❌ 备份不存在: $2"
            exit 1
        fi
        
        echo "⚠️  确认要恢复备份 $2 吗？这会覆盖当前配置。"
        read -p "输入 'yes' 确认: " confirm
        
        if [ "$confirm" = "yes" ]; then
            for file in "${FILES[@]}"; do
                if [ -f "$BACKUP_PATH/$file" ]; then
                    cp -r "$BACKUP_PATH/$file" "$CONFIG_DIR/$file"
                    echo "  ✅ 恢复 $file"
                fi
            done
            echo "✅ 恢复完成！运行 'openclaw gateway restart' 重启服务"
        else
            echo "已取消"
        fi
        ;;
        
    list)
        echo "📋 可用备份:"
        ls -1t "$BACKUP_DIR" | while read dir; do
            version=$(cat "$BACKUP_DIR/$dir/version.txt" 2>/dev/null | head -1 || echo "unknown")
            echo "  - $dir ($version)"
        done
        ;;
        
    latest)
        latest=$(ls -1t "$BACKUP_DIR" | head -1)
        if [ -n "$latest" ]; then
            echo "最新备份: $latest"
            ls -la "$BACKUP_DIR/$latest"
        else
            echo "没有备份"
        fi
        ;;
        
    *)
        echo "用法: $0 {backup|restore|list|latest}"
        echo ""
        echo "命令:"
        echo "  backup         - 创建新备份"
        echo "  restore <版本> - 恢复指定版本"
        echo "  list           - 列出所有备份"
        echo "  latest         - 查看最新备份"
        exit 1
        ;;
esac
