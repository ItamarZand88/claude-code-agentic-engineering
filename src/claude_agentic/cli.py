#!/usr/bin/env python3
"""Claude Code Agentic Engineering CLI Tool."""

import os
import sys
import shutil
import subprocess
from pathlib import Path
from typing import Optional

import click
import importlib.resources
from rich.console import Console
from rich.progress import Progress, SpinnerColumn, TextColumn, BarColumn, MofNCompleteColumn
from rich.panel import Panel
from rich.table import Table
from rich.text import Text
from rich.align import Align
from rich.columns import Columns
from rich.tree import Tree
from rich.markdown import Markdown
from rich import box
from rich.prompt import Confirm, Prompt
from rich.syntax import Syntax
from rich.rule import Rule
from rich.live import Live
from rich.status import Status

console = Console()

TAGLINE = "Advanced Development Workflow System"

# Repository configuration
REPO_URL = "https://github.com/ItamarZand88/claude-code-agentic-engineering"



def show_banner():
    """Display a simple banner with enhanced styling."""
    # Simple header with title and tagline (ASCII-only for Windows compatibility)
    console.print()
    console.print(Align.center(Text("CLAUDE CODE AGENTIC ENGINEERING", style="bold bright_blue")))
    console.print(Align.center(Text("=" * 60, style="bright_cyan")))
    console.print(Align.center(Text(TAGLINE, style="italic bright_cyan")))
    console.print(Align.center(Text("=" * 60, style="bright_cyan")))
    console.print()

@click.group()
@click.version_option(version="2.0.0")
def main():
    """Claude Code Agentic Engineering CLI - Initialize and manage agentic workflows."""
    pass

@main.command()
@click.argument('project_name', required=False)
@click.option('--templates-only', is_flag=True, help='Install only templates')
@click.option('--commands-only', is_flag=True, help='Install only commands and agents')
@click.option('--skip-existing', is_flag=True, help='Skip existing files (default: overwrite with latest)')
@click.option('--dir', '-d', default='.', help='Target directory (default: current)')
def init(project_name: Optional[str], templates_only: bool, commands_only: bool, skip_existing: bool, dir: str):
    """Initialize a new project with Claude Code agentic engineering setup.

    By default, overwrites existing files with latest versions.

    Examples:
        agentic init my-project
        agentic init --skip-existing          # Keep existing files
        agentic init --dir ./my-app my-app
    """
    target_dir = Path(dir)

    if project_name:
        target_dir = target_dir / project_name

    # Create project directory with enhanced styling
    if project_name and not target_dir.exists():
        target_dir.mkdir(parents=True, exist_ok=True)
        console.print(f"Created project directory: [bold cyan]{target_dir}[/bold cyan]", style="green")

    # Change to target directory
    os.chdir(target_dir)

    # Show banner
    show_banner()

    with Progress(
        SpinnerColumn(),
        TextColumn("[progress.description]{task.description}"),
        BarColumn(),
        MofNCompleteColumn(),
        console=console,
        transient=False
    ) as progress:
        task = progress.add_task("Installing components...", total=None)
        install_all_components(skip_existing)
        progress.remove_task(task)

    # Show success message
    show_success_panel(project_name or "current directory")

@main.command()
@click.option('--skip-existing', is_flag=True, help='Skip existing files (default: overwrite with latest)')
def install(skip_existing: bool):
    """Install or update agentic engineering components in current directory.

    By default, overwrites existing files with latest versions from the repository.
    Use --skip-existing to keep your local modifications.
    """
    # Show banner
    show_banner()

    with Progress(
        SpinnerColumn(),
        TextColumn("[progress.description]{task.description}"),
        BarColumn(),
        MofNCompleteColumn(),
        console=console,
        transient=False
    ) as progress:
        task = progress.add_task("Installing components...", total=None)
        install_all_components(skip_existing)
        progress.remove_task(task)

    show_success_panel("current directory")

@main.command()
def status():
    """Show installation status and available commands with beautiful formatting."""
    # Enhanced table with better styling
    table = Table(
        title="Claude Code Agentic Engineering Status",
        title_style="bold bright_blue",
        box=box.ROUNDED,
        border_style="bright_cyan"
    )
    table.add_column("Component", style="bold cyan", width=12)
    table.add_column("Status", style="bold", justify="center", width=12)
    table.add_column("Count", justify="center", style="bold green", width=8)
    table.add_column("Description", style="dim", width=40)

    # Check .claude directories
    claude_dir = Path(".claude")
    commands_dir = claude_dir / "commands"
    agents_dir = claude_dir / "agents"
    skills_dir = claude_dir / "skills"

    # Enhanced status indicators
    def get_status_style(exists, count=0):
        if exists and count > 0:
            return "[green]Installed[/green]"
        elif exists:
            return "[cyan]Empty[/cyan]"
        else:
            return "[red]Missing[/red]"

    commands_count = len(list(commands_dir.glob("**/*.md"))) if commands_dir.exists() else 0
    agents_count = len(list(agents_dir.glob("*.md"))) if agents_dir.exists() else 0
    skills_count = len(list(skills_dir.glob("**/SKILL.md"))) if skills_dir.exists() else 0

    table.add_row(
        "Commands",
        get_status_style(commands_dir.exists(), commands_count),
        str(commands_count),
        "Workflow automation commands"
    )

    table.add_row(
        "Agents",
        get_status_style(agents_dir.exists(), agents_count),
        str(agents_count),
        "Specialized AI agent templates"
    )

    table.add_row(
        "Skills",
        get_status_style(skills_dir.exists(), skills_count),
        str(skills_count),
        "Advanced skill modules"
    )

    console.print(table)

    if claude_dir.exists() and any([commands_count, agents_count, skills_count]):
        # Create a beautiful next steps panel
        next_steps = """[green]Ready to use![/green]

[bold bright_cyan]Quick Start:[/bold bright_cyan]
  [bright_blue]claude[/bright_blue]                     Launch Claude Code
  [bright_blue]/help[/bright_blue]                     Show available commands
  [bright_blue]/agents[/bright_blue]                   List specialized agents

[bold bright_cyan]Complete Workflow:[/bold bright_cyan]
  [bright_yellow]/all[/bright_yellow]                   Complete workflow (ticket->plan->implement->review)

[bold bright_cyan]4-Step Workflow:[/bold bright_cyan]
  [bright_green]/1_ticket[/bright_green]                Create comprehensive task ticket
  [bright_green]/2_plan[/bright_green]                  Generate implementation plan with research
  [bright_green]/3_implement[/bright_green]             Execute the implementation plan
  [bright_green]/4_review[/bright_green]                Quality assurance and code review"""

        console.print(Panel(
            next_steps,
            title="Next Steps",
            border_style="green",
            box=box.ROUNDED,
            padding=(1, 2)
        ))
    else:
        console.print(Panel(
            "[cyan]No components installed yet.[/cyan]\n\nRun [bold blue]agentic init[/bold blue] to get started!",
            title="Setup Required",
            border_style="cyan",
            box=box.ROUNDED
        ))

def install_file(content: str, dest: Path, skip_existing: bool = False) -> bool:
    """Write content to destination file with enhanced status display."""
    file_exists = dest.exists()

    if file_exists and skip_existing:
        console.print(f"[cyan]Skipped existing:[/cyan] [dim]{dest.name}[/dim]")
        return True

    try:
        with Status(f"[cyan]{'Updating' if file_exists else 'Creating'} {dest.name}...[/cyan]", console=console):
            dest.parent.mkdir(parents=True, exist_ok=True)
            dest.write_text(content, encoding='utf-8')

        status_msg = "Updated" if file_exists else "Created"
        console.print(f"[green]{status_msg}:[/green] [bold]{dest.name}[/bold]")
        return True
    except Exception as e:
        console.print(f"[red]Failed to install[/red] [bold]{dest.name}[/bold]: [dim]{e}[/dim]")
        return False

def create_project_directories():
    """Create project directories for workflow organization with enhanced styling."""
    directories = [
        ("./.claude/tasks", "Task workspace (organized by task folder)"),
        ("./.claude/best-practices", "Project coding best practices")
    ]

    console.print(Rule("[bold cyan]Project Structure Setup[/bold cyan]"))

    for directory_path, description in directories:
        directory = Path(directory_path)
        if not directory.exists():
            directory.mkdir(parents=True, exist_ok=True)
            console.print(f"[green]Created:[/green] [bold cyan]{directory}[/bold cyan] [dim]({description})[/dim]")
        else:
            console.print(f"[blue]Exists:[/blue] [bold cyan]{directory}[/bold cyan] [dim]({description})[/dim]")


def install_resources_recursively(resource_root, dest_dir: Path, progress, task, skip_existing: bool) -> int:
    """Recursively install all resources from a resource directory."""
    count = 0
    if not resource_root.is_dir():
        return 0

    for item in resource_root.iterdir():
        if item.name.startswith("__") or item.name.startswith("."):
            continue

        if item.is_dir():
            # Create subdirectory
            subdir = dest_dir / item.name
            subdir.mkdir(parents=True, exist_ok=True)
            # Recurse
            count += install_resources_recursively(item, subdir, progress, task, skip_existing)
        else:
            # Install file
            dest_file = dest_dir / item.name
            
            # Simple description for progress
            rel_path = dest_file.relative_to(dest_dir.parent.parent).as_posix() # e.g. .claude/skills/foo/bar.md
            progress.update(task, description=f"Installing [cyan]{rel_path}[/cyan]")
            
            try:
                content = item.read_text(encoding='utf-8')
                if install_file(content, dest_file, skip_existing):
                    count += 1
            except Exception as e:
                console.print(f"[red]Failed to read resource[/red] [bold]{item.name}[/bold]: [dim]{e}[/dim]")
            
            progress.advance(task)
            
    return count

def install_all_components(skip_existing: bool = False):
    """Install all components: commands, agents, and skills."""
    commands_dir = Path(".claude/commands")
    agents_dir = Path(".claude/agents")
    skills_dir = Path(".claude/skills")

    for d in [commands_dir, agents_dir, skills_dir]:
        if not d.exists():
            d.mkdir(parents=True, exist_ok=True)
            console.print(f"[green]Created directory[/green] {d}")
        else:
            console.print(f"[blue]Found existing directory[/blue] {d}")

    # Access resources
    try:
        resources = importlib.resources.files("claude_agentic.resources")
    except Exception as e:
        console.print(f"[red]Error accessing resources: {e}[/red]")
        return

    # Count total items for progress bar (approximate)
    # Note: Traversing to count might be slow, so we'll use an indefinite spinner or just update total dynamically if possible
    # For now, let's just set a large number or None
    
    cmd_success = 0
    agent_success = 0
    skill_success = 0

    with Progress(
        SpinnerColumn(),
        TextColumn("[progress.description]{task.description}"),
        BarColumn(bar_width=30),
        MofNCompleteColumn(),
        console=console,
        transient=True
    ) as progress:
        task = progress.add_task("Installing components", total=None)

        # Install commands
        cmd_success = install_resources_recursively(resources / "commands", commands_dir, progress, task, skip_existing)

        # Install agents
        agent_success = install_resources_recursively(resources / "agents", agents_dir, progress, task, skip_existing)

        # Install skills
        skill_success = install_resources_recursively(resources / "skills", skills_dir, progress, task, skip_existing)

    # Create project directories
    create_project_directories()

    # Summary with enhanced styling
    summary_table = Table(box=box.SIMPLE, show_header=False, padding=(0, 1))
    summary_table.add_column(style="cyan")
    summary_table.add_column(style="bold green", justify="right")
    summary_table.add_column(style="dim")

    summary_table.add_row("Commands", f"{cmd_success}", "installed")
    summary_table.add_row("Agents", f"{agent_success}", "installed")
    summary_table.add_row("Skills", f"{skill_success}", "installed")

    console.print(summary_table)

def show_success_panel(target: str):
    """Show success message with next steps using enhanced styling."""
    
    # Simple check for counts (checking loose files count in destination)
    commands_count = len(list(Path(".claude/commands").glob("**/*"))) if Path(".claude/commands").exists() else 0
    agents_count = len(list(Path(".claude/agents").glob("**/*"))) if Path(".claude/agents").exists() else 0
    skills_count = len(list(Path(".claude/skills").glob("**/*"))) if Path(".claude/skills").exists() else 0
    
    # Create installation summary
    install_summary = Table(box=box.SIMPLE, show_header=False, padding=(0, 1))
    install_summary.add_column("Component", style="cyan", width=20)
    install_summary.add_column("Count", style="bold green", justify="right", width=5)
    install_summary.add_column("Location", style="dim", width=30)

    install_summary.add_row("Commands", str(commands_count), ".claude/commands/")
    install_summary.add_row("Agents", str(agents_count), ".claude/agents/")
    install_summary.add_row("Skills", str(skills_count), ".claude/skills/")

    # Create workflow example
    workflow_steps = """[bold bright_cyan]Quick Start:[/bold bright_cyan]
[bright_yellow]/all[/bright_yellow] "Add OAuth authentication"

[bold bright_cyan]4-Step Workflow:[/bold bright_cyan]
[bright_green]/1_ticket[/bright_green] "Add OAuth authentication"
[bright_green]/2_plan[/bright_green] .claude/tasks/oauth-authentication
[bright_green]/3_implement[/bright_green] .claude/tasks/oauth-authentication
[bright_green]/4_review[/bright_green] .claude/tasks/oauth-authentication

[bold bright_cyan]Available Skills:[/bold bright_cyan]
[bright_magenta]code-standards[/bright_magenta]    Extract best practices from PR comments

[bold bright_cyan]Getting Started:[/bold bright_cyan]
[bright_blue]claude[/bright_blue]                Launch Claude Code
[bright_blue]/help[/bright_blue]                 Show available commands
[bright_blue]/agents[/bright_blue]               List specialized agents"""

    # Print success message
    console.print()
    console.print(Panel(
        f"[bold green]Installation Complete![/bold green]\n\n[bold blue]Installed in {target}:[/bold blue]",
        title="Claude Code Agentic Engineering",
        border_style="green",
        box=box.ROUNDED,
        padding=(1, 2)
    ))

    # Print installation summary table
    console.print(install_summary)
    console.print()

    # Print directories
    console.print("Project directories: [cyan].claude/tasks/[/cyan], [cyan].claude/best-practices/[/cyan], [cyan].claude/skills/[/cyan]")
    console.print()

    # Print workflow steps
    console.print(Panel(
        workflow_steps,
        title="Next Steps",
        border_style="bright_cyan",
        box=box.ROUNDED,
        padding=(1, 2)
    ))

    console.print()
    console.print("[bold green]Your agentic engineering workflow is ready![/bold green]")
    console.print()

if __name__ == "__main__":
    main()
