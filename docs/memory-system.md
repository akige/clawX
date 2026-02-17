# clawX 永久记忆系统

## 概述

**自动记录，你无需操作。** 每次聊天我都知道上下文。

---

## 我怎么记录

### 每次聊天开始时

自动加载：
- `memory/今天.md` - 当天对话要点
- `memory/昨天.md` - 昨天对话（防止遗漏）
- `MEMORY.md` - 长期记忆

### 对话过程中

- 重要信息 → 写入当天记录
- 你说"记住 xxx" → 写入 MEMORY.md

---

## 你需要做的

**只要记住：**
- 说"记住 xxx" = 永久记住
- 其他的我会自动处理

---

## 查看记忆

```bash
# 长期记忆
cat ~/.openclaw/workspace/MEMORY.md

# 今天的记录
cat ~/.openclaw/workspace/memory/2026-02-17.md
```

---

## 文件位置

```
~/.openclaw/workspace/
├── MEMORY.md              # 长期记忆
└── memory/
    └── YYYY-MM-DD.md      # 每日记录
```

---
