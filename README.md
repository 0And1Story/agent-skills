# agent-skills

存放自己编写的日常 skills。仓库根目录下，每个文件夹对应一个 skill：

```text
agent-skills/
├── install.sh
├── install.ps1
├── README.md
├── my-skill/
│   └── SKILL.md
└── another-skill/
    ├── SKILL.md
    └── scripts/
```

## Skills

- [research-weekly-report](research-weekly-report/SKILL.md)：按上周计划、本周完成情况、下周计划整理中文科研周报，附可独立使用的 one-shot 提示词。
- [project-bootstrap](project-bootstrap/SKILL.md)：显式调用的项目初始化与任务线迁移。默认建立单任务线规则与本地 Git；支持英文、中文规则模板，只有明确要求时才分离任务线。项目日常工作不隐式启用，也不需要反复调用。

## 安装

脚本将每个 skill 文件夹链接到安装目录，修改仓库中的内容会直接生效，无需重新复制。新增 skill 后再运行一次即可。

### Linux

```bash
# 默认安装到 Codex
bash install.sh
bash install.sh codex

# 安装到 Claude Code
bash install.sh claude

# 自定义安装目录；-p 与 --path 等效
bash install.sh -p "$HOME/.agents/skills"

# 查看帮助
bash install.sh --help
```

### Windows

```powershell
# 默认安装到 Codex
.\install.ps1
.\install.ps1 codex

# 安装到 Claude Code
.\install.ps1 claude

# PowerShell 支持 -Path、--path 和 -p
.\install.ps1 -p "$HOME\.agents\skills"

# 查看帮助
.\install.ps1 -Help
```
