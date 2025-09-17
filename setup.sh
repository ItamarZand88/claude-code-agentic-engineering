#!/bin/bash

# Claude Code Advanced Engineering Commands Setup Script
# This script creates all slash commands and subagents for the agentic engineering workflow

set -e

echo "🚀 Setting up Claude Code Advanced Engineering Commands..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to create directory if it doesn't exist
create_dir() {
    if [ ! -d "$1" ]; then
        mkdir -p "$1"
        echo -e "${GREEN}✓${NC} Created directory: $1"
    else
        echo -e "${BLUE}ℹ${NC} Directory already exists: $1"
    fi
}

echo -e "\n${YELLOW}📁 Creating directory structure...${NC}"

# Create directories
create_dir ".claude/commands"
create_dir ".claude/agents"
create_dir ".claude/templates"

echo -e "\n${YELLOW}⚡ Installing slash commands...${NC}"

# Copy command files
cp commands/*.md .claude/commands/
echo -e "${GREEN}✓${NC} Copied 5 slash commands"

echo -e "\n${YELLOW}🤖 Installing subagents...${NC}"

# Copy agent files
cp agents/*.md .claude/agents/
echo -e "${GREEN}✓${NC} Copied 5 specialized subagents"

echo -e "\n${YELLOW}📋 Installing templates...${NC}"

# Copy template files
cp templates/*.md .claude/templates/
echo -e "${GREEN}✓${NC} Copied 6 professional templates"

echo -e "\n${GREEN}🎉 Setup complete!${NC}"
echo -e "\n${BLUE}📋 Summary:${NC}"
echo -e "  ${GREEN}✓${NC} 6 slash commands installed in .claude/commands/"
echo -e "  ${GREEN}✓${NC} 5 subagents installed in .claude/agents/"
echo -e "  ${GREEN}✓${NC} 6 templates installed in .claude/templates/"
echo -e "\n${YELLOW}🚀 Next steps:${NC}"
echo -e "  1. Run ${BLUE}claude${NC} to start Claude Code"
echo -e "  2. Type ${BLUE}/help${NC} to see your new commands"
echo -e "  3. Type ${BLUE}/agents${NC} to verify subagents are loaded"
echo -e "  4. Try the workflow:"
echo -e "     ${BLUE}/task-from-scratch \"Add user authentication\"${NC}"
echo -e "     ${BLUE}/plan-from-task \"./tasks/user-auth-task.md\"${NC}"
echo -e "     ${BLUE}/implement-plan \"./plans/user-auth-plan.md\" --dry-run${NC}"
echo -e "\n${GREEN}🎯 Your agentic engineering workflow is ready!${NC}"
