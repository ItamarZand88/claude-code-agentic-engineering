# PowerShell Alias Setup for Claude Agentic CLI
# Add this to your PowerShell profile to create shortcuts

# Function to install agentic CLI
function Install-Agentic {
    uvx --from git+https://github.com/ItamarZand88/claude-code-agentic-engineering.git agentic install
}

# Create short alias
Set-Alias agentic-install Install-Agentic

# Optional: Even shorter alias
Set-Alias agi Install-Agentic

Write-Host "✅ Aliases created successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "Available commands:" -ForegroundColor Cyan
Write-Host "  agentic-install  - Install Claude Agentic CLI" -ForegroundColor Yellow
Write-Host "  agi              - Short alias for installation" -ForegroundColor Yellow
Write-Host ""
Write-Host "To make these permanent, add this script to your PowerShell profile:" -ForegroundColor Cyan
Write-Host "  1. Run: notepad `$PROFILE" -ForegroundColor White
Write-Host "  2. Copy the function and aliases from this file" -ForegroundColor White
Write-Host "  3. Save and restart PowerShell" -ForegroundColor White
