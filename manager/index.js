#!/usr/bin/env node
const express = require('express');
const bodyParser = require('body-parser');
const { exec } = require('child_process');
const fs = require('fs');
const path = require('path');

const PORT = 19999;
const CONFIG_DIR = process.env.HOME + '/.openclaw';
const BACKUP_DIR = CONFIG_DIR + '/config-backups';
const WORKSPACE_DIR = CONFIG_DIR + '/workspace';

const app = express();
app.use(bodyParser.json());
app.use(express.static(__dirname + '/public'));

// Helper to run shell commands
const run = (cmd) => new Promise((resolve, reject) => {
    exec(cmd, { cwd: CONFIG_DIR }, (err, stdout, stderr) => {
        if (err) reject(err);
        else resolve(stdout);
    });
});

// ============ API Endpoints ============

// Get all configs
app.get('/api/configs', async (req, res) => {
    try {
        const configs = [
            { id: 'openclaw.json', name: '主配置', desc: 'OpenClaw 核心配置文件', path: CONFIG_DIR + '/openclaw.json' },
            { id: 'agent-config', name: 'Agent配置', desc: 'Agent 运行时配置', path: CONFIG_DIR + '/agents/main/agent/config.yaml' },
            { id: 'workspace', name: '工作空间', desc: '文档和记忆系统', path: WORKSPACE_DIR }
        ];
        
        // Check if each config exists
        for (let c of configs) {
            try {
                c.exists = fs.existsSync(c.path);
                if (c.exists && c.id === 'openclaw.json') {
                    const stats = fs.statSync(c.path);
                    c.modified = stats.mtime.toISOString();
                    c.size = stats.size;
                }
            } catch (e) {
                c.exists = false;
            }
        }
        
        res.json({ success: true, configs });
    } catch (e) {
        res.json({ success: false, error: e.message });
    }
});

// Get backups
app.get('/api/backups', async (req, res) => {
    try {
        if (!fs.existsSync(BACKUP_DIR)) {
            return res.json({ success: true, backups: [] });
        }
        
        const dirs = fs.readdirSync(BACKUP_DIR)
            .filter(f => fs.statSync(BACKUP_DIR + '/' + f).isDirectory())
            .map(f => {
                const stat = fs.statSync(BACKUP_DIR + '/' + f);
                return { id: f, date: f.replace('backup_', ''), time: stat.mtime.toISOString() };
            })
            .sort((a, b) => b.time.localeCompare(a.time));
        
        res.json({ success: true, backups: dirs });
    } catch (e) {
        res.json({ success: false, error: e.message });
    }
});

// Create backup
app.post('/api/backup', async (req, res) => {
    try {
        const timestamp = new Date().toISOString().replace(/[-:T]/g, '').slice(0, 14);
        const backupName = `backup_${timestamp}`;
        const backupPath = BACKUP_DIR + '/' + backupName;
        
        fs.mkdirSync(backupPath, { recursive: true });
        
        // Copy configs
        const files = ['openclaw.json'];
        for (let f of files) {
            const src = CONFIG_DIR + '/' + f;
            if (fs.existsSync(src)) {
                fs.copyFileSync(src, backupPath + '/' + f);
            }
        }
        
        // Write version info
        fs.writeFileSync(backupPath + '/version.txt', `clawX backup ${timestamp}\n`);
        
        res.json({ success: true, id: backupName, message: '备份成功' });
    } catch (e) {
        res.json({ success: false, error: e.message });
    }
});

// Restore backup
app.post('/api/restore', async (req, res) => {
    const { backupId } = req.body;
    if (!backupId) {
        return res.json({ success: false, error: '请指定备份版本' });
    }
    
    try {
        const backupPath = BACKUP_DIR + '/' + backupId;
        if (!fs.existsSync(backupPath)) {
            return res.json({ success: false, error: '备份不存在' });
        }
        
        // Copy back
        const files = ['openclaw.json'];
        for (let f of files) {
            const src = backupPath + '/' + f;
            if (fs.existsSync(src)) {
                fs.copyFileSync(src, CONFIG_DIR + '/' + f);
            }
        }
        
        res.json({ success: true, message: '恢复成功，请重启 Gateway' });
    } catch (e) {
        res.json({ success: false, error: e.message });
    }
});

// Check config validity
app.post('/api/check', async (req, res) => {
    try {
        const results = [];
        
        // Check openclaw.json
        const configPath = CONFIG_DIR + '/openclaw.json';
        if (fs.existsSync(configPath)) {
            try {
                const content = fs.readFileSync(configPath, 'utf8');
                JSON.parse(content);
                results.push({ id: 'openclaw.json', valid: true, message: '配置格式正确' });
            } catch (e) {
                results.push({ id: 'openclaw.json', valid: false, message: 'JSON 格式错误: ' + e.message });
            }
        } else {
            results.push({ id: 'openclaw.json', valid: false, message: '配置文件不存在' });
        }
        
        // Check gateway status
        try {
            const status = await run('openclaw gateway status');
            const running = status.includes('running');
            results.push({ id: 'gateway', valid: running, message: running ? 'Gateway 运行中' : 'Gateway 未运行' });
        } catch (e) {
            results.push({ id: 'gateway', valid: false, message: 'Gateway 状态检查失败' });
        }
        
        res.json({ success: true, results });
    } catch (e) {
        res.json({ success: false, error: e.message });
    }
});

// Restart gateway
app.post('/api/restart', async (req, res) => {
    try {
        await run('openclaw gateway restart');
        res.json({ success: true, message: 'Gateway 正在重启...' });
    } catch (e) {
        res.json({ success: false, error: e.message });
    }
});

// Get gateway status
app.get('/api/status', async (req, res) => {
    try {
        const output = await run('openclaw gateway status 2>&1');
        res.json({ success: true, status: output });
    } catch (e) {
        res.json({ success: false, status: e.message });
    }
});

// Start server
app.listen(PORT, () => {
    console.log(`🦞 clawX Manager running at http://localhost:${PORT}`);
});
