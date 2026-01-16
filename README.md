# Space Invaders (Blazor)

Classic Space Invaders game built with Blazor WebAssembly and .NET 8, developed using the Ralph autonomous coding agent.

## Tech Stack

- **Framework:** Blazor WebAssembly (.NET 8)
- **Rendering:** HTML5 Canvas via Blazor.Extensions.Canvas
- **Agent:** Ralph with GitHub Copilot CLI

## Quick Start

```bash
# Clone and setup
git clone https://github.com/markgreen/ralph-spike.git
cd ralph-spike
./setup-ralph-skills.sh

# Run Ralph (autonomous agent)
./scripts/ralph/ralph-copilot.sh
```

## Running Ralph

Ralph autonomously implements stories from `scripts/ralph/prd.json`.

### With Copilot CLI

```bash
./scripts/ralph/ralph-copilot.sh [iterations] [model]

# Examples
./scripts/ralph/ralph-copilot.sh              # 10 iterations, gpt-5.1-codex
./scripts/ralph/ralph-copilot.sh 20           # 20 iterations
./scripts/ralph/ralph-copilot.sh 15 claude-sonnet-4
```

### With Amp

```bash
./scripts/ralph/ralph.sh [iterations]
```

### How It Works

1. Reads PRD from `scripts/ralph/prd.json`
2. Picks first story where `passes: false`
3. Implements, tests, commits
4. Updates PRD and `progress.txt`
5. Repeats until all stories pass or max iterations

## PRD Format

```json
{
  "branchName": "ralph/feature-name",
  "stories": [
    {
      "id": 1,
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

}

```

## Project Structure

```

├── AGENTS.md # Persistent learnings for AI agents
├── PRD.md # Human-readable requirements
├── README.md
├── .github/skills/ # Ralph skills
│ ├── back-pressure/
│ ├── circuit-breaker/
│ ├── code-review/
│ ├── commit-convention/
│ ├── dev-browser/ # Playwright visual testing
│ ├── prd/
│ └── ...
├── scripts/ralph/
│ ├── prd.json # Machine-readable stories
│ ├── prompt.md # Agent system prompt
│ ├── progress.txt # Implementation log
│ ├── ralph.sh # Amp version
│ └── ralph-copilot.sh # Copilot CLI version
└── setup-ralph-skills.sh # Bootstrap script

```

## Skills

Ralph uses modular skills in `.github/skills/`:

| Skill | Purpose |
|-------|---------|
| `back-pressure` | Enforce test/lint gates before commits |
| `circuit-breaker` | Halt after repeated failures |
| `code-review` | Self-review for quality/security |
| `commit-convention` | Conventional commits format |
| `dev-browser` | Playwright visual verification |
| `prd` | Generate/validate PRD JSON |
| `test-architect` | TDD and high coverage tests |
```
