# ralph-spike

A spike project demonstrating the Ralph autonomous coding agent workflow.

## Overview

This project uses Ralph, an AI-powered coding agent that autonomously works through a PRD (Product Requirements Document) to implement user stories one at a time.

## Installation

```bash
# Clone the repository
git clone https://github.com/markgreen/ralph-spike.git
cd ralph-spike

# Set up Ralph skills (optional)
./setup-ralph-skills.sh
```

## Running Ralph

Ralph is an autonomous agent that reads from `scripts/ralph/prd.json` and implements stories iteratively.

### Quickstart

1. **Define your PRD** - Edit `scripts/ralph/prd.json` with your user stories
2. **Start Ralph** - Run the Ralph agent in your AI coding environment
3. **Monitor progress** - Check `scripts/ralph/progress.txt` for implementation logs

Ralph will:
- Pick the highest priority story where `passes: false`
- Implement the story
- Run quality checks
- Commit changes
- Update the PRD and progress log

### PRD Structure

```json
{
  "branchName": "feature-branch-name",
  "stories": [
    {
      "id": 1,
      "title": "Story title",
      "description": "What to implement",
      "acceptance_criteria": ["Criterion 1", "Criterion 2"],
      "passes": false
    }
  ]
}
```

## Project Structure

```
├── AGENTS.md              # Instructions for AI agents
├── README.md              # This file
├── scripts/
│   └── ralph/
│       ├── prd.json       # Product requirements
│       └── progress.txt   # Implementation log
└── setup-ralph-skills.sh  # Ralph skills installer
```