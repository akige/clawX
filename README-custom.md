# clawX - OpenClaw 定制版

基于 [OpenClaw](https://github.com/openclaw/openclaw) 的定制版本。

## 官方 vs 定制

| | 官方 OpenClaw | clawX (本项目) |
|---|---|---|
| 仓库 | github.com/openclaw/openclaw | github.com/akige/clawX |
| 分支 | main | custom |
| 同步 | - | 通过 upstream 合并官方更新 |

## 快速开始

### 克隆项目

```bash
git clone https://github.com/akige/openclaw.git clawX
cd clawX
```

### 安装依赖

```bash
pnpm install
```

### 启动

```bash
pnpm start
```

## 同步官方更新

```bash
# 获取官方最新代码
git fetch upstream

# 合并到 main 分支
git checkout main
git merge upstream/main

# 合并到 custom 分支
git checkout custom
git merge main
```

## 分支说明

- **main**: 与官方同步，保持最新
- **custom**: 定制分支，修改在这里进行

## 项目结构

```
clawX/
├── src/           # 源代码
├── skills/       # 技能
├── docs/         # 文档
├── scripts/      # 脚本
└── ...
```

---
定制版 by @akige
