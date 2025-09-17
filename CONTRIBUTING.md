# Contributing to Claude Code Agentic Engineering

Thank you for your interest in contributing! This project thrives on community contributions and we welcome all forms of participation.

## 🎯 Ways to Contribute

### 🐛 Bug Reports
- Use the issue template for bug reports
- Include your Claude Code version and operating system
- Provide minimal reproduction steps
- Include relevant command output or error messages

### 💡 Feature Requests
- Check existing issues to avoid duplicates
- Clearly describe the use case and benefits
- Consider proposing a new slash command or subagent
- Provide examples of how it would be used

### 📖 Documentation
- Fix typos and improve clarity
- Add usage examples and tutorials
- Create workflow guides for specific scenarios
- Translate documentation to other languages

### 🔧 Code Contributions
- New slash commands for specific workflows
- Specialized subagents for domain expertise
- Improvements to existing commands and agents
- Performance optimizations and bug fixes

## 🚀 Getting Started

### Prerequisites
- [Claude Code](https://claude.ai/code) installed
- Git for version control
- Basic understanding of Claude Code slash commands and subagents

### Development Setup
1. **Fork the repository**
2. **Clone your fork**
   ```bash
   git clone https://github.com/YOUR_USERNAME/claude-code-agentic-engineering.git
   cd claude-code-agentic-engineering
   ```
3. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```
4. **Test your changes**
   ```bash
   ./setup.sh
   claude
   /help  # Verify your commands appear
   /agents  # Verify your agents are loaded
   ```

## 📋 Contribution Guidelines

### Slash Commands
When creating new slash commands:
- **Follow the official Claude Code format** with YAML frontmatter
- **Use descriptive names** that clearly indicate the command's purpose
- **Include comprehensive documentation** with workflow steps
- **Add control flow** for error handling and edge cases
- **Provide clear output format** specifications

### Subagents
When creating new subagents:
- **Focus on single responsibility** - each agent should have clear expertise
- **Use the "MUST BE USED" pattern** in descriptions for proactive delegation
- **Specify appropriate tools** - only include tools the agent needs
- **Create comprehensive system prompts** with clear instructions
- **Include output format specifications**

## 🔍 Testing Your Contributions

### Manual Testing Checklist
- [ ] Commands appear in `/help`
- [ ] Subagents appear in `/agents`
- [ ] Commands execute without errors
- [ ] Subagents are properly invoked
- [ ] Output format matches specifications
- [ ] Error handling works correctly
- [ ] Documentation is accurate and helpful

## 📝 Pull Request Process

### Before Submitting
1. **Test thoroughly** on your local setup
2. **Update documentation** for any new features
3. **Add examples** showing how to use new functionality
4. **Check for breaking changes** and document them

### PR Requirements
- [ ] Clear title describing the change
- [ ] Detailed description of what was changed and why
- [ ] Link to any related issues
- [ ] Screenshots or examples if applicable
- [ ] Updated documentation if needed
- [ ] Tests pass (manual verification)

We welcome all contributions and look forward to building the future of agentic engineering together! 🚀
