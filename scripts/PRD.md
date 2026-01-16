# Space Invaders PRD

## Overview
Classic Space Invaders game built with Blazor WebAssembly and C#. Canvas-based rendering with keyboard controls.

## Tech Stack
- **Framework:** Blazor WebAssembly (.NET 8)
- **Language:** C# 12
- **Rendering:** HTML5 Canvas via Blazor.Extensions.Canvas
- **State:** Component state + cascading parameters
- **Testing:** bUnit + xUnit

## Game Mechanics

### Player
- Moves left/right with arrow keys or A/D
- Fires with spacebar (max 1 bullet on screen)
- 3 lives, respawns after hit

### Enemies
- 5 rows × 11 columns = 55 invaders
- Move horizontally, drop down at edges
- Speed increases as count decreases
- Random enemy fires downward

### Shields
- 4 destructible shields
- Degrade on bullet impact (player or enemy)

### Scoring
- Bottom row: 10 pts
- Middle rows: 20 pts  
- Top row: 30 pts
- Mystery UFO: 50-300 pts (random)

### Win/Lose
- **Win:** Destroy all invaders → next wave (faster)
- **Lose:** Invaders reach bottom OR 0 lives

## File Structure
```
SpaceInvaders/
├── Program.cs
├── SpaceInvaders.csproj
├── wwwroot/
│   └── index.html
├── Pages/
│   └── Index.razor           # Main game page
├── Components/
│   ├── GameCanvas.razor      # Canvas + game loop
│   ├── StartScreen.razor
│   ├── GameOverScreen.razor
│   └── ScoreDisplay.razor
├── Game/
│   ├── GameState.cs          # Central game state
│   ├── GameLoop.cs           # Update + render loop
│   ├── Constants.cs          # Speeds, sizes, colors
│   ├── Entities/
│   │   ├── Player.cs
│   │   ├── Invader.cs
│   │   ├── Bullet.cs
│   │   └── Shield.cs
│   ├── CollisionDetection.cs
│   └── Renderer.cs           # Canvas draw methods
├── Services/
│   ├── InputService.cs       # Keyboard handling
│   └── AudioService.cs       # Sound effects
└── Tests/
    ├── CollisionTests.cs
    └── EntityTests.cs
```

## Tasks

| ID | Title | Acceptance Criteria |
|----|-------|---------------------|
| 1 | Project setup | Blazor WASM project, `dotnet run` works |
| 2 | Canvas component | 800×600 canvas renders via Blazor.Extensions.Canvas |
| 3 | Game loop | requestAnimationFrame via JS interop, 60fps |
| 4 | Player entity | Renders, moves L/R, stays in bounds |
| 5 | Player shooting | Spacebar fires, bullet moves up, 1 max |
| 6 | Invader grid | 55 invaders render in formation |
| 7 | Invader movement | Move together, reverse + drop at edges |
| 8 | Invader shooting | Random invader fires down periodically |
| 9 | Collision detection | Bullets hit invaders/player, entities removed |
| 10 | Shields | 4 shields render, degrade on hit |
| 11 | Score + lives UI | Display score, lives, high score |
| 12 | Game states | Start → Playing → Game Over flow |
| 13 | Wave progression | Clear wave → respawn faster invaders |
| 14 | Mystery UFO | Random UFO crosses top, bonus points |
| 15 | Polish | Sound effects, animations |

## Non-Goals (v1)
- Multiplayer
- Leaderboard persistence
- Multiple weapon types
- Power-ups
