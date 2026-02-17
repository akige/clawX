# clawX 新成员入门指南

欢迎！这是 clawX —— 基于 OpenClaw 的增强版本。

---

## 快速开始

### 1. 安装

```bash
curl -fsSL https://raw.githubusercontent.com/akige/clawX/main/install.sh | bash
```

或者手动安装：

```bash
# 安装依赖
brew install node pnpm openai-whisper

# 安装 OpenClaw
npm install -g openclaw@latest
openclaw onboard

# 克隆配置
git clone https://github.com/akige/clawX.git ~/.openclaw/clawX
cd ~/.openclaw/clawX
./post-install.sh
```

### 2. 配置

1. 运行 `openclaw onboard` 完成基础配置
2. 编辑 `~/.openclaw/workspace/MEMORY.md` 填写你的信息

### 3. 启动

```bash
openclaw gateway start
```

---

## clawX 特性

### ✅ 永久记忆系统

每次聊天自动记录上下文，重要信息永久保存。

### ✅ 配置备份与回滚

修改配置前自动备份，出问题一键恢复：

```bash
# 备份
~/.openclaw/workspace/scripts/config-backup.sh backup

# 恢复
~/.openclaw/workspace/scripts/config-backup.sh restore <版本>
```

### ✅ 本地语音转录

安装 Whisper 后可以直接发语音：

```bash
brew install openai-whisper
```

---

## 文档

更多文档：`~/.openclaw/workspace/docs/`

---

## 更新 clawX

```bash
cd ~/.openclaw/clawX
git fetch upstream
git checkout main
git merge upstream/main
git push origin main
```

---

有问题？提 Issue: https://github.com/akige/clawX/issues

---
