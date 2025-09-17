# Claude Code Agentic Engineering Templates Installer (PowerShell)
# Downloads and sets up professional templates and commands for Claude Code
# Similar to GitHub Spec Kit - standalone installation script for Windows

param(
    [string]$TargetDir = ".",
    [switch]$Help,
    [switch]$Version,
    [switch]$Force,
    [switch]$NoBackup,
    [switch]$TemplatesOnly,
    [switch]$ConfigOnly,
    [switch]$CommandsOnly
)

# Configuration
$RepoUrl = "https://github.com/ItamarZand88/claude-code-agentic-engineering"
$RawUrl = "https://raw.githubusercontent.com/ItamarZand88/claude-code-agentic-engineering/main"
$ScriptVersion = "1.0.0"

# Colors for output
$Colors = @{
    Red = "Red"
    Green = "Green"
    Blue = "Blue"
    Yellow = "Yellow"
    Magenta = "Magenta"
    Cyan = "Cyan"
}

function Show-Help {
    Write-Host "Claude Code Agentic Engineering Templates Installer" -ForegroundColor Cyan
    Write-Host "Downloads professional templates and commands for Claude Code" -ForegroundColor Blue
    Write-Host ""
    Write-Host "USAGE:" -ForegroundColor Yellow
    Write-Host "  .\install.ps1 [OPTIONS] [TARGET_DIRECTORY]"
    Write-Host ""
    Write-Host "OPTIONS:" -ForegroundColor Yellow
    Write-Host "  -Help               Show this help message"
    Write-Host "  -Version            Show version information"
    Write-Host "  -Force              Force overwrite existing files"
    Write-Host "  -NoBackup           Don't backup existing files"
    Write-Host "  -TemplatesOnly      Download only templates"
    Write-Host "  -ConfigOnly         Download only configuration files"
    Write-Host "  -CommandsOnly       Download only Claude Code commands and agents"
    Write-Host ""
    Write-Host "EXAMPLES:" -ForegroundColor Yellow
    Write-Host "  .\install.ps1                        # Install everything in current directory"
    Write-Host "  .\install.ps1 my-project             # Install in my-project directory"
    Write-Host "  .\install.ps1 -TemplatesOnly         # Install only templates"
    Write-Host "  .\install.ps1 -Force C:\projects\app # Force install in specific directory"
    Write-Host ""
    Write-Host "WHAT GETS INSTALLED:" -ForegroundColor Yellow
    Write-Host "  📋 5 Professional Templates (task requirements, implementation plans, etc.)"
    Write-Host "  ⚡ 5 Slash Commands for Claude Code (/task-from-scratch, /plan-from-task, etc.)"
    Write-Host "  🤖 5 Specialized Subagents (file analysis, git history, security, etc.)"
    Write-Host "  📚 Documentation and examples"
    Write-Host "  🔧 Setup scripts and configuration"
    Write-Host ""
    Write-Host "Repository: $RepoUrl" -ForegroundColor Blue
}

function Show-Version {
    Write-Host "Claude Code Agentic Engineering Templates" -ForegroundColor Cyan
    Write-Host "Version: $ScriptVersion"
    Write-Host "Repository: $RepoUrl"
    Write-Host "License: MIT"
}

function Write-Log {
    param([string]$Message, [string]$Level = "Info")
    $timestamp = Get-Date -Format "HH:mm:ss"
    $color = switch ($Level) {
        "Info" { $Colors.Green }
        "Warn" { $Colors.Yellow }
        "Error" { $Colors.Red }
        "Debug" { $Colors.Blue }
        default { $Colors.Green }
    }
    Write-Host "[$timestamp] $Message" -ForegroundColor $color
}

function Write-LogWarn {
    param([string]$Message)
    Write-Log "WARNING: $Message" -Level "Warn"
}

function Write-LogError {
    param([string]$Message)
    Write-Log "ERROR: $Message" -Level "Error"
}

function Write-LogInfo {
    param([string]$Message)
    Write-Log "INFO: $Message" -Level "Debug"
}

function Test-Connectivity {
    Write-LogInfo "Checking internet connectivity..."
    try {
        $response = Invoke-WebRequest -Uri "$RawUrl/README.md" -Method Head -UseBasicParsing -TimeoutSec 10
        if ($response.StatusCode -eq 200) {
            Write-Log "Internet connectivity verified ✓"
            return $true
        }
    }
    catch {
        Write-LogError "Cannot connect to GitHub. Please check your internet connection."
        Write-LogError "Error: $($_.Exception.Message)"
        return $false
    }
    return $false
}

function New-DirectorySafe {
    param([string]$Path)
    if (-not (Test-Path $Path)) {
        New-Item -ItemType Directory -Path $Path -Force | Out-Null
        Write-Log "Created directory: $Path"
    }
}

function Backup-File {
    param([string]$FilePath)
    if ((Test-Path $FilePath) -and (-not $NoBackup)) {
        $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
        $backupPath = "$FilePath.backup.$timestamp"
        Copy-Item $FilePath $backupPath
        Write-LogWarn "Backed up existing file: $(Split-Path $FilePath -Leaf) → $(Split-Path $backupPath -Leaf)"
    }
}

function Get-FileWithRetry {
    param([string]$Url, [string]$DestPath, [int]$MaxRetries = 3)
    
    for ($i = 1; $i -le $MaxRetries; $i++) {
        try {
            $webClient = New-Object System.Net.WebClient
            $webClient.DownloadFile($Url, $DestPath)
            Write-Log "Downloaded: $(Split-Path $DestPath -Leaf)"
            return $true
        }
        catch {
            if ($i -lt $MaxRetries) {
                $delay = [math]::Pow(2, $i)
                Write-LogWarn "Download failed, retrying in ${delay}s... (attempt $i/$MaxRetries)"
                Start-Sleep $delay
            }
            else {
                Write-LogError "Failed to download: $(Split-Path $DestPath -Leaf)"
                Write-LogError "Error: $($_.Exception.Message)"
                return $false
            }
        }
    }
    return $false
}

function Get-Templates {
    if ($ConfigOnly -or $CommandsOnly) { return }
    
    Write-LogInfo "Downloading professional templates..."
    New-DirectorySafe "$TargetDir\templates"
    
    $templates = @(
        "task-requirements-template.md",
        "implementation-plan-template.md",
        "code-review-template.md",
        "coding-standards-template.md",
        "security-checklist-template.md",
        "README.md"
    )
    
    $failed = @()
    foreach ($template in $templates) {
        $targetPath = Join-Path "$TargetDir\templates" $template
        if ((Test-Path $targetPath) -and (-not $Force)) {
            Backup-File $targetPath
        }
        
        $url = "$RawUrl/templates/$template"
        if (-not (Get-FileWithRetry $url $targetPath)) {
            $failed += $template
        }
    }
    
    if ($failed.Count -eq 0) {
        Write-Log "✅ Templates downloaded successfully ($($templates.Count)/$($templates.Count))"
    }
    else {
        Write-LogError "❌ Failed to download $($failed.Count) templates: $($failed -join ', ')"
    }
}

function Get-Commands {
    if ($TemplatesOnly -or $ConfigOnly) { return }
    
    Write-LogInfo "Downloading Claude Code slash commands..."
    New-DirectorySafe "$TargetDir\.claude\commands"
    
    $commands = @(
        "task-from-scratch.md",
        "plan-from-task.md",
        "implement-plan.md",
        "review-implementation.md",
        "context-map.md",
        "download-templates.md"
    )
    
    $failed = @()
    foreach ($command in $commands) {
        $targetPath = Join-Path "$TargetDir\.claude\commands" $command
        if ((Test-Path $targetPath) -and (-not $Force)) {
            Backup-File $targetPath
        }
        
        $url = "$RawUrl/commands/$command"
        if (-not (Get-FileWithRetry $url $targetPath)) {
            $failed += $command
        }
    }
    
    if ($failed.Count -eq 0) {
        Write-Log "✅ Slash commands downloaded successfully ($($commands.Count)/$($commands.Count))"
    }
    else {
        Write-LogError "❌ Failed to download $($failed.Count) commands: $($failed -join ', ')"
    }
}

function Get-Agents {
    if ($TemplatesOnly -or $ConfigOnly) { return }
    
    Write-LogInfo "Downloading specialized subagents..."
    New-DirectorySafe "$TargetDir\.claude\agents"
    
    $agents = @(
        "file-analysis-agent.md",
        "git-history-agent.md",
        "dependency-scanner-agent.md",
        "pattern-recognition-agent.md",
        "documentation-extractor-agent.md"
    )
    
    $failed = @()
    foreach ($agent in $agents) {
        $targetPath = Join-Path "$TargetDir\.claude\agents" $agent
        if ((Test-Path $targetPath) -and (-not $Force)) {
            Backup-File $targetPath
        }
        
        $url = "$RawUrl/agents/$agent"
        if (-not (Get-FileWithRetry $url $targetPath)) {
            $failed += $agent
        }
    }
    
    if ($failed.Count -eq 0) {
        Write-Log "✅ Subagents downloaded successfully ($($agents.Count)/$($agents.Count))"
    }
    else {
        Write-LogError "❌ Failed to download $($failed.Count) agents: $($failed -join ', ')"
    }
}

function Get-Documentation {
    if ($TemplatesOnly -or $CommandsOnly) { return }
    
    Write-LogInfo "Downloading documentation..."
    New-DirectorySafe "$TargetDir\docs"
    New-DirectorySafe "$TargetDir\examples"
    
    $docs = @{
        "docs/WORKFLOW_GUIDE.md" = "docs\WORKFLOW_GUIDE.md"
        "docs/CUSTOMIZATION.md" = "docs\CUSTOMIZATION.md"
        "examples/basic-workflow.md" = "examples\basic-workflow.md"
        "CONTRIBUTING.md" = "CONTRIBUTING.md"
        "LICENSE" = "LICENSE"
    }
    
    $failed = @()
    foreach ($doc in $docs.Keys) {
        $targetPath = Join-Path $TargetDir $docs[$doc]
        $targetDir = Split-Path $targetPath -Parent
        New-DirectorySafe $targetDir
        
        if ((Test-Path $targetPath) -and (-not $Force)) {
            Backup-File $targetPath
        }
        
        $url = "$RawUrl/$doc"
        if (-not (Get-FileWithRetry $url $targetPath)) {
            $failed += $doc
        }
    }
    
    if ($failed.Count -eq 0) {
        Write-Log "✅ Documentation downloaded successfully ($($docs.Count)/$($docs.Count))"
    }
    else {
        Write-LogError "❌ Failed to download $($failed.Count) documentation files: $($failed -join ', ')"
    }
}

function Get-SetupFiles {
    if ($TemplatesOnly -or $CommandsOnly) { return }
    
    Write-LogInfo "Downloading setup scripts and configuration..."
    
    $setupFiles = @(
        "setup.sh",
        "setup.ps1", 
        ".gitignore"
    )
    
    $failed = @()
    foreach ($file in $setupFiles) {
        $targetPath = Join-Path $TargetDir $file
        if ((Test-Path $targetPath) -and (-not $Force)) {
            Backup-File $targetPath
        }
        
        $url = "$RawUrl/$file"
        if (-not (Get-FileWithRetry $url $targetPath)) {
            $failed += $file
        }
    }
    
    # Download GitHub issue templates for config-only mode
    if ($ConfigOnly) {
        New-DirectorySafe "$TargetDir\.github\ISSUE_TEMPLATE"
        $githubTemplates = @(
            ".github/ISSUE_TEMPLATE/bug_report.md",
            ".github/ISSUE_TEMPLATE/feature_request.md"
        )
        
        foreach ($template in $githubTemplates) {
            $targetPath = Join-Path $TargetDir $template.Replace('/', '\')
            $url = "$RawUrl/$template"
            Get-FileWithRetry $url $targetPath | Out-Null
        }
    }
    
    if ($failed.Count -eq 0) {
        Write-Log "✅ Setup files downloaded successfully ($($setupFiles.Count)/$($setupFiles.Count))"
    }
    else {
        Write-LogError "❌ Failed to download $($failed.Count) setup files: $($failed -join ', ')"
    }
}

function New-VersionFile {
    $versionFile = Join-Path $TargetDir ".claude-agentic-engineering-version"
    $content = @"
# Claude Code Agentic Engineering Templates
# Installation Information

VERSION=$ScriptVersion
INSTALL_DATE=$(Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ")
REPO_URL=$RepoUrl
DOWNLOAD_MODE=$([string]::Join(',', @($TemplatesOnly, $ConfigOnly, $CommandsOnly)))
TARGET_DIR=$((Resolve-Path $TargetDir).Path)

# To update, run:
# Invoke-WebRequest -Uri "https://raw.githubusercontent.com/ItamarZand88/claude-code-agentic-engineering/main/install.ps1" -OutFile "install.ps1"; .\install.ps1

# To check for updates:
# Visit: $RepoUrl
"@
    
    Set-Content -Path $versionFile -Value $content
    Write-Log "Created version file: .claude-agentic-engineering-version"
}

function Show-Summary {
    Write-Host ""
    Write-Host "═══════════════════════════════════════════════════════════════════════════════" -ForegroundColor Magenta
    Write-Host "                    🎉 INSTALLATION COMPLETE! 🎉" -ForegroundColor Cyan
    Write-Host "═══════════════════════════════════════════════════════════════════════════════" -ForegroundColor Magenta
    Write-Host ""
    Write-Host "📁 Installation Directory: " -ForegroundColor Green -NoNewline
    Write-Host (Resolve-Path $TargetDir).Path
    Write-Host "📦 Download Mode: " -ForegroundColor Green -NoNewline
    $mode = if ($TemplatesOnly) { "templates-only" } elseif ($ConfigOnly) { "config-only" } elseif ($CommandsOnly) { "commands-only" } else { "all" }
    Write-Host $mode
    Write-Host "⏰ Installation Time: " -ForegroundColor Green -NoNewline
    Write-Host (Get-Date)
    Write-Host ""
    
    if (-not ($ConfigOnly -or $TemplatesOnly)) {
        Write-Host "🚀 Next Steps:" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "1. Run the setup script:" -ForegroundColor Blue
        Write-Host "   .\setup.ps1"
        Write-Host ""
        Write-Host "2. Test Claude Code integration:" -ForegroundColor Blue
        Write-Host "   claude"
        Write-Host "   /help    # Should show your new commands"
        Write-Host "   /agents  # Should show your new subagents"
        Write-Host ""
        Write-Host "3. Start using the system:" -ForegroundColor Blue
        Write-Host '   /task-from-scratch "Add user authentication"'
        Write-Host '   /plan-from-task "./tasks/user-auth-task.md"'
        Write-Host '   /implement-plan "./plans/user-auth-plan.md" --dry-run'
        Write-Host ""
    }
    
    if (-not $CommandsOnly) {
        Write-Host "📝 Customize templates for your project:" -ForegroundColor Blue
        Write-Host "   • Update templates/coding-standards-template.md"
        Write-Host "   • Modify templates/security-checklist-template.md"
        Write-Host "   • Review templates/README.md for guidance"
        Write-Host ""
    }
    
    Write-Host "📚 Documentation:" -ForegroundColor Blue
    Write-Host "   • docs/WORKFLOW_GUIDE.md - Complete usage examples"
    Write-Host "   • docs/CUSTOMIZATION.md - How to customize for your needs"
    Write-Host "   • examples/basic-workflow.md - Simple usage patterns"
    Write-Host ""
    Write-Host "🔗 More Information:" -ForegroundColor Blue
    Write-Host "   Repository: $RepoUrl"
    Write-Host "   License: MIT"
    Write-Host ""
    Write-Host "Happy agentic engineering! 🤖✨" -ForegroundColor Green
    Write-Host ""
}

# Main execution
function Main {
    if ($Help) {
        Show-Help
        return
    }
    
    if ($Version) {
        Show-Version
        return
    }
    
    # Show banner
    Write-Host "═══════════════════════════════════════════════════════════════════════════════" -ForegroundColor Magenta
    Write-Host "              Claude Code Agentic Engineering Templates" -ForegroundColor Cyan
    Write-Host "                    Professional Development System" -ForegroundColor Blue
    Write-Host "═══════════════════════════════════════════════════════════════════════════════" -ForegroundColor Magenta
    Write-Host ""
    
    # Check connectivity
    if (-not (Test-Connectivity)) {
        exit 1
    }
    
    # Create target directory
    if (-not (Test-Path $TargetDir)) {
        New-DirectorySafe $TargetDir
    }
    
    # Download based on mode
    if ($TemplatesOnly) {
        Get-Templates
    }
    elseif ($ConfigOnly) {
        Get-SetupFiles
    }
    elseif ($CommandsOnly) {
        Get-Commands
        Get-Agents
    }
    else {
        Get-Templates
        Get-Commands
        Get-Agents
        Get-Documentation
        Get-SetupFiles
    }
    
    # Create version file
    New-VersionFile
    
    # Show summary
    Show-Summary
}

# Run main function
Main
