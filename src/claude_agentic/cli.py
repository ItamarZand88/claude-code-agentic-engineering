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

# ASCII Art Banner (using raw string to avoid escape sequence warnings)
BANNER = r"""
          _____                    _____                    _____                    _____                    _____            _____          
         /\    \                  /\    \                  /\    \                  /\    \                  /\    \          /\    \         
        /::\    \                /::\    \                /::\    \                /::\    \                /::\____\        /::\    \        
       /::::\    \               \:::\    \              /::::\    \              /::::\    \              /:::/    /       /::::\    \       
      /::::::\    \               \:::\    \            /::::::\    \            /::::::\    \            /:::/    /       /::::::\    \      
     /:::/\:::\    \               \:::\    \          /:::/\:::\    \          /:::/\:::\    \          /:::/    /       /:::/\:::\    \     
    /:::/  \:::\    \               \:::\    \        /:::/__\:::\    \        /:::/  \:::\    \        /:::/    /       /:::/__\:::\    \    
   /:::/    \:::\    \              /::::\    \      /::::\   \:::\    \      /:::/    \:::\    \      /:::/    /       /::::\   \:::\    \   
  /:::/    / \:::\    \    ____    /::::::\    \    /::::::\   \:::\    \    /:::/    / \:::\    \    /:::/    /       /::::::\   \:::\    \  
 /:::/    /   \:::\    \  /\   \  /:::/\:::\    \  /:::/\:::\   \:::\____\  /:::/    /   \:::\    \  /:::/    /       /:::/\:::\   \:::\    \ 
/:::/____/     \:::\____\/::\   \/:::/  \:::\____\/:::/  \:::\   \:::|    |/:::/____/     \:::\____\/:::/____/       /:::/__\:::\   \:::\____\
\:::\    \      \::/    /\:::\  /:::/    \::/    /\::/   |::::\  /:::|____|\:::\    \      \::/    /\:::\    \       \:::\   \:::\   \::/    /
 \:::\    \      \/____/  \:::\/:::/    / \/____/  \/____|:::::\/:::/    /  \:::\    \      \/____/  \:::\    \       \:::\   \:::\   \/____/ 
  \:::\    \               \::::::/    /                 |:::::::::/    /    \:::\    \               \:::\    \       \:::\   \:::\    \     
   \:::\    \               \::::/____/                  |::|\::::/    /      \:::\    \               \:::\    \       \:::\   \:::\____\    
    \:::\    \               \:::\    \                  |::| \::/____/        \:::\    \               \:::\    \       \:::\   \::/    /    
     \:::\    \               \:::\    \                 |::|  ~|               \:::\    \               \:::\    \       \:::\   \/____/     
      \:::\    \               \:::\    \                |::|   |                \:::\    \               \:::\    \       \:::\    \         
       \:::\____\               \:::\____\               \::|   |                 \:::\____\               \:::\____\       \:::\____\        
        \::/    /                \::/    /                \:|   |                  \::/    /                \::/    /        \::/    /        
         \/____/                  \/____/                  \|___|                   \/____/                  \/____/          \/____/         
"""

TAGLINE = "Advanced Development Workflow System"

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

ONBOARDING_COMMANDS = [
    "onboarding/generate_coding_standards.md"
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

def show_banner():
    """Display the ASCII art banner with enhanced styling."""
    import os
    import sys

    # Configure console for Windows Unicode support
    if os.name == 'nt':
        try:
            import codecs
            sys.stdout.reconfigure(encoding='utf-8')
            import locale
            locale.setlocale(locale.LC_ALL, '')
        except:
            pass

    try:
        # Enhanced gradient effect with more sophisticated styling
        banner_lines = BANNER.strip().split('\n')
        colors = ["bright_blue", "blue", "cyan", "bright_cyan", "white", "bright_white"]

        # Create banner with gradient effect
        styled_banner = Text()
        for i, line in enumerate(banner_lines):
            color = colors[i % len(colors)]
            styled_banner.append(line + "\n", style=f"bold {color}")

        # Create a beautiful panel for the banner
        banner_panel = Panel(
            Align.center(styled_banner),
            box=box.DOUBLE,
            border_style="bright_blue",
            padding=(1, 2)
        )

        console.print(banner_panel)

        # Enhanced tagline with decorative elements
        console.print(Align.center(Rule(style="bright_cyan")))
        console.print(Align.center(Text(TAGLINE, style="italic bright_yellow bold")))
        console.print(Align.center(Rule(style="bright_cyan")))

    except (UnicodeEncodeError, UnicodeError, Exception):
        # Enhanced fallback with basic Rich styling
        try:
            fallback_text = Text("CLAUDE CODE AGENTIC ENGINEERING", style="bold bright_blue")
            tagline_text = Text("Advanced Development Workflow System", style="italic yellow")
            console.print(Align.center(fallback_text))
            console.print(Align.center(tagline_text))
        except:
            # Final ASCII fallback
            print("CLAUDE CODE AGENTIC ENGINEERING")
            print("Advanced Development Workflow System")

    console.print()

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
        task1 = progress.add_task("Installing templates...", total=None)
        install_templates(force)
        progress.remove_task(task1)

        task2 = progress.add_task("Installing commands and agents...", total=None)
        install_commands_and_agents(force)
        progress.remove_task(task2)

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
    templates_dir = claude_dir / "templates"

    # Enhanced status indicators
    def get_status_style(exists, count=0):
        if exists and count > 0:
            return "[green]Installed[/green]"
        elif exists:
            return "[yellow]Empty[/yellow]"
        else:
            return "[red]Missing[/red]"

    commands_count = len(list(commands_dir.glob("**/*.md"))) if commands_dir.exists() else 0
    agents_count = len(list(agents_dir.glob("*.md"))) if agents_dir.exists() else 0
    templates_count = len(list(templates_dir.glob("*.md"))) if templates_dir.exists() else 0

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
        "Templates",
        get_status_style(templates_dir.exists(), templates_count),
        str(templates_count),
        "Professional document templates"
    )

    console.print(table)

    if claude_dir.exists() and any([commands_count, agents_count, templates_count]):
        # Create a beautiful next steps panel
        next_steps = """[green]Ready to use![/green]

[bold yellow]Quick Start:[/bold yellow]
  [bright_blue]claude[/bright_blue]                     Launch Claude Code
  [bright_blue]/help[/bright_blue]                     Show available commands
  [bright_blue]/agents[/bright_blue]                   List specialized agents

[bold yellow]Common Workflows:[/bold yellow]
  [bright_cyan]/get_context[/bright_cyan]              Load project context
  [bright_cyan]/task_from_scratch[/bright_cyan]        Create new task
  [bright_cyan]/plan_from_task[/bright_cyan]           Generate implementation plan
  [bright_cyan]/implement_plan[/bright_cyan]           Execute the plan"""

        console.print(Panel(
            next_steps,
            title="Next Steps",
            border_style="green",
            box=box.ROUNDED,
            padding=(1, 2)
        ))
    else:
        console.print(Panel(
            "[yellow]No components installed yet.[/yellow]\n\nRun [bold blue]agentic init[/bold blue] to get started!",
            title="Setup Required",
            border_style="yellow",
            box=box.ROUNDED
        ))

def download_file(url: str, dest: Path, force: bool = False) -> bool:
    """Download a file from URL to destination with enhanced status display."""
    if dest.exists() and not force:
        console.print(f"[yellow]Skipped existing:[/yellow] [dim]{dest.name}[/dim]")
        return True

    try:
        with Status(f"[cyan]Downloading {dest.name}...[/cyan]", console=console):
            response = requests.get(url, timeout=30)
            response.raise_for_status()

            dest.parent.mkdir(parents=True, exist_ok=True)
            dest.write_text(response.text, encoding='utf-8')

        console.print(f"[green]Downloaded:[/green] [bold]{dest.name}[/bold]")
        return True
    except Exception as e:
        console.print(f"[red]Failed to download[/red] [bold]{dest.name}[/bold]: [dim]{e}[/dim]")
        return False

def install_templates(force: bool = False):
    """Install template files with enhanced progress display."""
    templates_dir = Path(".claude/templates")

    # Check if .claude directory exists and preserve it
    if templates_dir.exists():
        console.print("[blue]Found existing[/blue] .claude/templates directory")
    else:
        templates_dir.mkdir(parents=True, exist_ok=True)
        console.print("[green]Created[/green] .claude/templates directory")

    success_count = 0
    total_templates = len(TEMPLATES)

    with Progress(
        SpinnerColumn(),
        TextColumn("[progress.description]{task.description}"),
        BarColumn(bar_width=30),
        MofNCompleteColumn(),
        console=console,
        transient=True
    ) as progress:
        task = progress.add_task("Installing templates", total=total_templates)

        for template in TEMPLATES:
            progress.update(task, description=f"Installing [cyan]{template}[/cyan]")
            url = f"{RAW_URL}/templates/{template}"
            dest = templates_dir / template
            if download_file(url, dest, force):
                success_count += 1
            progress.advance(task)

    console.print(f"[cyan]Templates:[/cyan] [bold green]{success_count}[/bold green]/[bold]{total_templates}[/bold] processed")

def create_project_directories():
    """Create project directories for workflow organization with enhanced styling."""
    directories = [
        ("./context", "Project knowledge storage"),
        ("./tasks", "Task requirements documentation"),
        ("./plans", "Implementation plans"),
        ("./implementations", "Code implementations")
    ]

    console.print(Rule("[bold cyan]Project Structure Setup[/bold cyan]"))

    for directory_path, description in directories:
        directory = Path(directory_path)
        if not directory.exists():
            directory.mkdir(parents=True, exist_ok=True)
            console.print(f"[green]Created:[/green] [bold cyan]{directory}[/bold cyan] [dim]({description})[/dim]")
        else:
            console.print(f"[blue]Exists:[/blue] [bold cyan]{directory}[/bold cyan] [dim]({description})[/dim]")

def install_commands_and_agents(force: bool = False):
    """Install command and agent files with enhanced progress tracking."""
    commands_dir = Path(".claude/commands")
    agents_dir = Path(".claude/agents")

    # Check and preserve existing directories
    if commands_dir.exists():
        console.print("[blue]Found existing[/blue] .claude/commands directory")
    else:
        commands_dir.mkdir(parents=True, exist_ok=True)
        console.print("[green]Created[/green] .claude/commands directory")

    if agents_dir.exists():
        console.print("[blue]Found existing[/blue] .claude/agents directory")
    else:
        agents_dir.mkdir(parents=True, exist_ok=True)
        console.print("[green]Created[/green] .claude/agents directory")

    total_items = len(COMMANDS) + len(ONBOARDING_COMMANDS) + len(AGENTS)
    cmd_success = 0
    onboarding_success = 0
    agent_success = 0

    with Progress(
        SpinnerColumn(),
        TextColumn("[progress.description]{task.description}"),
        BarColumn(bar_width=30),
        MofNCompleteColumn(),
        console=console,
        transient=True
    ) as progress:
        task = progress.add_task("Installing commands and agents", total=total_items)

        # Install commands
        for command in COMMANDS:
            progress.update(task, description=f"Installing command [cyan]{command}[/cyan]")
            url = f"{RAW_URL}/commands/{command}"
            dest = commands_dir / command
            if download_file(url, dest, force):
                cmd_success += 1
            progress.advance(task)

        # Install onboarding commands
        for command in ONBOARDING_COMMANDS:
            progress.update(task, description=f"Installing onboarding [cyan]{command}[/cyan]")
            url = f"{RAW_URL}/commands/{command}"
            dest = commands_dir / command
            dest.parent.mkdir(parents=True, exist_ok=True)
            if download_file(url, dest, force):
                onboarding_success += 1
            progress.advance(task)

        # Install agents
        for agent in AGENTS:
            progress.update(task, description=f"Installing agent [cyan]{agent}[/cyan]")
            url = f"{RAW_URL}/agents/{agent}"
            dest = agents_dir / agent
            if download_file(url, dest, force):
                agent_success += 1
            progress.advance(task)

    # Create project directories
    create_project_directories()

    # Summary with enhanced styling
    summary_table = Table(box=box.SIMPLE, show_header=False, padding=(0, 1))
    summary_table.add_column(style="cyan")
    summary_table.add_column(style="bold green", justify="right")
    summary_table.add_column(style="dim")

    summary_table.add_row("Commands", f"{cmd_success}/{len(COMMANDS)}", "processed")
    summary_table.add_row("Onboarding", f"{onboarding_success}/{len(ONBOARDING_COMMANDS)}", "processed")
    summary_table.add_row("Agents", f"{agent_success}/{len(AGENTS)}", "processed")

    console.print(summary_table)

def show_success_panel(target: str):
    """Show success message with next steps using enhanced styling."""
    # Create installation summary
    install_summary = Table(box=box.SIMPLE, show_header=False, padding=(0, 1))
    install_summary.add_column("Component", style="cyan", width=20)
    install_summary.add_column("Count", style="bold green", justify="right", width=5)
    install_summary.add_column("Location", style="dim", width=30)

    install_summary.add_row("Commands", str(len(COMMANDS)), ".claude/commands/")
    install_summary.add_row("Onboarding", str(len(ONBOARDING_COMMANDS)), ".claude/commands/onboarding/")
    install_summary.add_row("Agents", str(len(AGENTS)), ".claude/agents/")
    install_summary.add_row("Templates", str(len(TEMPLATES)), ".claude/templates/")

    # Create workflow example
    workflow_steps = """[bold yellow]Example Workflow:[/bold yellow]
[bright_blue]/get_context[/bright_blue] "authentication"
[bright_blue]/task_from_scratch[/bright_blue] "Add user auth" ./context/auth.md
[bright_blue]/plan_from_task[/bright_blue] "./tasks/user-auth-task.md"
[bright_blue]/implement_plan[/bright_blue] "./plans/user-auth-plan.md"

[bold yellow]Quick Start:[/bold yellow]
[bright_cyan]claude[/bright_cyan]                Launch Claude Code
[bright_cyan]/help[/bright_cyan]                 Show available commands
[bright_cyan]/agents[/bright_cyan]               List specialized agents"""

    # Main success panel
    success_content = f"""[bold green]Installation Complete![/bold green]

[bold blue]Installed in {target}:[/bold blue]

{install_summary}

Project directories: [cyan]context/[/cyan], [cyan]tasks/[/cyan], [cyan]plans/[/cyan], [cyan]implementations/[/cyan]

{workflow_steps}

[bold green]Your agentic engineering workflow is ready![/bold green]"""

    console.print(Panel(
        success_content,
        title="Claude Code Agentic Engineering",
        border_style="green",
        box=box.ROUNDED,
        padding=(1, 2)
    ))

if __name__ == "__main__":
    main()