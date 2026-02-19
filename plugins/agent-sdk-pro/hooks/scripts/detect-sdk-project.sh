#!/bin/bash
# detect-sdk-project.sh
# Runs on SessionStart — detects if current project uses @anthropic-ai/claude-agent-sdk
# and outputs context for the Claude session.

set -euo pipefail

PACKAGE_JSON="${CLAUDE_PROJECT_DIR}/package.json"

if [ ! -f "$PACKAGE_JSON" ]; then
  exit 0
fi

# Check if SDK is a dependency
if ! grep -q '"@anthropic-ai/claude-agent-sdk"' "$PACKAGE_JSON" 2>/dev/null; then
  exit 0
fi

# Extract SDK version (dependencies or devDependencies)
SDK_VERSION=$(node -e "
  const pkg = require('${PACKAGE_JSON}');
  const deps = { ...pkg.dependencies, ...pkg.devDependencies };
  console.log(deps['@anthropic-ai/claude-agent-sdk'] || 'unknown');
" 2>/dev/null || echo "unknown")

# Count hook files
HOOK_COUNT=$(find "${CLAUDE_PROJECT_DIR}" -name "*hook*.ts" -not -path "*/node_modules/*" 2>/dev/null | wc -l | tr -d ' ')

# Output context for Claude
echo "=== Agent SDK Pro: Project Detected ==="
echo "SDK Version: @anthropic-ai/claude-agent-sdk@${SDK_VERSION}"
echo "Hook files found: ${HOOK_COUNT}"
echo ""
echo "Available commands: /agent-sdk-pro:scaffold-agent, /agent-sdk-pro:add-hook, /agent-sdk-pro:debug"
echo "Active skills: sdk-typescript-patterns, sdk-hooks-development, sdk-agent-control"
echo ""
echo "To enable real-time SDK feedback on file edits, run:"
echo "  touch \"${CLAUDE_PROJECT_DIR}/.enable-sdk-feedback\""
