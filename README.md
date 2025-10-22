# Claude Code Agentic Engineering

> A comprehensive agentic engineering framework for Claude Code featuring specialized agents and structured workflows for task-to-implementation automation with intelligent orchestration and quality assurance.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-Compatible-blue)](https://claude.ai/code)

## 🚀 Quick Start

```bash
# Install in existing project
uvx --from git+https://github.com/ItamarZand88/claude-code-agentic-engineering.git agentic install

# Start Claude Code and verify installation
claude
/help    # Should show your new commands
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

Transform your development workflow with a **4-step core workflow** plus **setup commands** and **9 specialized AI agents** that work together to create a comprehensive engineering system.

### ⚡ The Complete Workflow

```bash
# 0. 📋 One-time setup: Generate project coding standards
/standards

# 1. 🎫 Comprehensive task ticket creation with deep analysis
/1_ticket "Add OAuth integration with Google"

# 2. 📐 Research-driven implementation planning
/2_plan Circle/add-oauth-integration

# 3. 🛠️ Execute implementation following the plan
/3_implement Circle/add-oauth-integration

# 4. ✅ Comprehensive quality review and validation
/4_review Circle/add-oauth-integration
```

All task artifacts are organized in the `Circle/` directory:
```
Circle/
├── {task-name}/
│   ├── ticket.md     # Task requirements and acceptance criteria
│   ├── plan.md       # Research-driven implementation plan
│   └── review.md     # Code review and quality assessment
└── standards/
    └── README.md     # Project coding standards
```

## 🔧 Slash Commands

### Core Workflow Commands

| Command | Purpose | Key Features |
|---------|---------|-------------|
| `/1_ticket <description>` | Task ticket creation | Deep codebase analysis, parallel agent coordination, clarification questions, comprehensive requirements |
| `/2_plan <task_folder>` | Implementation planning | Web research, architecture decisions, phase-based breakdown, pattern discovery |
| `/3_implement <task_folder>` | Execute implementation | Direct implementation, git management, testing validation, progress tracking |
| `/4_review <task_folder>` | Quality assurance | Automated QA checks, standards compliance, security & performance analysis |

### Setup & Utility Commands

| Command | Purpose | When to Use |
|---------|---------|-------------|
| `/standards` | Generate project standards | Run once per project or when standards evolve |
| `/checks` | Run quality checks | TypeScript, Prettier, Lint validation |
| `/fix-pr-comments <pr_number>` | Fix PR review comments | Address code review feedback |
| `/all` | Complete workflow | Run all 4 steps in sequence |

## 🤖 Specialized Agents

The framework includes 9 specialized agents organized by workflow phase:

### 🔍 Exploration & Analysis (used in `/1_ticket`)
| Agent | Expertise |
|-------|-----------|
| **architecture-explorer** | Project structure, tech stack mapping, directory organization |
| **feature-finder** | Similar implementation discovery, pattern extraction, integration points |
| **dependency-mapper** | Internal/external dependency mapping, API integration analysis |

### 📐 Planning & Design (used in `/2_plan`)
| Agent | Expertise |
|-------|-----------|
| **codebase-analyst** | Pattern discovery, conventions, architecture understanding |
| **implementation-strategist** | Architectural decision-making, trade-off analysis, approach evaluation |

### ✅ Review & Quality (used in `/4_review`)
| Agent | Expertise |
|-------|-----------|
| **code-reviewer** | Comprehensive code review, QA automation, standards compliance, security & performance |
| **quality-assurance-agent** | Automated lint, typecheck, format validation |
| **standards-compliance-agent** | Validates code against Circle/standards/ |

### 📋 Standards Generation (used in `/standards`)
| Agent | Expertise |
|-------|-----------|
| **standards-generator** | Analyzes codebase to generate project-specific coding standards |

## 📁 Repository Structure

```
claude-code-agentic-engineering/
├── 📋 README.md                           # This file
├── 📋 CLAUDE.md                           # Project context for Claude
├── 🚀 setup-aliases.sh/ps1                # Alias setup scripts
├── 📜 LICENSE                             # MIT License
├── commands/                              # Slash Commands
│   ├── 1_ticket.md                        # Task ticket creation
│   ├── 2_plan.md                          # Implementation planning
│   ├── 3_implement.md                     # Execute implementation
│   ├── 4_review.md                        # Quality review
│   ├── standards.md                       # Generate standards
│   ├── checks.md                          # Run quality checks
│   ├── fix-pr-comments.md                 # Fix PR comments
│   └── all.md                             # Complete workflow
├── agents/                                # Specialized Agents
│   ├── architecture-explorer.md
│   ├── feature-finder.md
│   ├── dependency-mapper.md
│   ├── codebase-analyst.md
│   ├── implementation-strategist.md
│   ├── code-reviewer.md
│   ├── quality-assurance-agent.md
│   ├── standards-compliance-agent.md
│   └── standards-generator.md
├── src/                                   # CLI implementation
│   └── claude_agentic/
│       ├── cli.py                         # Main CLI tool
│       └── commands/                      # CLI command handlers
└── Circle/                                # Generated task workspaces
    ├── {task-name}/                       # Task-specific folder
    │   ├── ticket.md
    │   ├── plan.md
    │   └── review.md
    └── standards/                         # Project coding standards
        └── README.md
```

## 🎨 Key Features

### 🧠 **Intelligent Agent Orchestration**
- **Parallel execution**: Multiple agents run concurrently for maximum speed
- **Phase-specific specialization**: Each workflow phase uses optimized agents
- **Comprehensive analysis**: Deep codebase understanding before implementation

### 🛡️ **Safety & Quality First**
- Git branching and status checks for all implementations
- Testing validation at each phase
- Comprehensive code review with automated QA
- Standards compliance validation
- Security and performance analysis

### 📋 **Organized Task Management**
- All artifacts organized in `Circle/{task-name}/` folders
- Clear separation of ticket, plan, and review
- Project-wide standards in `Circle/standards/`
- Easy tracking and collaboration

### 🔬 **Research-Driven Development**
- Web research integration during planning phase
- Pattern discovery from existing codebase
- Architecture decision rationale documentation
- Best practices integration

## 🚀 Installation

### Option 1: CLI Tool (Recommended)
Use the `agentic` CLI tool for the best experience:

```bash
# Initialize new project
uvx --from git+https://github.com/ItamarZand88/claude-code-agentic-engineering.git agentic init my-project

# Install in existing project
uvx --from git+https://github.com/ItamarZand88/claude-code-agentic-engineering.git agentic install

# Check status
uvx --from git+https://github.com/ItamarZand88/claude-code-agentic-engineering.git agentic status
```

### Option 2: Direct Install Scripts
```bash
# Linux/Mac
curl -sSL https://raw.githubusercontent.com/ItamarZand88/claude-code-agentic-engineering/main/install.sh | bash

# Windows PowerShell
iwr -useb https://raw.githubusercontent.com/ItamarZand88/claude-code-agentic-engineering/main/install.ps1 | iex
```

### Option 3: Manual Installation
```bash
# Clone repository
git clone https://github.com/ItamarZand88/claude-code-agentic-engineering.git
cd claude-code-agentic-engineering

# Create directories in your project
mkdir -p .claude/commands .claude/agents

# Copy files
cp commands/*.md .claude/commands/
cp agents/*.md .claude/agents/

# Verify installation
claude
/help
```

## 💡 Usage Examples

### Basic Feature Development
```bash
# Generate standards first (one-time setup)
/standards

# Then follow the 4-step workflow
/1_ticket "Add dark mode toggle to the header"
/2_plan Circle/add-dark-mode-toggle
/3_implement Circle/add-dark-mode-toggle
/4_review Circle/add-dark-mode-toggle
```

### Complex System Integration
```bash
# Setup
/standards

# Create comprehensive ticket with deep analysis
/1_ticket "Integrate Stripe payments with subscription management"

# Research-driven planning
/2_plan Circle/integrate-stripe-payments

# Execute implementation
/3_implement Circle/integrate-stripe-payments

# Comprehensive review
/4_review Circle/integrate-stripe-payments
```

### Complete Workflow (All in One)
```bash
# Run all 4 steps sequentially
/all "Add user authentication with email verification"
```

### Quality & Standards
```bash
# Generate or update project standards
/standards

# Run quality checks
/checks

# Fix PR review comments
/fix-pr-comments 123
```

## 🔧 Customization

All commands and agents are fully customizable:

1. **Modify command behavior** by editing files in `commands/`
2. **Customize agent expertise** by updating files in `agents/`
3. **Add new commands** by creating new `.md` files in `.claude/commands/`
4. **Create specialized agents** for your domain-specific needs

Each command and agent uses XML-structured prompts for optimal Claude performance.

## 📚 Core Principles

### XML-Structured Prompts
All prompts use XML tags for clear organization:
```xml
<instruction>
Clear task description
</instruction>

<context>
Relevant background information
</context>

<thinking>
Step-by-step reasoning process
</thinking>

<output>
Expected output format
</output>
```

### Task-First Approach
1. Start with clear requirements (`/1_ticket`)
2. Research and plan thoroughly (`/2_plan`)
3. Execute with validation (`/3_implement`)
4. Review comprehensively (`/4_review`)

### Knowledge Preservation
- All decisions documented in task folders
- Standards captured in `Circle/standards/`
- Patterns discovered and reused
- Context maintained across tasks

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md).

### Ways to Contribute:
- 🐛 Report bugs and issues
- 💡 Suggest new commands or agents
- 📖 Improve documentation
- 🔧 Submit pull requests
- ⭐ Star the repository if you find it useful!

## 📚 Documentation

- [CLAUDE.md](CLAUDE.md) - Project context for Claude Code
- [ALIASES.md](ALIASES.md) - CLI alias setup guide

## 🔄 Changelog

### v2.0.0 (Latest)
- 🔄 Streamlined to 4-step core workflow
- 📁 Organized task management in `Circle/` directory
- 🤖 Expanded to 9 specialized agents
- 📋 Added `/standards` for project-wide coding standards
- ⚡ Improved parallel agent coordination
- 🎯 Phase-optimized agent specialization

### v1.0.0 (Initial)
- 🚀 Initial release with basic workflow
- 🛡️ Git branching and safety features
- 📖 Comprehensive documentation

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built for [Claude Code](https://claude.ai/code) by Anthropic
- Inspired by agentic prompt engineering principles
- Follows XML-structured prompt best practices

## ⭐ Star This Repository

If this project helps you build better software faster, please consider giving it a star! It helps others discover this work.

---

**Built with ❤️ for the Claude Code community**

> "The future of software engineering is agentic, collaborative, and intelligent."
