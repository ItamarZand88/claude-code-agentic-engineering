# Claude Code Advanced Engineering Commands Setup Script (PowerShell)
# This script creates all slash commands and subagents for the agentic engineering workflow

Write-Host "🚀 Setting up Claude Code Advanced Engineering Commands..." -ForegroundColor Cyan

function Create-Directory {
    param($Path)
    if (!(Test-Path $Path)) {
        New-Item -ItemType Directory -Path $Path -Force | Out-Null
        Write-Host "✓ Created directory: $Path" -ForegroundColor Green
    } else {
        Write-Host "ℹ Directory already exists: $Path" -ForegroundColor Blue
    }
}

Write-Host "`n📁 Creating directory structure..." -ForegroundColor Yellow

# Create directories
Create-Directory ".claude/commands"
Create-Directory ".claude/agents"

Write-Host "`n⚡ Installing slash commands..." -ForegroundColor Yellow

# Copy command files
Copy-Item "commands\*.md" ".claude\commands\" -Force
Write-Host "✓ Copied 5 slash commands" -ForegroundColor Green

Write-Host "`n🤖 Installing subagents..." -ForegroundColor Yellow

# Copy agent files  
Copy-Item "agents\*.md" ".claude\agents\" -Force
Write-Host "✓ Copied 5 specialized subagents" -ForegroundColor Green

Write-Host "`n🎉 Setup complete!" -ForegroundColor Green
Write-Host "`n📋 Summary:" -ForegroundColor Blue
Write-Host "  ✓ 5 slash commands installed in .claude/commands/" -ForegroundColor Green
Write-Host "  ✓ 5 subagents installed in .claude/agents/" -ForegroundColor Green
Write-Host "`n🚀 Next steps:" -ForegroundColor Yellow
Write-Host "  1. Run claude to start Claude Code"
Write-Host "  2. Type /help to see your new commands" -ForegroundColor Blue
Write-Host "  3. Type /agents to verify subagents are loaded" -ForegroundColor Blue
Write-Host "  4. Try the workflow:"
Write-Host "     /task-from-scratch `"Add user authentication`"" -ForegroundColor Blue
Write-Host "     /plan-from-task `"./tasks/user-auth-task.md`"" -ForegroundColor Blue  
Write-Host "     /implement-plan `"./plans/user-auth-plan.md`" --dry-run" -ForegroundColor Blue
Write-Host "`n🎯 Your agentic engineering workflow is ready!" -ForegroundColor Green
