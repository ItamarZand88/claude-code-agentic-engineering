---
description: Downloads and sets up all templates and configuration files for your project
model: claude-sonnet-4
allowed-tools: read, write, bash
argument-hint: [--target-dir=path] [--templates-only] [--config-only]
---

# Download Templates and Setup

Download all professional templates, configuration files, and setup scripts from the Claude Code Agentic Engineering repository to your local project.

## Variables
- **target_directory**: $1 - Target directory for downloads (default: current directory)
- **download_mode**: $2 - Download mode: all, templates-only, config-only (default: all)
- **source_repo**: `https://github.com/ItamarZand88/claude-code-agentic-engineering` - Source repository
- **templates_url**: `https://raw.githubusercontent.com/ItamarZand88/claude-code-agentic-engineering/main` - Raw files URL

## Workflow

1. **Parse Arguments and Setup**
   - Parse command line arguments for target directory and download mode
   - If $1 contains "--target-dir=", extract the target directory path
   - If $2 contains "--templates-only", set mode to templates only
   - If $3 contains "--config-only", set mode to configuration only
   - Create target directory if it doesn't exist
   - Verify internet connectivity to GitHub

2. **Download Templates** (unless --config-only specified)
   - Create `templates/` directory in target location
   - Download all template files:
     - `task-requirements-template.md`
     - `implementation-plan-template.md` 
     - `code-review-template.md`
     - `coding-standards-template.md`
     - `security-checklist-template.md`
     - `README.md` (templates documentation)
   - Verify all template files downloaded successfully
   - Set appropriate file permissions

3. **Download Slash Commands** (unless --templates-only or --config-only)
   - Create `.claude/commands/` directory structure
   - Download all command files:
     - `task-from-scratch.md`
     - `plan-from-task.md`
     - `implement-plan.md`
     - `review-implementation.md`
     - `context-map.md`
   - Update variable paths in commands to point to local templates
   - Verify command files are valid Claude Code format

4. **Download Subagents** (unless --templates-only or --config-only)
   - Create `.claude/agents/` directory structure
   - Download all agent files:
     - `file-analysis-agent.md`
     - `git-history-agent.md`
     - `dependency-scanner-agent.md`
     - `pattern-recognition-agent.md`
     - `documentation-extractor-agent.md`
   - Verify agent files are valid Claude Code format
   - Test that agents load correctly

5. **Download Setup Scripts** (unless --templates-only)
   - Download setup scripts:
     - `setup.sh` (Linux/Mac setup script)
     - `setup.ps1` (Windows PowerShell setup script)
   - Set executable permissions on setup scripts
   - Customize scripts for local environment if needed

6. **Download Documentation** (unless --templates-only or --config-only)
   - Create `docs/` directory
   - Download documentation files:
     - `WORKFLOW_GUIDE.md`
     - `CUSTOMIZATION.md` 
   - Create `examples/` directory
   - Download example files:
     - `basic-workflow.md`
   - Download root documentation:
     - `CONTRIBUTING.md`
     - `LICENSE`

7. **Download GitHub Integration Files** (if --config-only or full download)
   - Create `.github/ISSUE_TEMPLATE/` directory
   - Download GitHub templates:
     - `bug_report.md`
     - `feature_request.md`
   - Download `.gitignore` with appropriate exclusions
   - Customize for local project needs

8. **Create Local Configuration**
   - Generate local configuration file with download metadata
   - Create version tracking file
   - Set up local customization indicators
   - Generate installation verification script

## Instructions

### Download Modes
- **Full Download** (default): Downloads everything - templates, commands, agents, docs, examples
- **Templates Only** (`--templates-only`): Downloads only the professional templates
- **Config Only** (`--config-only`): Downloads only GitHub configs, gitignore, and setup files

### File Organization
- Maintain the same directory structure as the source repository
- Update relative paths in downloaded files to work locally
- Preserve file permissions and executable status
- Create necessary directories automatically

### Customization
- After download, scan for placeholder values that need local customization
- Provide guidance on which files should be customized for the local project
- Generate a checklist of post-download customization tasks

### Error Handling
- Verify internet connectivity before starting download
- Check GitHub API rate limits and handle accordingly
- Retry failed downloads up to 3 times with exponential backoff
- Provide detailed error messages for debugging
- Create rollback mechanism for partial downloads

## Control Flow

- **If** no internet connectivity:
  - Display error and suggest checking connection
  - Offer to use local cache if available
  - Exit gracefully with helpful message

- **If** target directory exists and contains files:
  - Ask user for confirmation to overwrite
  - Offer to backup existing files
  - Allow selective overwrite options

- **If** GitHub API rate limit exceeded:
  - Display current rate limit status
  - Suggest waiting or using authentication
  - Offer to continue with cached files if available

- **If** individual file download fails:
  - Log the failure with specific error
  - Continue with other files
  - Provide summary of failed downloads at the end

## Report

Generate a comprehensive download report:

### **Download Summary**
- **Total Files Downloaded**: [Number] of [Total] files
- **Download Size**: [Size] MB total
- **Download Time**: [Duration] seconds
- **Success Rate**: [Percentage]% successful

### **Files Downloaded**
```
✅ Templates (6/6)
├── task-requirements-template.md
├── implementation-plan-template.md
├── code-review-template.md
├── coding-standards-template.md
├── security-checklist-template.md
└── README.md

✅ Slash Commands (5/5)
├── task-from-scratch.md
├── plan-from-task.md
├── implement-plan.md
├── review-implementation.md
└── context-map.md

✅ Subagents (5/5)
├── file-analysis-agent.md
├── git-history-agent.md
├── dependency-scanner-agent.md
├── pattern-recognition-agent.md
└── documentation-extractor-agent.md

✅ Documentation (4/4)
├── WORKFLOW_GUIDE.md
├── CUSTOMIZATION.md
├── CONTRIBUTING.md
└── basic-workflow.md

✅ Setup Files (3/3)
├── setup.sh
├── setup.ps1
└── .gitignore
```

### **Next Steps**
1. **Run Setup Script**:
   ```bash
   # Linux/Mac
   chmod +x setup.sh && ./setup.sh
   
   # Windows
   .\setup.ps1
   ```

2. **Customize Templates**:
   - Review `templates/coding-standards-template.md` for your tech stack
   - Update `templates/security-checklist-template.md` for your compliance needs
   - Modify variable paths in commands if needed

3. **Test Installation**:
   ```bash
   claude
   /help  # Should show your new commands
   /agents  # Should show your new subagents
   ```

4. **Start Using**:
   ```bash
   /task-from-scratch "Your first task"
   ```

### **Customization Recommendations**
- [ ] Update `templates/coding-standards-template.md` with your team's specific standards
- [ ] Modify `templates/security-checklist-template.md` for your compliance requirements  
- [ ] Customize `.gitignore` for your project's specific needs
- [ ] Update `CONTRIBUTING.md` with your contribution guidelines
- [ ] Review and adjust setup scripts for your environment

### **Support**
- **Documentation**: Check `docs/WORKFLOW_GUIDE.md` for detailed usage
- **Customization**: See `docs/CUSTOMIZATION.md` for modification guidance
- **Issues**: Report problems at the source repository
- **Updates**: Re-run this command to get latest templates and improvements

### **Version Information**
- **Downloaded From**: https://github.com/ItamarZand88/claude-code-agentic-engineering
- **Commit**: [Latest commit hash]
- **Download Date**: [Current date and time]
- **Local Version**: [Version file created locally]
