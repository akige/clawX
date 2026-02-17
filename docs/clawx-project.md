# clawX 项目 - OpenClaw 定制版

## 概述

基于官方 [OpenClaw](https://github.com/openclaw/openclaw) (202k stars) 的定制版本。

## 仓库信息

| 项目 | 地址 |
|------|------|
| 官方仓库 | https://github.com/openclaw/openclaw |
| 定制仓库 (clawX) | https://github.com/akige/clawX |
| 本地路径 | `~/.openclaw/clawX/` |

## 分支结构

```
├── main     # 与官方同步，保持最新
└── custom  # 定制分支，修改在这里进行
```

## Git 远程配置

```bash
origin   # 你的仓库 (akige/openclaw)
upstream # 官方仓库 (openclaw/openclaw)
```

## 同步官方更新

### 步骤

```bash
cd ~/.openclaw/clawX

# 1. 获取官方最新代码
git fetch upstream

# 2. 切换到 main 并合并官方更新
git checkout main
git merge upstream/main

# 3. 合并到 custom 分支
git checkout custom
git merge main

# 4. 推送更新
git push origin main custom
```

### 定期同步

建议每隔一段时间（如每周）同步一次官方更新：
```bash
# 快速同步命令
git fetch upstream && git checkout main && git merge upstream/main && git checkout custom && git merge main && git push origin main custom
```

## 项目结构

```
clawX/
├── src/           # 源代码
├── skills/        # 技能
├── docs/          # 文档
├── scripts/       # 脚本
├── extensions/    # 扩展
├── apps/          # 应用
└── ...
```

## 安装和运行

```bash
# 进入目录
cd ~/.openclaw/clawX

# 安装依赖
pnpm install

# 启动
pnpm start
```

## 定制记录

### 2026-02-17

- [x] Fork 官方仓库到 akige/openclaw
- [x] 克隆到本地 ~/.openclaw/clawX
- [x] 添加 upstream 远程仓库
- [x] 创建 custom 分支
- [x] 推送到 GitHub
- [x] 创建定制版 README (README-custom.md)

## 相关文档

- [[memory/2026-02-17]] - 当日对话记录
- [[docs/config-backup]] - 配置备份系统
- [[docs/memory-system]] - 永久记忆系统

---
更新：2026-02-17
