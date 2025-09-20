#!/usr/bin/env python3
"""Claude Code Agentic Engineering CLI Tool."""

import os
import sys
import shutil
import subprocess
from pathlib import Path
from typing import Optional

import click
import requests
from rich.console import Console
from rich.progress import Progress, SpinnerColumn, TextColumn
from rich.panel import Panel
from rich.table import Table

console = Console()

# Repository configuration
REPO_URL = "https://github.com/ItamarZand88/claude-code-agentic-engineering"
RAW_URL = "https://raw.githubusercontent.com/ItamarZand88/claude-code-agentic-engineering/main"

# File lists for installation - Updated to match new simplified structure
COMMANDS = [
    "1_get_context.md",
    "2_task_from_scratch.md",
    "3_plan_from_task.md",
    "4_implement_plan.md",
    "5_review_implementation.md",
    "6_update_context.md"
]

AGENTS = [
    "dependency-scanner-agent.md",
    "documentation-extractor-agent.md",
    "file-analysis-agent.md",
    "git-history-agent.md",
    "pattern-recognition-agent.md"
]

TEMPLATES = [
    "code-review-template.md",
    "README.md",
    "security-checklist-template.md"
]

@click.group()
@click.version_option(version="1.0.0")
def main():
    """Claude Code Agentic Engineering CLI - Initialize and manage agentic workflows."""
    pass

@main.command()
@click.argument('project_name', required=False)
@click.option('--templates-only', is_flag=True, help='Install only templates')
@click.option('--commands-only', is_flag=True, help='Install only commands and agents')
@click.option('--force', is_flag=True, help='Force overwrite existing files')
@click.option('--dir', '-d', default='.', help='Target directory (default: current)')
def init(project_name: Optional[str], templates_only: bool, commands_only: bool, force: bool, dir: str):
    """Initialize a new project with Claude Code agentic engineering setup.

    Examples:
        agentic init my-project
        agentic init --templates-only
        agentic init --dir ./my-app my-app
    """
    target_dir = Path(dir)

    if project_name:
        target_dir = target_dir / project_name

    # Create project directory
    if project_name and not target_dir.exists():
        target_dir.mkdir(parents=True, exist_ok=True)
        console.print(f"📁 Created project directory: {target_dir}", style="green")

    # Change to target directory
    os.chdir(target_dir)

    with Progress(
        SpinnerColumn(),
        TextColumn("[progress.description]{task.description}"),
        console=console,
    ) as progress:

        if not commands_only:
            task = progress.add_task("Installing templates...", total=None)
            install_templates(force)
            progress.remove_task(task)

        if not templates_only:
            task = progress.add_task("Installing commands and agents...", total=None)
            install_commands_and_agents(force)
            progress.remove_task(task)

    # Show success message
    show_success_panel(project_name or "current directory")

@main.command()
@click.option('--force', is_flag=True, help='Force overwrite existing files')
def install(force: bool):
    """Install or update agentic engineering components in current directory."""
    with Progress(
        SpinnerColumn(),
        TextColumn("[progress.description]{task.description}"),
        console=console,
    ) as progress:
        task1 = progress.add_task("Installing templates...", total=None)
        install_templates(force)
        progress.remove_task(task1)

        task2 = progress.add_task("Installing commands and agents...", total=None)
        install_commands_and_agents(force)
        progress.remove_task(task2)

    show_success_panel("current directory")

@main.command()
def status():
    """Show installation status and available commands."""
    table = Table(title="Claude Code Agentic Engineering Status")
    table.add_column("Component", style="cyan")
    table.add_column("Status", style="magenta")
    table.add_column("Count", justify="right", style="green")

    # Check .claude directories
    claude_dir = Path(".claude")

    commands_dir = claude_dir / "commands"
    agents_dir = claude_dir / "agents"
    templates_dir = claude_dir / "templates"

    table.add_row(
        "Commands",
        "Installed" if commands_dir.exists() else "Missing",
        str(len(list(commands_dir.glob("*.md")))) if commands_dir.exists() else "0"
    )

    table.add_row(
        "Agents",
        "Installed" if agents_dir.exists() else "Missing",
        str(len(list(agents_dir.glob("*.md")))) if agents_dir.exists() else "0"
    )

    table.add_row(
        "Templates",
        "Installed" if templates_dir.exists() else "Missing",
        str(len(list(templates_dir.glob("*.md")))) if templates_dir.exists() else "0"
    )

    console.print(table)

    if claude_dir.exists():
        console.print("\nReady to use! Start with:", style="green")
        console.print("  claude", style="blue")
        console.print("  /help", style="blue")
        console.print("  /agents", style="blue")

def download_file(url: str, dest: Path, force: bool = False) -> bool:
    """Download a file from URL to destination."""
    if dest.exists() and not force:
        console.print(f"Skipped existing: {dest.name}", style="yellow")
        return True

    try:
        response = requests.get(url, timeout=30)
        response.raise_for_status()

        dest.parent.mkdir(parents=True, exist_ok=True)
        dest.write_text(response.text, encoding='utf-8')
        console.print(f"Downloaded: {dest.name}", style="green")
        return True
    except Exception as e:
        console.print(f"Failed to download {dest.name}: {e}", style="red")
        return False

def install_templates(force: bool = False):
    """Install template files."""
    templates_dir = Path(".claude/templates")

    # Check if .claude directory exists and preserve it
    if templates_dir.exists():
        console.print("Found existing .claude/templates directory", style="blue")
    else:
        templates_dir.mkdir(parents=True, exist_ok=True)
        console.print("Created .claude/templates directory", style="green")

    success_count = 0
    for template in TEMPLATES:
        url = f"{RAW_URL}/templates/{template}"
        dest = templates_dir / template
        if download_file(url, dest, force):
            success_count += 1

    console.print(f"Templates: {success_count}/{len(TEMPLATES)} processed", style="cyan")

def install_commands_and_agents(force: bool = False):
    """Install command and agent files."""
    commands_dir = Path(".claude/commands")
    agents_dir = Path(".claude/agents")

    # Check and preserve existing directories
    if commands_dir.exists():
        console.print("Found existing .claude/commands directory", style="blue")
    else:
        commands_dir.mkdir(parents=True, exist_ok=True)
        console.print("Created .claude/commands directory", style="green")

    if agents_dir.exists():
        console.print("Found existing .claude/agents directory", style="blue")
    else:
        agents_dir.mkdir(parents=True, exist_ok=True)
        console.print("Created .claude/agents directory", style="green")

    # Install commands
    cmd_success = 0
    for command in COMMANDS:
        url = f"{RAW_URL}/commands/{command}"
        dest = commands_dir / command
        if download_file(url, dest, force):
            cmd_success += 1

    # Install agents
    agent_success = 0
    for agent in AGENTS:
        url = f"{RAW_URL}/agents/{agent}"
        dest = agents_dir / agent
        if download_file(url, dest, force):
            agent_success += 1

    console.print(f"Commands: {cmd_success}/{len(COMMANDS)} processed", style="cyan")
    console.print(f"Agents: {agent_success}/{len(AGENTS)} processed", style="cyan")

def show_success_panel(target: str):
    """Show success message with next steps."""
    content = f"""[green]Installation complete![/green]

[blue]Installed in {target}:[/blue]
  - {len(COMMANDS)} slash commands in .claude/commands/
  - {len(AGENTS)} specialized agents in .claude/agents/
  - {len(TEMPLATES)} professional templates in .claude/templates/

[yellow]Next steps:[/yellow]
  1. Run [blue]claude[/blue] to start Claude Code
  2. Type [blue]/help[/blue] to see your new commands
  3. Type [blue]/agents[/blue] to verify agents are loaded
  4. Try the simplified workflow:
     [blue]/get_context "authentication"[/blue]
     [blue]/task_from_scratch "Add user auth" ./context/auth-20240120.md[/blue]
     [blue]/plan_from_task "./tasks/user-auth-task.md"[/blue]
     [blue]/implement_plan "./plans/user-auth-plan.md"[/blue]

[green]Your simplified agentic engineering workflow is ready![/green]"""

    console.print(Panel(content, title="Claude Code Agentic Engineering", border_style="green"))

if __name__ == "__main__":
    main()