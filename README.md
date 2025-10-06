# Claude Code Agentic Engineering

> Advanced slash commands and subagents for Claude Code that create a complete task-to-implementation pipeline with intelligent delegation and context management.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-Compatible-blue)](https://claude.ai/code)

## 🚀 Quick Start

```bash
# Install in existing project
uvx --from git+https://github.com/ItamarZand88/claude-code-agentic-engineering.git agentic install

# Start Claude Code and verify installation
claude
/help    # Should show your new commands
/agents  # Should show your new subagents
```

### ⚡ Even Easier with Aliases!

Tired of typing the long command? Set up a short alias:

**PowerShell (Windows):**
```powershell
# Run once to set up
.\setup-aliases.ps1

# Now use the short command
agi
```

**Bash/Zsh (Linux/Mac):**
```bash
# Run once to set up
source setup-aliases.sh

# Now use the short command
agi
```

See [ALIASES.md](ALIASES.md) for permanent setup instructions.

### 📦 All Installation Options

```bash
# Initialize new project
uvx --from git+https://github.com/ItamarZand88/claude-code-agentic-engineering.git agentic init my-project

# Install in existing project
uvx --from git+https://github.com/ItamarZand88/claude-code-agentic-engineering.git agentic install

# Check installation status
uvx --from git+https://github.com/ItamarZand88/claude-code-agentic-engineering.git agentic status
```

## 🎯 What This Gives You

Transform your development workflow with **5 powerful slash commands** and **5 specialized AI subagents** that work together to create a self-improving engineering system.

### ⚡ The Complete Workflow

```bash
# 1. 🔍 Context-aware requirements gathering
/get_context "authentication patterns"
/task-from-scratch "Add OAuth integration with Google"

# 2. 📋 Intelligent planning with historical context  
/plan-from-task "./tasks/oauth-task.md"

# 3. 🛠️ Safe implementation with progress tracking
/implement-plan "./plans/oauth-plan.md" --dry-run
/implement-plan "./plans/oauth-plan.md"

# 4. ✅ Comprehensive quality review
/review-implementation "./plans/oauth-plan.md" --severity=medium

# 5. 🧠 Knowledge capture for future benefit
/update_context ./context/oauth-20240120.md
```

## 🔧 Slash Commands

| Command | Purpose | Key Features |
|---------|---------|-------------|
| `/task-from-scratch` | Requirements analysis | Context discovery, clarification questions, comprehensive specs |
| `/plan-from-task` | Implementation planning | Risk assessment, testing strategy, rollback planning |
| `/implement-plan` | Safe execution | Git branching, dry-run mode, progress tracking |
| `/review-implementation` | Quality assurance | Security scan, performance analysis, technical debt assessment |
| `/get_context` | Context discovery | Project patterns, architecture insights, code examples |
| `/download-templates` | Template installer | Downloads latest templates and configurations |

## 🤖 Specialized Subagents

| Agent | Expertise | Auto-Invoked For |
|-------|-----------|------------------|
| **File Analysis Agent** | Code structure & patterns | Individual file analysis, dependency mapping |
| **Git History Agent** | Decision context extraction | Historical analysis, evolution tracking |
| **Dependency Scanner** | Security & package analysis | Vulnerability scanning, integration mapping |
| **Pattern Recognition** | Architecture & design patterns | Pattern detection, anti-pattern identification |
| **Documentation Extractor** | Knowledge synthesis | Documentation analysis, gap identification |

## 📁 Repository Structure

```
claude-code-agentic-engineering/
├── 📋 README.md                           # This file
├── 🚀 setup.sh                            # One-click installation script (Linux/Mac)
├── 🚀 setup.ps1                           # One-click installation script (Windows)
├── 📜 LICENSE                             # MIT License
├── commands/                              # Slash Commands
│   ├── task-from-scratch.md
│   ├── plan-from-task.md
│   ├── implement-plan.md
│   ├── review-implementation.md
│   └── get-context.md
├── agents/                                # Subagents
│   ├── file-analysis-agent.md
│   ├── git-history-agent.md
│   ├── dependency-scanner-agent.md
│   ├── pattern-recognition-agent.md
│   └── documentation-extractor-agent.md
├── templates/                             # Professional Templates
│   ├── task-requirements-template.md
│   ├── implementation-plan-template.md
│   ├── code-review-template.md
│   ├── coding-standards-template.md
│   ├── security-checklist-template.md
│   └── README.md
├── docs/                                  # Documentation
│   ├── WORKFLOW_GUIDE.md
│   ├── CUSTOMIZATION.md
│   └── TROUBLESHOOTING.md
└── examples/                              # Usage Examples
    ├── basic-workflow.md
    ├── advanced-patterns.md
    └── team-collaboration.md
```

## 🎨 Key Features

### 🧠 **Intelligence Compound Effect**
Each command makes the next one smarter by building institutional memory through the context map system.

### 🛡️ **Safety First**
- Git branching for all implementations
- Dry-run modes for testing
- Comprehensive rollback procedures
- Progress tracking and error recovery

### 🔄 **Self-Improving System**
- Context accumulates with each task
- Decision rationale is preserved
- Patterns are learned and reused
- Team knowledge is captured automatically

### 🎯 **Stakeholder Trifecta Optimization**
Designed for three audiences:
- **You**: Get better results faster with accumulated knowledge
- **Your Team**: Share context through simple markdown files
- **Your Agents**: Operate with full project context instead of starting from scratch

## 🚀 Installation

### Option 1: CLI Tool (Recommended)
Use the `agentic` CLI tool for the best experience:

```bash
# The examples above using uvx
uvx --from git+https://github.com/ItamarZand88/claude-code-agentic-engineering.git agentic init my-project
```

### Option 2: Direct Install Scripts
```bash
# Linux/Mac
curl -sSL https://raw.githubusercontent.com/ItamarZand88/claude-code-agentic-engineering/main/install.sh | bash

# Windows PowerShell  
iwr -useb https://raw.githubusercontent.com/ItamarZand88/claude-code-agentic-engineering/main/install.ps1 | iex

# Custom directory
curl -sSL https://raw.githubusercontent.com/ItamarZand88/claude-code-agentic-engineering/main/install.sh | bash -s my-project

# Templates only
curl -sSL https://raw.githubusercontent.com/ItamarZand88/claude-code-agentic-engineering/main/install.sh | bash -s -- --templates-only
```

### Option 2: Clone Repository
```bash
git clone https://github.com/ItamarZand88/claude-code-agentic-engineering.git
cd claude-code-agentic-engineering
chmod +x setup.sh && ./setup.sh
```

### Option 3: Manual Download
Use the `/download-templates` command within Claude Code:
```bash
claude
/download-templates --target-dir=./my-project
```
```bash
# Create directories
mkdir -p .claude/commands .claude/agents

# Copy command files
cp commands/*.md .claude/commands/
cp agents/*.md .claude/agents/

# Verify installation
claude
/help
/agents
```

## 💡 Usage Examples

### Basic Feature Development
```bash
/task-from-scratch "Add dark mode toggle to the header"
/plan-from-task "./tasks/dark-mode-task.md"
/implement-plan "./plans/dark-mode-plan.md"
/review-implementation "./plans/dark-mode-plan.md"
```

### Complex System Integration
```bash
/get_context "payment systems"
/task-from-scratch "Integrate Stripe payments with subscription management"
/plan-from-task "./tasks/stripe-integration-task.md"
/implement-plan "./plans/stripe-plan.md" --dry-run
/implement-plan "./plans/stripe-plan.md"
/update_context ./context/context-file.md
```

### Quality & Security Review
```bash
/review-implementation "./plans/auth-system-plan.md" --severity=high
/get_context "security patterns" 
```

## 🔧 Customization

All commands and agents are fully customizable:

1. **Modify command behavior** by editing files in `commands/`
2. **Customize agent expertise** by updating files in `agents/`
3. **Add new commands** by creating new `.md` files
4. **Create specialized agents** for your domain-specific needs

See [CUSTOMIZATION.md](docs/CUSTOMIZATION.md) for detailed guidance.

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md).

### Ways to Contribute:
- 🐛 Report bugs and issues
- 💡 Suggest new commands or agents
- 📖 Improve documentation
- 🔧 Submit pull requests
- ⭐ Star the repository if you find it useful!

## 📚 Documentation

- [Workflow Guide](docs/WORKFLOW_GUIDE.md) - Complete workflow examples
- [Customization Guide](docs/CUSTOMIZATION.md) - How to customize commands and agents  
- [Troubleshooting](docs/TROUBLESHOOTING.md) - Common issues and solutions
- [Advanced Patterns](examples/advanced-patterns.md) - Complex usage patterns

## 🔄 Changelog

### v1.0.0 (2025-01-XX)
- 🚀 Initial release with 5 slash commands and 5 subagents
- 🛡️ Complete safety features (git branching, dry-run, rollback)
- 🧠 Context map system for knowledge accumulation
- 📖 Comprehensive documentation and examples

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built for [Claude Code](https://claude.ai/code) by Anthropic
- Inspired by agentic prompt engineering principles
- Follows the "prompt as fundamental unit of engineering" philosophy

## ⭐ Star This Repository

If this project helps you build better software faster, please consider giving it a star! It helps others discover this work.

---

**Built with ❤️ for the Claude Code community**

> "The prompt is the fundamental unit of engineering. And with agents, every prompt you create becomes a force multiplier." - The future of software development is here.
