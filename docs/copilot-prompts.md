# GitHub Copilot Prompt Templates

## Overview

These templates provide consistent and effective prompts for GitHub Copilot CLI when working within the Ralph Wiggum AI automation loop. Use these as starting points and customize based on specific needs.

## General Code Generation

### Basic Feature Implementation
```
Create a [feature name] that [description of functionality].

Requirements:
- Follow the coding standards in docs/coding-standards.md
- Use dependency injection for [services]
- Include XML documentation for public APIs
- Add appropriate error handling
- Write unit tests for core functionality

Context:
[Provide relevant context about existing code, patterns, or constraints]
```

### Refactoring Existing Code
```
Refactor [class/method name] to [improvement goal].

Current Issues:
- [List specific problems]

Constraints:
- Maintain backward compatibility
- Preserve existing functionality
- Follow project coding standards
- Update related tests

File Location: [path to file]
```

### Bug Fix
```
Fix bug in [component/feature] where [description of issue].

Symptoms:
- [Observable behavior]

Expected Behavior:
- [What should happen]

Investigation:
- [What you've discovered]

Requirements:
- Add regression test
- Update documentation if needed
- Maintain existing functionality
```

## Testing

### Unit Test Generation
```
Generate unit tests for [class/method name].

Test Coverage Needed:
- Happy path scenarios
- Edge cases: [list specific cases]
- Error conditions: [list error scenarios]
- Boundary conditions

Framework: [NUnit/xUnit/MSTest]
Mocking Library: [Moq/NSubstitute]

Follow existing test patterns in [test file path].
```

### Integration Test
```
Create integration test for [feature/workflow].

Test Scenario:
[Describe the end-to-end scenario]

Setup Required:
- [Database/external services/configuration]

Assertions:
- [What to verify]

Cleanup:
- [How to reset state]
```

## Documentation

### API Documentation
```
Generate XML documentation for [class/interface/method].

Include:
- Summary describing purpose and behavior
- Parameter descriptions with validation rules
- Return value description
- Exception documentation
- Example usage (if complex)

Target Audience: [Developers/External API users]
```

### README Update
```
Update README.md to document [new feature/change].

Sections to Update:
- [Installation/Usage/Configuration/etc.]

Include:
- Clear examples
- Prerequisites
- Common troubleshooting tips

Audience Level: [Beginner/Intermediate/Advanced]
```

## Code Review

### Review Request
```
Review the following code changes for:
- Adherence to coding standards (docs/coding-standards.md)
- Security vulnerabilities
- Performance concerns
- Maintainability issues
- Test coverage

[Paste code or reference files]

Focus Areas: [Specific concerns or areas of uncertainty]
```

### Security Review
```
Perform security review of [feature/code].

Check for:
- SQL injection vulnerabilities
- XSS vulnerabilities
- Authentication/authorization issues
- Sensitive data exposure
- Input validation
- Secure configuration

Code Location: [file path or paste code]
```

## Architecture and Design

### Design Proposal
```
Design a solution for [problem statement].

Requirements:
- [Functional requirements]
- [Non-functional requirements: performance, scalability, etc.]

Constraints:
- [Technical/business constraints]

Considerations:
- Existing architecture patterns in the project
- Integration with [existing components]
- Testability and maintainability

Output:
- High-level design
- Component responsibilities
- Interface definitions
- Data flow diagram (if needed)
```

### Pattern Application
```
Implement [design pattern name] for [use case].

Problem: [What problem the pattern solves]

Context:
- [Relevant existing code]
- [Integration points]

Requirements:
- Follow project coding standards
- Maintain testability
- Document pattern usage
- Provide usage examples
```

## Database and Data Access

### Database Schema
```
Create database schema for [entity/feature].

Requirements:
- Tables: [list entities]
- Relationships: [describe relationships]
- Indexes: [performance requirements]
- Constraints: [business rules]

Considerations:
- Migration strategy
- Backward compatibility
- Data types and precision
```

### Repository Pattern
```
Create repository for [entity name].

Operations Needed:
- [List CRUD and query operations]

Requirements:
- Use Entity Framework/Dapper
- Implement async methods
- Include pagination for list operations
- Add appropriate error handling
- Write unit tests with mocked data context

Interface Location: [namespace/file]
```

## Performance Optimization

### Performance Analysis
```
Analyze performance of [method/feature].

Current Metrics:
- [Response time/throughput/memory usage]

Target Metrics:
- [Performance goals]

Profile:
- Identify bottlenecks
- Suggest optimizations
- Estimate improvement impact
- Consider trade-offs

Code Location: [file path]
```

### Optimization Implementation
```
Optimize [component/query/algorithm] for [performance goal].

Current Performance: [metrics]
Target Performance: [metrics]

Constraints:
- Maintain functionality
- Keep code readable
- Consider memory vs. speed trade-offs

Approaches to Consider:
- Caching
- Async operations
- Database query optimization
- Algorithm improvements
```

## Migration and Upgrades

### Dependency Upgrade
```
Upgrade [library/framework] from [old version] to [new version].

Steps:
1. Identify breaking changes
2. Update code to handle changes
3. Update tests
4. Verify functionality
5. Update documentation

Breaking Changes Documentation: [link or list]
```

### Code Migration
```
Migrate [feature/component] from [old approach] to [new approach].

Scope:
- [List files/components affected]

Requirements:
- Maintain existing functionality
- Provide migration path for users
- Update tests
- Document changes

Timeline: [Phased/All at once]
```

## Troubleshooting and Debugging

### Issue Investigation
```
Investigate issue: [description]

Symptoms:
- [What's happening]

Steps to Reproduce:
1. [Step-by-step reproduction]

Environment:
- [Version/configuration details]

Expected vs. Actual:
- Expected: [behavior]
- Actual: [behavior]

Already Tried:
- [Previous investigation steps]
```

### Log Analysis
```
Analyze logs for [issue/pattern].

Log Source: [file/service]
Time Range: [period]

Looking For:
- [Error patterns]
- [Performance issues]
- [Anomalies]

Provide:
- Root cause analysis
- Frequency of occurrence
- Suggested fixes
```

## Best Practices for Using Templates

1. **Customize**: Adapt templates to your specific situation
2. **Be Specific**: Provide concrete details and context
3. **Include Examples**: Reference existing code when possible
4. **Set Expectations**: Clearly state requirements and constraints
5. **Iterate**: Refine prompts based on results
6. **Context is Key**: More context leads to better results

## Tips for Effective Prompts

- **Be Clear**: Use precise language
- **Be Complete**: Include all necessary information
- **Be Concise**: Remove unnecessary details
- **Reference Docs**: Point to coding standards and guides
- **Show Examples**: Reference similar existing code
- **Specify Format**: Indicate expected output format

## Common Pitfalls to Avoid

- Vague requirements: "Make it better"
- Missing context: Not referencing existing patterns
- Unclear scope: Not specifying what should/shouldn't change
- No constraints: Allowing any solution approach
- Ignoring standards: Not referencing project conventions
