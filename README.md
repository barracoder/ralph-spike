# Ralph Wiggum - AI Automation Loop

A repository configured with essential tools and documentation for AI-powered development automation using GitHub Copilot and other AI assistants.

## Overview

This repository is set up to support the Ralph Wiggum AI automation loop, which enables efficient, consistent, and high-quality automated code generation and modifications. The configuration includes:

- **`.dotsettings` Configuration**: ReSharper/Rider settings optimized for AI-friendly code
- **Comprehensive Documentation**: Guides and standards for AI assistants
- **Prompt Templates**: Ready-to-use templates for GitHub Copilot CLI
- **Best Practices**: Coding standards and troubleshooting guides

## Repository Structure

```
ralph-spike/
├── .dotsettings                     # ReSharper/Rider configuration
├── docs/
│   ├── ai-automation-guide.md       # Guide for AI automation workflow
│   ├── coding-standards.md          # C# coding standards and conventions
│   ├── copilot-prompts.md          # GitHub Copilot prompt templates
│   └── troubleshooting.md          # Common issues and solutions
└── README.md                        # This file
```

## Getting Started

### For AI Assistants

When working with this repository, AI assistants should:

1. **Read the documentation** in the `docs/` directory to understand project conventions
2. **Follow coding standards** defined in `docs/coding-standards.md`
3. **Use prompt templates** from `docs/copilot-prompts.md` for consistent interactions
4. **Consult troubleshooting guide** at `docs/troubleshooting.md` for common issues

### For Developers

1. **Clone the repository**:
   ```bash
   git clone https://github.com/barracoder/ralph-spike.git
   cd ralph-spike
   ```

2. **Configure your IDE**:
   - For ReSharper/Rider: The `.dotsettings` file will be automatically detected
   - Settings include code formatting, naming conventions, and AI-friendly configurations

3. **Review the documentation**:
   - Start with `docs/ai-automation-guide.md` for an overview
   - Check `docs/coding-standards.md` for style guidelines

### For GitHub Copilot Users

This repository is optimized for use with GitHub Copilot CLI:

1. **Use the prompt templates** in `docs/copilot-prompts.md`
2. **Reference the guides** in your prompts for better context
3. **Follow the automation workflow** described in `docs/ai-automation-guide.md`

Example:
```bash
gh copilot suggest "Create a service following the patterns in docs/coding-standards.md"
```

## Documentation

### Core Guides

- **[AI Automation Guide](docs/ai-automation-guide.md)**: Principles and workflow for AI-powered automation
- **[Coding Standards](docs/coding-standards.md)**: C# coding conventions, formatting, and best practices
- **[Copilot Prompts](docs/copilot-prompts.md)**: Templates for effective GitHub Copilot interactions
- **[Troubleshooting](docs/troubleshooting.md)**: Common issues and solutions

### Key Features

#### .DotSettings Configuration
The `ralph-spike.sln.DotSettings` file provides:
- Consistent code formatting (4-space indentation, 120-char line length)
- AI-friendly naming conventions
- Code inspection settings optimized for automation
- Documentation requirements for public APIs

#### Prompt Templates
Ready-to-use templates for:
- Code generation and refactoring
- Testing (unit and integration)
- Documentation
- Code review and security analysis
- Performance optimization
- Troubleshooting

## Best Practices

### For AI-Powered Development

1. **Context First**: Always understand existing code before making changes
2. **Minimal Changes**: Make the smallest possible modifications
3. **Quality Checks**: Validate changes with tests and reviews
4. **Documentation**: Keep guides and code in sync
5. **Iterative Improvement**: Learn from each interaction

### For Code Quality

- Follow the coding standards in `docs/coding-standards.md`
- Use the `.dotsettings` configuration for consistency
- Write tests for new functionality
- Document public APIs with XML comments
- Run security scans on changes

## Contributing

When contributing to this repository:

1. Follow the coding standards
2. Update documentation if changing conventions
3. Test your changes thoroughly
4. Use clear, descriptive commit messages
5. Keep changes focused and minimal

## Automation Workflow

The Ralph Wiggum automation loop follows these steps:

1. **Understand**: Read context and documentation
2. **Plan**: Outline minimal changes needed
3. **Implement**: Make targeted modifications
4. **Validate**: Test and verify changes
5. **Document**: Update guides if needed
6. **Commit**: Push changes with clear messages

See `docs/ai-automation-guide.md` for detailed workflow.

## License

[Add your license information here]

## Support

For questions or issues:
- Review the [Troubleshooting Guide](docs/troubleshooting.md)
- Check existing documentation in `docs/`
- [Add contact or issue reporting information]