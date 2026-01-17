# Ralph Submodule Usage Guide

Comprehensive guide for integrating Ralph into your project as a git submodule.

## Table of Contents

- [Quick Start](#quick-start)
- [Project Structure](#project-structure)
- [Configuration](#configuration)
- [Running Ralph](#running-ralph)
- [Docker Usage](#docker-usage)
- [Updating the Submodule](#updating-the-submodule)
- [Customization](#customization)
- [Troubleshooting](#troubleshooting)
- [CI/CD Integration](#cicd-integration)

## Quick Start

### Automated Setup

The easiest way to add Ralph to your project:

```bash
# Clone your project
git clone https://github.com/your-org/your-project.git
cd your-project

# Run setup script directly from GitHub
curl -fsSL https://raw.githubusercontent.com/barracoder/ralph-spike/main/scripts/ralph/setup-submodule.sh | bash

# Or clone ralph-spike first and run locally
git clone https://github.com/barracoder/ralph-spike.git /tmp/ralph-spike
bash /tmp/ralph-spike/scripts/ralph/setup-submodule.sh .
```

This will:
- Add ralph-spike as a git submodule in `ralph/`
- Create `run-ralph.sh` wrapper script
- Create `scripts/ralph/prd.json` template
- Create `scripts/PRD.md` template
- Create/update `AGENTS.md`
- Update `.gitignore`
- Create `.env.example`

### Manual Setup

If you prefer manual setup:

```bash
# 1. Add submodule
git submodule add https://github.com/barracoder/ralph-spike.git ralph
git submodule update --init --recursive

# 2. Create wrapper script (see Project Structure section)
# 3. Set up your PRD files
# 4. Configure environment variables
```

## Project Structure

After setup, your project will have this structure:

```
your-project/
├── ralph/                          # Git submodule
│   ├── scripts/ralph/
│   │   ├── ralph.sh               # Amp agent runner
│   │   ├── ralph-copilot.sh       # Copilot agent runner
│   │   ├── ralph-docker.sh        # Docker runner
│   │   ├── docker-compose.yml     # Docker Compose config
│   │   ├── Dockerfile             # Docker image definition
│   │   ├── docker-entrypoint.sh   # Container entrypoint
│   │   ├── setup-submodule.sh     # Setup script
│   │   └── prompt.md              # Agent prompt
│   ├── .github/skills/            # Ralph skills
│   └── SUBMODULE_USAGE.md         # This file
├── scripts/
│   ├── ralph/
│   │   ├── prd.json               # Machine-readable PRD (your tasks)
│   │   ├── progress.txt           # Ralph's progress log
│   │   └── archive/               # Archived runs
│   └── PRD.md                     # Human-readable PRD template
├── run-ralph.sh                   # Convenience wrapper
├── AGENTS.md                      # Agent instructions
├── .env.example                   # Environment template
└── .env                           # Your secrets (not committed)
```

## Configuration

### Authentication

Create a `.env` file in your project root:

```bash
# For GitHub Copilot
GITHUB_TOKEN=ghp_xxxxxxxxxxxxxxxxxxxx

# For Amp
AMP_TOKEN=your_amp_token_here

# Optional: Git config for Docker
GIT_USER_NAME=Your Name
GIT_USER_EMAIL=your.email@example.com

# Optional: Ralph settings
MAX_ITERATIONS=10
MODEL=gpt-5.1-codex
```

**Important**: Never commit `.env` to git. It's already in `.gitignore`.

### Creating Your PRD

#### Option 1: Use PRD.md (Recommended)

1. Edit `scripts/PRD.md` with your requirements in human-readable format
2. Use an AI agent to convert it to `scripts/ralph/prd.json`

Example `scripts/PRD.md`:

```markdown
# Product Requirements Document

## Project: Add User Authentication

**Branch**: `ralph/user-auth`

## User Stories

### Story 1: User Registration

**Category**: core

**Description**: Create user registration endpoint with email/password

**Acceptance Criteria**:
- [ ] POST /api/register endpoint exists
- [ ] Validates email format
- [ ] Hashes passwords with bcrypt
- [ ] Returns JWT token on success

**Verification Steps**:
- `npm test` passes
- Manual test with Postman
```

#### Option 2: Edit prd.json Directly

Edit `scripts/ralph/prd.json`:

```json
{
  "branchName": "ralph/user-auth",
  "projectName": "User Authentication",
  "stories": [
    {
      "id": 1,
      "category": "core",
      "title": "User registration endpoint",
      "description": "Create POST /api/register with email/password validation",
      "acceptance_criteria": [
        "Endpoint validates email format",
        "Passwords are hashed with bcrypt",
        "Returns JWT token"
      ],
      "verification_steps": [
        "npm test",
        "Manual API test"
      ],
      "passes": false
    }
  ]
}
```

### PRD Schema

Required fields in `prd.json`:

- `branchName`: Git branch name (convention: `ralph/feature-name`)
- `projectName`: Human-readable project name
- `stories`: Array of user stories
  - `id`: Unique numeric ID
  - `category`: `setup`/`core`/`feature`/`polish`/`ui`
  - `title`: Short description
  - `description`: Detailed requirements
  - `acceptance_criteria`: Array of success conditions
  - `verification_steps`: How to verify completion
  - `passes`: Boolean (false = pending, true = complete)

Optional fields:
- `priority`: Number (higher = more important)
- `dependsOn`: Array of story IDs that must complete first

## Running Ralph

### Local Execution

#### With GitHub Copilot CLI

```bash
# Using wrapper script
./run-ralph.sh copilot [iterations] [model]

# Examples
./run-ralph.sh copilot                    # 10 iterations, default model
./run-ralph.sh copilot 20                 # 20 iterations
./run-ralph.sh copilot 15 claude-sonnet-4 # Custom model

# Or call directly
./ralph/scripts/ralph/ralph-copilot.sh 10 gpt-5.1-codex
```

#### With Amp

```bash
# Using wrapper script
./run-ralph.sh amp [iterations]

# Examples
./run-ralph.sh amp      # 10 iterations
./run-ralph.sh amp 20   # 20 iterations

# Or call directly
./ralph/scripts/ralph/ralph.sh 10
```

### Ralph Behavior

1. Reads `scripts/ralph/prd.json`
2. Finds first story where `passes: false`
3. Implements the story
4. Runs verification steps
5. Updates `passes: true` if successful
6. Commits changes and updates `progress.txt`
7. Repeats until all stories pass or max iterations reached
8. Outputs `<promise>COMPLETE</promise>` when done

## Docker Usage

Docker provides an isolated environment with all dependencies pre-installed.

### Using the Docker Wrapper Script

```bash
# GitHub Copilot in Docker
export GITHUB_TOKEN=your_token
./ralph/scripts/ralph/ralph-docker.sh copilot 10 gpt-5.1-codex

# Amp in Docker
export AMP_TOKEN=your_token
./ralph/scripts/ralph/ralph-docker.sh amp 10
```

### Using Docker Compose

```bash
cd ralph/scripts/ralph

# Run with Copilot
export GITHUB_TOKEN=your_token
docker-compose run --rm ralph-copilot

# Run with Amp
export AMP_TOKEN=your_token
docker-compose run --rm ralph-amp

# Customize iterations and model
export MAX_ITERATIONS=20
export MODEL=claude-sonnet-4
docker-compose run --rm ralph-copilot
```

### Direct Docker Commands

```bash
# Build image
cd ralph/scripts/ralph
docker build -t ralph-runner .

# Run with Copilot
docker run --rm -it \
  -e GITHUB_TOKEN=$GITHUB_TOKEN \
  -e RALPH_AGENT=copilot \
  -e MAX_ITERATIONS=10 \
  -e MODEL=gpt-5.1-codex \
  -v $(pwd)/../../..:/workspace \
  -v ~/.gitconfig:/root/.gitconfig:ro \
  -v ~/.ssh:/root/.ssh:ro \
  ralph-runner

# Run with Amp
docker run --rm -it \
  -e AMP_TOKEN=$AMP_TOKEN \
  -e RALPH_AGENT=amp \
  -e MAX_ITERATIONS=10 \
  -v $(pwd)/../../..:/workspace \
  -v ~/.gitconfig:/root/.gitconfig:ro \
  -v ~/.ssh:/root/.ssh:ro \
  ralph-runner
```

### Docker Image Contents

The Ralph Docker image includes:
- .NET SDK 8.0
- Node.js 20.x
- Python 3
- Git, curl, jq, wget
- GitHub CLI with Copilot extension
- Pre-configured git settings

## Updating the Submodule

### Update to Latest Ralph

```bash
# Update submodule to latest version
git submodule update --remote ralph

# Commit the update
git add ralph
git commit -m "Update ralph submodule to latest version"
```

### Pull Specific Version

```bash
cd ralph
git fetch
git checkout v1.2.3  # or specific commit hash
cd ..
git add ralph
git commit -m "Update ralph to v1.2.3"
```

### Keep Submodule in Sync

When others clone your repository:

```bash
# Clone with submodules
git clone --recurse-submodules https://github.com/your-org/your-project.git

# Or after cloning
git submodule update --init --recursive
```

## Customization

### Custom Agent Instructions

Edit `AGENTS.md` in your project root to add project-specific rules:

```markdown
## Project-Specific Gotchas

- Use TypeScript strict mode
- All API endpoints must have OpenAPI documentation
- Run `npm run format` before committing
```

### Custom Skills

Ralph loads skills from `.github/skills/`. You can:

1. **Add project-specific skills**: Create `.github/skills/my-skill/SKILL.md`
2. **Reference Ralph skills**: Skills in `ralph/.github/skills/` are automatically available

### Wrapper Script Customization

Edit `run-ralph.sh` to add pre/post hooks:

```bash
#!/bin/bash
# Custom pre-processing
echo "Running custom linter..."
npm run lint

# Run Ralph
exec "$RALPH_DIR/ralph-copilot.sh" "$@"

# Post-processing (won't run due to exec)
# Use a separate wrapper script if needed
```

## Troubleshooting

### Submodule Not Found

```bash
# Initialize submodules
git submodule update --init --recursive
```

### Authentication Errors

**GitHub Copilot**:
```bash
# Verify token
echo $GITHUB_TOKEN

# Test GitHub CLI
gh auth status

# Re-authenticate
gh auth login
```

**Amp**:
```bash
# Verify token is set
echo $AMP_TOKEN

# Check Amp installation
which amp
amp --version
```

### Docker Issues

**Image won't build**:
```bash
# Clear Docker cache
docker system prune -a

# Rebuild without cache
docker build --no-cache -t ralph-runner ./ralph/scripts/ralph
```

**Permission errors**:
```bash
# On Linux, you may need to fix permissions
sudo chown -R $USER:$USER .

# Or run Docker with your user
docker run --user $(id -u):$(id -g) ...
```

### PRD Validation Errors

**Common issues**:
1. Missing `branchName` field in `prd.json`
2. Invalid JSON syntax
3. Story missing required fields

**Validate JSON**:
```bash
# Check JSON syntax
jq . scripts/ralph/prd.json

# Validate required fields
jq '.branchName, .stories[0].id' scripts/ralph/prd.json
```

### Ralph Stuck in Loop

If Ralph keeps failing the same story:

1. Check `scripts/ralph/progress.txt` for error patterns
2. Manually fix the blocking issue
3. Update `passes: true` for completed stories
4. Reduce `MAX_ITERATIONS` to prevent infinite loops
5. Review `AGENTS.md` for project-specific rules Ralph should know

## CI/CD Integration

### GitHub Actions

See `.github/workflows/ralph-workflow.yml.template` for a complete example.

Basic workflow:

```yaml
name: Ralph Automation

on:
  workflow_dispatch:
    inputs:
      iterations:
        description: 'Max iterations'
        required: false
        default: '10'
      model:
        description: 'Model to use'
        required: false
        default: 'gpt-5.1-codex'

jobs:
  ralph:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
        with:
          submodules: recursive
          token: ${{ secrets.GITHUB_TOKEN }}
      
      - name: Setup .NET
        uses: actions/setup-dotnet@v3
        with:
          dotnet-version: '8.0.x'
      
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '20'
      
      - name: Install GitHub CLI
        run: |
          curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
          echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
          sudo apt-get update
          sudo apt-get install -y gh
          gh extension install github/gh-copilot
      
      - name: Run Ralph
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        run: |
          ./ralph/scripts/ralph/ralph-copilot.sh ${{ github.event.inputs.iterations }} ${{ github.event.inputs.model }}
      
      - name: Push changes
        run: |
          git config --global user.name "Ralph Agent"
          git config --global user.email "ralph@agent.local"
          git push
      
      - name: Upload artifacts
        uses: actions/upload-artifact@v3
        if: always()
        with:
          name: ralph-output
          path: |
            scripts/ralph/progress.txt
            scripts/ralph/prd.json
```

### Using Docker in CI

```yaml
- name: Run Ralph with Docker
  env:
    GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
  run: |
    ./ralph/scripts/ralph/ralph-docker.sh copilot ${{ github.event.inputs.iterations }} ${{ github.event.inputs.model }}
```

### Environment Secrets

In your GitHub repository settings, add:
- `GITHUB_TOKEN` (automatically available in Actions)
- `AMP_TOKEN` (if using Amp)

## Advanced Usage

### Multiple PRDs

Run different PRDs for different features:

```bash
# Feature A
cp scripts/ralph/prd-feature-a.json scripts/ralph/prd.json
./run-ralph.sh copilot

# Feature B
cp scripts/ralph/prd-feature-b.json scripts/ralph/prd.json
./run-ralph.sh copilot
```

### Archiving Runs

Ralph automatically archives previous runs when the branch name changes. Archives are stored in `scripts/ralph/archive/`.

### Parallel Execution

**Warning**: Don't run multiple Ralph instances on the same repository simultaneously. Use separate clones:

```bash
# Clone 1: Feature A
git clone --recurse-submodules your-repo.git repo-feature-a
cd repo-feature-a
# Edit prd.json for feature A
./run-ralph.sh copilot

# Clone 2: Feature B
git clone --recurse-submodules your-repo.git repo-feature-b
cd repo-feature-b
# Edit prd.json for feature B
./run-ralph.sh copilot
```

## Getting Help

- **Documentation**: Check `ralph/README.md` for Ralph internals
- **Skills**: Browse `ralph/.github/skills/` for available behaviors
- **Issues**: https://github.com/barracoder/ralph-spike/issues
- **Examples**: See the Space Invaders project in the main ralph-spike repo

## License

Ralph is MIT licensed. See `ralph/LICENSE` for details.
