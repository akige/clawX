# clawX 配置备份与回滚系统

## 概述

每次修改配置前自动备份，出了问题可以一键回滚。

## 快速使用

```bash
# 创建备份
~/.openclaw/workspace/scripts/config-backup.sh backup

# 查看可用备份
~/.openclaw/workspace/scripts/config-backup.sh list

# 恢复配置
~/.openclaw/workspace/scripts/config-backup.sh restore <版本号>

# 查看最新备份
~/.openclaw/workspace/scripts/config-backup.sh latest
```

---

## 详细说明

### 备份内容

自动备份以下文件：
- `openclaw.json` - 主配置
- `agents/main/agent/config.yaml` - Agent 配置
- `agents/main/agent/config.json` - Agent 配置

### 备份位置

```
~/.openclaw/config-backups/
├── backup_20260217_0115/
│   ├── openclaw.json
│   └── ...
```

---

## 你需要做的

### 出问题了想回滚？

```bash
# 查看可用备份
~/.openclaw/workspace/scripts/config-backup.sh list

# 恢复配置
~/.openclaw/workspace/scripts/config-backup.sh restore <版本号>

# 重启服务
openclaw gateway restart
```

---

## 工作原理

1. **backup** → 复制当前配置文件到备份目录
2. **restore** → 从备份目录复制回原位置
3. **Gateway 重启** → 配置变更后需要重启才生效

---
