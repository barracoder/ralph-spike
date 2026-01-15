# Ralph Wiggum AI Automation Loop Guide

## Overview

This guide provides essential context for AI assistants (like GitHub Copilot) working within the Ralph Wiggum automation loop. The goal is to enable efficient, consistent, and high-quality automated code generation and modifications.

## Purpose

Ralph Wiggum is an AI-powered automation system designed to:
- Generate and modify code following project conventions
- Maintain consistency across the codebase
- Reduce manual intervention in routine development tasks
- Provide intelligent assistance for complex coding scenarios

## Key Principles

### 1. Consistency First
- Always follow existing code patterns in the repository
- Maintain consistent naming conventions across files
- Use established project structure and organization

### 2. Minimal Changes
- Make the smallest possible changes to accomplish goals
- Avoid refactoring unrelated code
- Preserve existing functionality unless explicitly changing it

### 3. Clear Communication
- Write descriptive commit messages
- Document non-obvious code decisions
- Provide context in comments when complexity is unavoidable

### 4. Safety and Quality
- Never commit secrets or sensitive data
- Validate changes before committing
- Run tests to ensure changes don't break existing functionality
- Follow security best practices

## Automation Loop Workflow

1. **Understand Context**: Read relevant documentation and code before making changes
2. **Plan Changes**: Outline modifications needed to accomplish the goal
3. **Implement**: Make minimal, targeted changes
4. **Validate**: Test changes to ensure they work as expected
5. **Document**: Update documentation if needed
6. **Commit**: Use clear, descriptive commit messages

## Best Practices for AI Assistants

### Code Generation
- Follow the project's `.dotsettings` configuration
- Use consistent indentation (4 spaces for C#)
- Keep line length under 120 characters
- Add XML documentation for public APIs

### Code Modification
- Preserve existing code style
- Maintain backward compatibility when possible
- Update related tests when changing functionality
- Keep refactoring separate from feature changes

### Error Handling
- Use appropriate exception types
- Provide meaningful error messages
- Log important events for debugging
- Don't swallow exceptions without good reason

### Testing
- Write tests for new functionality
- Update existing tests when behavior changes
- Ensure tests are clear and maintainable
- Use descriptive test names

## Common Patterns

### Naming Conventions
- Classes: `PascalCase`
- Methods: `PascalCase`
- Private fields: `camelCase`
- Constants: `PascalCase`
- Interfaces: `IPascalCase` (with 'I' prefix)

### File Organization
- One public type per file
- File name matches the primary type name
- Group related files in appropriate directories
- Keep file size reasonable (under 500 lines when possible)

## Integration with GitHub Copilot

This guide is designed to be read by GitHub Copilot CLI to improve its suggestions and code generation. When using Copilot:

1. Reference this guide for project-specific context
2. Use the coding standards guide for style rules
3. Consult the troubleshooting guide for common issues
4. Apply prompt templates for consistent AI interactions

## Continuous Improvement

The automation loop improves over time by:
- Learning from code review feedback
- Adapting to new patterns in the codebase
- Incorporating team preferences
- Staying updated with best practices

## Related Documentation

- [Coding Standards](./coding-standards.md)
- [Prompt Templates](./copilot-prompts.md)
- [Troubleshooting Guide](./troubleshooting.md)
