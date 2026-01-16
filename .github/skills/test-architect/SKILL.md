---
name: test-architect
description: Write high-coverage tests (TDD preferred)
---

# test-architect

**TDD workflow:**

1. Write failing test first
2. Implement minimum code to pass
3. Refactor

**Target:** 80%+ coverage on changed code

## Framework Commands

| Stack   | Framework   | Run           | Coverage                                      |
| ------- | ----------- | ------------- | --------------------------------------------- |
| .NET    | xUnit/NUnit | `dotnet test` | `dotnet test --collect:"XPlat Code Coverage"` |
| Blazor  | bUnit       | `dotnet test` | Same as above                                 |
| Node.js | vitest/jest | `npm test`    | `npm test -- --coverage`                      |
| Python  | pytest      | `pytest`      | `pytest --cov`                                |
| Rust    | cargo       | `cargo test`  | `cargo tarpaulin`                             |

## .NET/Blazor Testing Patterns

**Unit test (xUnit):**

```csharp
[Fact]
public void Player_MovesWithinBounds()
{
    var player = new Player { X = 100 };
    player.MoveLeft(10);
    Assert.Equal(90, player.X);
}
```

**Blazor component test (bUnit):**

```csharp
[Fact]
public void ScoreDisplay_ShowsCurrentScore()
{
    using var ctx = new TestContext();
    var cut = ctx.RenderComponent<ScoreDisplay>(p => p.Add(x => x.Score, 500));
    cut.Find(".score").TextContent.Should().Contain("500");
}
```

## Integration with back-pressure

Tests must pass before any commit. If tests fail repeatedly, invoke `circuit-breaker` skill.
