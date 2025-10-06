#!/bin/bash
# Bash/Zsh Alias Setup for Claude Agentic CLI
# Add these aliases to your shell profile (~/.bashrc, ~/.zshrc, or ~/.bash_profile)

# Main alias
alias agentic-install='uvx --from git+https://github.com/ItamarZand88/claude-code-agentic-engineering.git agentic install'

# Short alias
alias agi='uvx --from git+https://github.com/ItamarZand88/claude-code-agentic-engineering.git agentic install'

echo "✅ Aliases created for current session!"
echo ""
echo "Available commands:"
echo "  agentic-install  - Install Claude Agentic CLI"
echo "  agi              - Short alias for installation"
echo ""
echo "To make these permanent:"
echo "  1. Add these lines to your shell profile:"
echo "     - For Bash: ~/.bashrc"
echo "     - For Zsh: ~/.zshrc"
echo ""
echo "  2. Add these lines:"
echo "     alias agentic-install='uvx --from git+https://github.com/ItamarZand88/claude-code-agentic-engineering.git agentic install'"
echo "     alias agi='uvx --from git+https://github.com/ItamarZand88/claude-code-agentic-engineering.git agentic install'"
echo ""
echo "  3. Reload your shell: source ~/.bashrc (or ~/.zshrc)"
