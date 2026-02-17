# 🦞 clawX — OpenClaw 定制版

<p align="center">
  <strong>基于 OpenClaw 的增强版本</strong>
</p>

<p align="center">
  <a href="https://github.com/akige/clawX"><img src="https://img.shields.io/github/license/akige/clawX" alt="License"></a>
  <a href="https://github.com/akige/clawX/stargazers"><img src="https://img.shields.io/github/stars/akige/clawX" alt="Stars"></a>
</p>

---

## 什么是 clawX？

clawX 是基于 [OpenClaw](https://github.com/openclaw/openclaw) 的增强版本，为中文用户提供了更好的开箱即用体验。

### 主要特性

- ✅ **永久记忆系统** — 每次聊天自动记住上下文
- ✅ **配置备份与回滚** — 修改配置前自动备份，出问题一键恢复
- ✅ **本地语音转录** — Whisper 本地识别，保护隐私
- ✅ **中文文档** — 完整的中文使用指南

---

## 安装

### 一键安装（推荐）

```bash
curl -fsSL https://raw.githubusercontent.com/akige/clawX/main/install.sh | bash
```

**脚本会自动安装：**
- Node.js 22+ (如未安装)
- pnpm
- OpenClaw
- clawX 配置
- Web 管理界面

### 手动安装

```bash
# 克隆配置
git clone https://github.com/akige/clawX.git ~/.openclaw/clawX

# 运行安装脚本
cd ~/.openclaw/clawX
chmod +x install.sh
./install.sh
```

---

## Web 管理界面

安装后自动启动，访问：**http://localhost:19999**

功能：
- 📡 查看 Gateway 状态
- ⚙️ 检查配置文件
- 💾 一键备份/恢复配置
- 🔄 重启 Gateway

---

## 包含的配置

### 1. 永久记忆系统

自动记录对话上下文，重要信息永久保存。

```
~/.openclaw/workspace/
├── MEMORY.md              # 长期记忆
└── memory/
    └── YYYY-MM-DD.md    # 每日记录
```

### 2. 配置备份系统

```
~/.openclaw/workspace/scripts/config-backup.sh
```

命令：
- `backup` — 创建备份
- `restore <版本>` — 恢复配置
- `list` — 查看备份列表

### 3. 本地语音转录

需要安装 Whisper：
```bash
brew install openai-whisper
```

---

## 文档

- [中文使用指南](./docs/)
- [新成员入门](./docs/new-openclaw.md)
- [配置备份说明](./docs/config-backup.md)
- [记忆系统说明](./docs/memory-system.md)

---

## 与官方版本的区别

| 功能 | OpenClaw 官方 | clawX |
|------|--------------|-------|
| 安装方式 | npm install | curl 一键安装 |
| 中文支持 | 基础 | 完整优化 |
| 记忆系统 | 无 | ✅ 开箱即用 |
| 配置备份 | 无 | ✅ 自动备份 |
| 语音转录 | 无 | ✅ 本地 Whisper |

---

## 更新 clawX

```bash
cd ~/.openclaw/clawX

# 获取官方最新
git fetch upstream

# 合并到 main
git checkout main
git merge upstream/main

# 合并到 custom
git checkout custom
git merge main

# 推送
git push origin main custom
```

---

## 参与贡献

欢迎提交 Issue 和 Pull Request！

---

## 许可证

MIT License - 基于 [OpenClaw](https://github.com/openclaw/openclaw)

---

<p align="center">
  Made with 🦞 by <a href="https://github.com/akige">@akige</a>
</p>
