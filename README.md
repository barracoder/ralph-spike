# Ralph Workflow Template

A template repository for autonomous AI coding workflows using the Ralph agent loop. Clone this repo to bootstrap Ralph skills, scripts, and configuration for any new project.

## What is Ralph?

Ralph is an autonomous coding agent workflow that:

- Reads a structured PRD (prd.json) with user stories
- Implements one story per iteration
- Runs quality gates (build, test, lint)
- Commits changes and tracks progress
- Repeats until all stories pass

## Quick Start

```bash
# Clone as template for your project
git clone https://github.com/barracoder/ralph-spike.git my-project
cd my-project

# Create your PRD
# Edit scripts/PRD.md (human-readable) → scripts/ralph/prd.json (machine-readable)

# Run Ralph
./scripts/ralph/ralph-copilot.sh   # GitHub Copilot CLI
./scripts/ralph/ralph.sh           # Amp
```

## What's Included

### Skills (`.github/skills/`)

Modular behaviors that AI agents can load:

| Skill               | Purpose                                                                 |
| ------------------- | ----------------------------------------------------------------------- |
| `back-pressure`     | Enforce build/test/lint gates before commits (.NET, Node, Python, Rust) |
| `blazor-components` | Blazor-specific patterns: JS interop, state management, canvas          |
| `circuit-breaker`   | Halt after repeated failures, log context for debugging                 |
| `code-review`       | Self-review checklist for quality/security                              |
| `commit-convention` | `feat: [Story ID] - [Title]` format aligned with Ralph                  |
| `dev-browser`       | Playwright visual verification (Node, Python, Blazor)                   |
| `prd`               | PRD JSON schema with `priority`/`dependsOn` fields                      |
| `pr-creator`        | Auto-create PR with story summary after completion                      |
| `progress-logger`   | Maintain progress.txt with patterns and learnings                       |
| `test-architect`    | TDD patterns for xUnit/bUnit, vitest, pytest                            |

### Scripts (`scripts/ralph/`)

| File               | Purpose                                          |
| ------------------ | ------------------------------------------------ |
| `ralph.sh`         | Main loop for Amp agent                          |
| `ralph-copilot.sh` | Main loop for GitHub Copilot CLI                 |
| `prompt.md`        | System prompt with agent instructions            |
| `prd.json`         | Machine-readable stories (generated from PRD.md) |
| `progress.txt`     | Iteration log with learnings                     |

### Configuration

| File             | Purpose                                |
| ---------------- | -------------------------------------- |
| `AGENTS.md`      | Persistent learnings for all AI agents |
| `scripts/PRD.md` | Human-readable requirements template   |

## Running Ralph

### With GitHub Copilot CLI

```bash
./scripts/ralph/ralph-copilot.sh [iterations] [model]

# Examples
./scripts/ralph/ralph-copilot.sh              # 10 iterations, default model
./scripts/ralph/ralph-copilot.sh 20           # 20 iterations
./scripts/ralph/ralph-copilot.sh 15 claude-sonnet-4
```

### With Amp

```bash
./scripts/ralph/ralph.sh [iterations]
```

### How It Works

1. Reads PRD from `scripts/ralph/prd.json`
2. Picks highest priority story where `passes: false`
3. Implements, tests, commits
4. Updates PRD and `progress.txt`
5. Repeats until all stories pass or max iterations
6. Outputs `<promise>COMPLETE</promise>` when done

## PRD Format

```json
{
  "branchName": "ralph/feature-name",
  "stories": [
    {
      "id": 1,
      "priority": 1,
      "dependsOn": [],
      "category": "setup",
      "title": "Project setup",
      "description": "What to build",
      "acceptance_criteria": ["Criterion 1"],
      "verification_steps": ["dotnet test"],
      "passes": false
    }
  ]
}
```

## Using as a Template

1. **Clone or fork this repo**
2. **Delete the sample project** (e.g., `src/SpaceInvaders/`)
3. **Write your PRD** in `scripts/PRD.md`
4. **Generate prd.json** using an AI agent with the `prd` skill
5. **Run Ralph** to implement your stories

## Example Project

The `ralph-spike` branch contains a sample Space Invaders game built with Blazor WebAssembly, demonstrating the Ralph workflow in action.

## Testing

A comprehensive test suite validates Ralph tooling:

```bash
# Run all tests
cd tests/ralph
./run_tests.sh
```

See [tests/ralph/README.md](tests/ralph/README.md) for detailed test documentation.

## License

MIT
