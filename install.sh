#!/bin/bash

# Claude Code Agentic Engineering Templates Installer
# Downloads and sets up professional templates and commands for Claude Code
# Similar to GitHub Spec Kit - standalone installation script

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
REPO_URL="https://github.com/ItamarZand88/claude-code-agentic-engineering"
RAW_URL="https://raw.githubusercontent.com/ItamarZand88/claude-code-agentic-engineering/main"
VERSION="1.0.0"

# Default options
TARGET_DIR="."
DOWNLOAD_MODE="all"
FORCE_OVERWRITE=false
BACKUP_EXISTING=true

# Function to display usage
show_help() {
    echo -e "${CYAN}Claude Code Agentic Engineering Templates Installer${NC}"
    echo -e "${BLUE}Downloads professional templates and commands for Claude Code${NC}"
    echo ""
    echo -e "${YELLOW}USAGE:${NC}"
    echo "  $0 [OPTIONS] [TARGET_DIRECTORY]"
    echo ""
    echo -e "${YELLOW}OPTIONS:${NC}"
    echo "  -h, --help           Show this help message"
    echo "  -v, --version        Show version information" 
    echo "  -f, --force          Force overwrite existing files"
    echo "  --no-backup          Don't backup existing files"
    echo "  --templates-only     Download only templates"
    echo "  --config-only        Download only configuration files"
    echo "  --commands-only      Download only Claude Code commands and agents"
    echo ""
    echo -e "${YELLOW}EXAMPLES:${NC}"
    echo "  $0                           # Install everything in current directory"
    echo "  $0 my-project                # Install in my-project directory"
    echo "  $0 --templates-only          # Install only templates"
    echo "  $0 --force /path/to/project  # Force install in specific directory"
    echo ""
    echo -e "${YELLOW}WHAT GETS INSTALLED:${NC}"
    echo "  📋 5 Professional Templates (task requirements, implementation plans, etc.)"
    echo "  ⚡ 5 Slash Commands for Claude Code (/task-from-scratch, /plan-from-task, etc.)"
    echo "  🤖 5 Specialized Subagents (file analysis, git history, security, etc.)"
    echo "  📚 Documentation and examples"
    echo "  🔧 Setup scripts and configuration"
    echo ""
    echo -e "${BLUE}Repository: ${REPO_URL}${NC}"
}

# Function to display version
show_version() {
    echo -e "${CYAN}Claude Code Agentic Engineering Templates${NC}"
    echo -e "Version: ${VERSION}"
    echo -e "Repository: ${REPO_URL}"
    echo -e "License: MIT"
}

# Function to log messages
log() {
    echo -e "${GREEN}[$(date +'%H:%M:%S')]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[$(date +'%H:%M:%S')] WARNING:${NC} $1"
}

log_error() {
    echo -e "${RED}[$(date +'%H:%M:%S')] ERROR:${NC} $1"
}

log_info() {
    echo -e "${BLUE}[$(date +'%H:%M:%S')] INFO:${NC} $1"
}

# Function to check internet connectivity
check_connectivity() {
    log_info "Checking internet connectivity..."
    if ! curl -s --head --fail "${RAW_URL}/README.md" > /dev/null 2>&1; then
        log_error "Cannot connect to GitHub. Please check your internet connection."
        exit 1
    fi
    log "Internet connectivity verified ✓"
}

# Function to create directory safely
create_directory() {
    local dir="$1"
    if [[ ! -d "$dir" ]]; then
        mkdir -p "$dir"
        log "Created directory: $dir"
    fi
}

# Function to backup existing file
backup_file() {
    local file="$1"
    if [[ -f "$file" && "$BACKUP_EXISTING" == true ]]; then
        local backup="${file}.backup.$(date +%Y%m%d_%H%M%S)"
        cp "$file" "$backup"
        log_warn "Backed up existing file: $(basename "$file") → $(basename "$backup")"
    fi
}

# Function to download file with retry logic
download_file() {
    local url="$1"
    local target="$2"
    local retries=3
    local delay=1
    
    for ((i=1; i<=retries; i++)); do
        if curl -sf "$url" -o "$target"; then
            log "Downloaded: $(basename "$target")"
            return 0
        else
            if [[ $i -lt $retries ]]; then
                log_warn "Download failed, retrying in ${delay}s... (attempt $i/$retries)"
                sleep $delay
                delay=$((delay * 2))
            else
                log_error "Failed to download: $(basename "$target")"
                return 1
            fi
        fi
    done
}

# Function to download templates
download_templates() {
    if [[ "$DOWNLOAD_MODE" == "config-only" || "$DOWNLOAD_MODE" == "commands-only" ]]; then
        return 0
    fi
    
    log_info "Downloading professional templates..."
    create_directory "$TARGET_DIR/templates"
    
    local templates=(
        "task-requirements-template.md"
        "implementation-plan-template.md"
        "code-review-template.md"
        "coding-standards-template.md"
        "security-checklist-template.md"
        "README.md"
    )
    
    local failed=()
    for template in "${templates[@]}"; do
        local target="$TARGET_DIR/templates/$template"
        [[ -f "$target" && "$FORCE_OVERWRITE" == false ]] && backup_file "$target"
        
        if ! download_file "$RAW_URL/templates/$template" "$target"; then
            failed+=("$template")
        fi
    done
    
    if [[ ${#failed[@]} -eq 0 ]]; then
        log "✅ Templates downloaded successfully (${#templates[@]}/${#templates[@]})"
    else
        log_error "❌ Failed to download ${#failed[@]} templates: ${failed[*]}"
    fi
}

# Function to download Claude Code commands
download_commands() {
    if [[ "$DOWNLOAD_MODE" == "templates-only" || "$DOWNLOAD_MODE" == "config-only" ]]; then
        return 0
    fi
    
    log_info "Downloading Claude Code slash commands..."
    create_directory "$TARGET_DIR/.claude/commands"
    
    local commands=(
        "task-from-scratch.md"
        "plan-from-task.md"
        "implement-plan.md"
        "review-implementation.md"
        "context-map.md"
        "download-templates.md"
    )
    
    local failed=()
    for command in "${commands[@]}"; do
        local target="$TARGET_DIR/.claude/commands/$command"
        [[ -f "$target" && "$FORCE_OVERWRITE" == false ]] && backup_file "$target"
        
        if ! download_file "$RAW_URL/commands/$command" "$target"; then
            failed+=("$command")
        fi
    done
    
    if [[ ${#failed[@]} -eq 0 ]]; then
        log "✅ Slash commands downloaded successfully (${#commands[@]}/${#commands[@]})"
    else
        log_error "❌ Failed to download ${#failed[@]} commands: ${failed[*]}"
    fi
}

# Function to download subagents
download_agents() {
    if [[ "$DOWNLOAD_MODE" == "templates-only" || "$DOWNLOAD_MODE" == "config-only" ]]; then
        return 0
    fi
    
    log_info "Downloading specialized subagents..."
    create_directory "$TARGET_DIR/.claude/agents"
    
    local agents=(
        "file-analysis-agent.md"
        "git-history-agent.md"
        "dependency-scanner-agent.md"
        "pattern-recognition-agent.md"
        "documentation-extractor-agent.md"
    )
    
    local failed=()
    for agent in "${agents[@]}"; do
        local target="$TARGET_DIR/.claude/agents/$agent"
        [[ -f "$target" && "$FORCE_OVERWRITE" == false ]] && backup_file "$target"
        
        if ! download_file "$RAW_URL/agents/$agent" "$target"; then
            failed+=("$agent")
        fi
    done
    
    if [[ ${#failed[@]} -eq 0 ]]; then
        log "✅ Subagents downloaded successfully (${#agents[@]}/${#agents[@]})"
    else
        log_error "❌ Failed to download ${#failed[@]} agents: ${failed[*]}"
    fi
}

# Function to download documentation
download_docs() {
    if [[ "$DOWNLOAD_MODE" == "templates-only" || "$DOWNLOAD_MODE" == "commands-only" ]]; then
        return 0
    fi
    
    log_info "Downloading documentation..."
    create_directory "$TARGET_DIR/docs"
    create_directory "$TARGET_DIR/examples"
    
    local docs=(
        "docs/WORKFLOW_GUIDE.md"
        "docs/CUSTOMIZATION.md"
        "examples/basic-workflow.md"
        "CONTRIBUTING.md"
        "LICENSE"
    )
    
    local failed=()
    for doc in "${docs[@]}"; do
        local target="$TARGET_DIR/$doc"
        create_directory "$(dirname "$target")"
        [[ -f "$target" && "$FORCE_OVERWRITE" == false ]] && backup_file "$target"
        
        if ! download_file "$RAW_URL/$doc" "$target"; then
            failed+=("$doc")
        fi
    done
    
    if [[ ${#failed[@]} -eq 0 ]]; then
        log "✅ Documentation downloaded successfully (${#docs[@]}/${#docs[@]})"
    else
        log_error "❌ Failed to download ${#failed[@]} documentation files: ${failed[*]}"
    fi
}

# Function to download setup scripts and config
download_setup() {
    if [[ "$DOWNLOAD_MODE" == "templates-only" || "$DOWNLOAD_MODE" == "commands-only" ]]; then
        return 0
    fi
    
    log_info "Downloading setup scripts and configuration..."
    
    local setup_files=(
        "setup.sh"
        "setup.ps1"
        ".gitignore"
    )
    
    local failed=()
    for file in "${setup_files[@]}"; do
        local target="$TARGET_DIR/$file"
        [[ -f "$target" && "$FORCE_OVERWRITE" == false ]] && backup_file "$target"
        
        if download_file "$RAW_URL/$file" "$target"; then
            # Make setup scripts executable
            if [[ "$file" == "setup.sh" ]]; then
                chmod +x "$target"
            fi
        else
            failed+=("$file")
        fi
    done
    
    if [[ ${#failed[@]} -eq 0 ]]; then
        log "✅ Setup files downloaded successfully (${#setup_files[@]}/${#setup_files[@]})"
    else
        log_error "❌ Failed to download ${#failed[@]} setup files: ${failed[*]}"
    fi
}

# Function to create version tracking
create_version_file() {
    local version_file="$TARGET_DIR/.claude-agentic-engineering-version"
    cat > "$version_file" << EOF
# Claude Code Agentic Engineering Templates
# Installation Information

VERSION=$VERSION
INSTALL_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
REPO_URL=$REPO_URL
DOWNLOAD_MODE=$DOWNLOAD_MODE
TARGET_DIR=$(readlink -f "$TARGET_DIR")

# To update, run:
# curl -sSL https://raw.githubusercontent.com/ItamarZand88/claude-code-agentic-engineering/main/install.sh | bash

# To check for updates:
# Visit: $REPO_URL
EOF
    log "Created version file: .claude-agentic-engineering-version"
}

# Function to show installation summary
show_summary() {
    echo ""
    echo -e "${PURPLE}═══════════════════════════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}                    🎉 INSTALLATION COMPLETE! 🎉${NC}"
    echo -e "${PURPLE}═══════════════════════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${GREEN}📁 Installation Directory:${NC} $(readlink -f "$TARGET_DIR")"
    echo -e "${GREEN}📦 Download Mode:${NC} $DOWNLOAD_MODE"
    echo -e "${GREEN}⏰ Installation Time:${NC} $(date)"
    echo ""
    
    if [[ "$DOWNLOAD_MODE" != "config-only" && "$DOWNLOAD_MODE" != "templates-only" ]]; then
        echo -e "${YELLOW}🚀 Next Steps:${NC}"
        echo ""
        echo -e "${BLUE}1. Run the setup script:${NC}"
        if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
            echo "   .\\setup.ps1"
        else
            echo "   chmod +x setup.sh && ./setup.sh"
        fi
        echo ""
        echo -e "${BLUE}2. Test Claude Code integration:${NC}"
        echo "   claude"
        echo "   /help    # Should show your new commands"
        echo "   /agents  # Should show your new subagents"
        echo ""
        echo -e "${BLUE}3. Start using the system:${NC}"
        echo '   /task-from-scratch "Add user authentication"'
        echo '   /plan-from-task "./tasks/user-auth-task.md"'
        echo '   /implement-plan "./plans/user-auth-plan.md" --dry-run'
        echo ""
    fi
    
    if [[ "$DOWNLOAD_MODE" != "commands-only" ]]; then
        echo -e "${BLUE}📝 Customize templates for your project:${NC}"
        echo "   • Update templates/coding-standards-template.md"
        echo "   • Modify templates/security-checklist-template.md"  
        echo "   • Review templates/README.md for guidance"
        echo ""
    fi
    
    echo -e "${BLUE}📚 Documentation:${NC}"
    echo "   • docs/WORKFLOW_GUIDE.md - Complete usage examples"
    echo "   • docs/CUSTOMIZATION.md - How to customize for your needs"
    echo "   • examples/basic-workflow.md - Simple usage patterns"
    echo ""
    echo -e "${BLUE}🔗 More Information:${NC}"
    echo "   Repository: ${REPO_URL}"
    echo "   License: MIT"
    echo ""
    echo -e "${GREEN}Happy agentic engineering! 🤖✨${NC}"
    echo ""
}

# Main installation function
main() {
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -v|--version)
                show_version
                exit 0
                ;;
            -f|--force)
                FORCE_OVERWRITE=true
                shift
                ;;
            --no-backup)
                BACKUP_EXISTING=false
                shift
                ;;
            --templates-only)
                DOWNLOAD_MODE="templates-only"
                shift
                ;;
            --config-only)
                DOWNLOAD_MODE="config-only"
                shift
                ;;
            --commands-only)
                DOWNLOAD_MODE="commands-only"
                shift
                ;;
            -*)
                log_error "Unknown option: $1"
                show_help
                exit 1
                ;;
            *)
                TARGET_DIR="$1"
                shift
                ;;
        esac
    done
    
    # Show banner
    echo -e "${PURPLE}═══════════════════════════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}              Claude Code Agentic Engineering Templates${NC}"
    echo -e "${BLUE}                    Professional Development System${NC}"
    echo -e "${PURPLE}═══════════════════════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    # Verify requirements
    if ! command -v curl >/dev/null 2>&1; then
        log_error "curl is required but not installed. Please install curl and try again."
        exit 1
    fi
    
    # Check connectivity
    check_connectivity
    
    # Create target directory
    if [[ ! -d "$TARGET_DIR" ]]; then
        create_directory "$TARGET_DIR"
    fi
    
    # Start download based on mode
    case $DOWNLOAD_MODE in
        "all")
            download_templates
            download_commands
            download_agents
            download_docs
            download_setup
            ;;
        "templates-only")
            download_templates
            ;;
        "config-only")
            download_setup
            # Also download GitHub templates
            create_directory "$TARGET_DIR/.github/ISSUE_TEMPLATE"
            download_file "$RAW_URL/.github/ISSUE_TEMPLATE/bug_report.md" "$TARGET_DIR/.github/ISSUE_TEMPLATE/bug_report.md"
            download_file "$RAW_URL/.github/ISSUE_TEMPLATE/feature_request.md" "$TARGET_DIR/.github/ISSUE_TEMPLATE/feature_request.md"
            ;;
        "commands-only")
            download_commands
            download_agents
            ;;
    esac
    
    # Create version tracking
    create_version_file
    
    # Show summary
    show_summary
}

# Run main function
main "$@"
