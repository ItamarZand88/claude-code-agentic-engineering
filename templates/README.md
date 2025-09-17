# Templates Directory

This directory contains professional templates that are referenced by the slash commands and can be used as starting points for various development artifacts.

## 📋 Available Templates

### 🎯 **Task Requirements Template**
**File**: `task-requirements-template.md`
**Purpose**: Comprehensive template for documenting task requirements
**Used by**: `/task-from-scratch` command
**Features**:
- Task overview and technical requirements
- Affected files and dependencies mapping
- Acceptance criteria with Given/When/Then format
- Risk assessment and timeline planning
- Definition of done checklist

### 📊 **Implementation Plan Template**
**File**: `implementation-plan-template.md`
**Purpose**: Detailed template for implementation planning
**Used by**: `/plan-from-task` command
**Features**:
- Executive summary and prerequisites
- Phase-by-phase implementation steps
- File modification tracking
- Testing checkpoints and rollback procedures
- Risk mitigation and monitoring setup

### ✅ **Code Review Template**
**File**: `code-review-template.md`
**Purpose**: Comprehensive code review report template
**Used by**: `/review-implementation` command
**Features**:
- Requirements compliance assessment
- Security vulnerability analysis
- Performance and quality metrics
- Technical debt evaluation
- Actionable recommendations with priorities

### 📝 **Coding Standards Template**
**File**: `coding-standards-template.md`
**Purpose**: Complete coding standards and best practices
**Used by**: All commands for consistency reference
**Features**:
- Language-specific naming conventions
- File organization and structure
- Documentation and testing standards
- Security and performance guidelines
- Code review and version control standards

### 🛡️ **Security Checklist Template**
**File**: `security-checklist-template.md`
**Purpose**: Comprehensive security assessment checklist
**Used by**: `/review-implementation` command for security analysis
**Features**:
- OWASP Top 10 compliance checklist
- Authentication and authorization verification
- Input validation and data protection
- Infrastructure and network security
- Privacy and compliance requirements

## 🎨 How to Use Templates

### For Development Teams
1. **Copy templates** to your project's documentation folder
2. **Customize** templates to match your team's specific requirements
3. **Reference templates** in your slash commands by updating the variables
4. **Version control** your customized templates with your project

### For Individual Projects
1. Use templates as **starting points** for documentation
2. **Fill out sections** relevant to your project
3. **Skip or modify** sections that don't apply
4. **Maintain consistency** across similar tasks

### Integration with Commands
Templates are automatically referenced by commands through these variables:
```markdown
## Variables
- **requirements_template**: `./templates/task-requirements-template.md`
- **coding_standards**: `./templates/coding-standards-template.md`
- **security_checklist**: `./templates/security-checklist-template.md`
```

## 🔧 Customization Guide

### Project-Specific Modifications
1. **Add your tech stack** specifics to coding standards
2. **Include your security requirements** in security checklist
3. **Modify acceptance criteria** format to match your methodology
4. **Update file paths** and directory structures to match your project

### Team Process Integration
1. **Add your review process** to code review template
2. **Include your deployment process** in implementation plan
3. **Reference your tools** and systems in all templates
4. **Add your compliance requirements** where applicable

## 📚 Template Structure

All templates follow consistent structure:
- **Header section** with metadata and overview
- **Main content sections** with detailed checklists
- **Customizable variables** for project-specific information
- **Action items section** with priorities and assignments
- **Approval/sign-off section** for formal processes

## 🚀 Advanced Usage

### Creating New Templates
1. Follow the **existing structure** and formatting
2. Use **checkboxes** for actionable items
3. Include **code examples** where helpful
4. Add **tables** for structured information
5. Provide **clear instructions** and guidelines

### Template Maintenance
- **Regular updates** to keep current with best practices
- **Team feedback** incorporation for continuous improvement
- **Version control** with clear change documentation
- **Testing** with actual projects to ensure usability

## 💡 Tips for Success

### Effective Template Usage
- **Don't fill everything** - use what's relevant
- **Customize liberally** - make it fit your needs
- **Maintain consistency** - use the same format across projects
- **Regular updates** - keep templates current with your practices

### Team Adoption
- **Start small** - implement one template at a time
- **Train the team** - ensure everyone understands the templates
- **Collect feedback** - improve based on actual usage
- **Celebrate success** - highlight when templates add value

---

## 📖 Related Documentation

- [WORKFLOW_GUIDE.md](../docs/WORKFLOW_GUIDE.md) - How templates integrate with commands
- [CUSTOMIZATION.md](../docs/CUSTOMIZATION.md) - How to customize for your needs
- [CONTRIBUTING.md](../CONTRIBUTING.md) - How to contribute template improvements

**Templates Version**: 1.0
**Last Updated**: [Date]
**Maintained By**: Claude Code Agentic Engineering Team
