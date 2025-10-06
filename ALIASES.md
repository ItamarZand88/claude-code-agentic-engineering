# Shell Aliases for Claude Agentic CLI

Make installation easier with these shell aliases!

## Quick Setup

### Windows (PowerShell)

**Option A: Temporary (Current Session Only)**
```powershell
# Run the setup script
.\setup-aliases.ps1
```

**Option B: Permanent Setup**
```powershell
# Open your PowerShell profile
notepad $PROFILE

# Add these lines:
function Install-Agentic {
    uvx --from git+https://github.com/ItamarZand88/claude-code-agentic-engineering.git agentic install
}
Set-Alias agentic-install Install-Agentic
Set-Alias agi Install-Agentic

# Save, close, and restart PowerShell
```

### Linux/Mac (Bash/Zsh)

**Option A: Temporary (Current Session Only)**
```bash
# Run the setup script
source setup-aliases.sh
```

**Option B: Permanent Setup**
```bash
# For Bash users
echo "alias agentic-install='uvx --from git+https://github.com/ItamarZand88/claude-code-agentic-engineering.git agentic install'" >> ~/.bashrc
echo "alias agi='uvx --from git+https://github.com/ItamarZand88/claude-code-agentic-engineering.git agentic install'" >> ~/.bashrc
source ~/.bashrc

# For Zsh users
echo "alias agentic-install='uvx --from git+https://github.com/ItamarZand88/claude-code-agentic-engineering.git agentic install'" >> ~/.zshrc
echo "alias agi='uvx --from git+https://github.com/ItamarZand88/claude-code-agentic-engineering.git agentic install'" >> ~/.zshrc
source ~/.zshrc
```

## Available Aliases

Once set up, you can use these short commands:

### Full Alias
```bash
agentic-install
```

### Short Alias (Super Quick!)
```bash
agi
```

Both commands do the same thing - install the Claude Agentic CLI in your current directory!

## Before & After

**Before (Long):**
```bash
uvx --from git+https://github.com/ItamarZand88/claude-code-agentic-engineering.git agentic install
```

**After (Short):**
```bash
agi
```

Much easier! 🎉

## Verification

To verify your aliases are set up correctly:

**PowerShell:**
```powershell
Get-Alias agi
Get-Alias agentic-install
```

**Bash/Zsh:**
```bash
alias | grep agi
```

## Troubleshooting

### PowerShell: "Cannot load profile"
If you get a security error, run:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Bash/Zsh: "Alias not found"
Make sure you've reloaded your shell profile:
```bash
source ~/.bashrc  # or ~/.zshrc
```
