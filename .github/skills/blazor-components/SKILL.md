---
name: blazor-components
description: Blazor-specific patterns for components, JS interop, and state management
---

# blazor-components

Patterns for building Blazor WebAssembly components effectively.

## JS Interop

**Invoking JavaScript from C#:**

```csharp
await JSRuntime.InvokeVoidAsync("functionName", arg1, arg2);
var result = await JSRuntime.InvokeAsync<string>("functionName", arg1);
```

**Receiving calls from JavaScript:**

```csharp
private DotNetObjectReference<MyComponent>? _dotNetRef;

protected override void OnInitialized()
{
    _dotNetRef = DotNetObjectReference.Create(this);
}

[JSInvokable]
public void OnJsCallback(string data)
{
    // Handle callback from JS
    StateHasChanged();
}
```

## Disposal Pattern

**Always implement `IAsyncDisposable` for JS interop components:**

```csharp
@implements IAsyncDisposable

@code {
    private DotNetObjectReference<GameCanvas>? _dotNetRef;

    public async ValueTask DisposeAsync()
    {
        if (_dotNetRef is not null)
        {
            await JSRuntime.InvokeVoidAsync("cleanup", _dotNetRef);
            _dotNetRef.Dispose();
        }
    }
}
```

## State Management

**UI updates after async/JS operations:**

```csharp
// From JS callback or async operation - must use InvokeAsync
await InvokeAsync(StateHasChanged);

// From synchronous event handler - direct call is fine
StateHasChanged();
```

**Shared state via DI service:**

```csharp
// Services/GameState.cs
public class GameState
{
    public int Score { get; set; }
    public int Lives { get; set; }
    public event Action? OnChange;
    public void NotifyStateChanged() => OnChange?.Invoke();
}

// Program.cs
builder.Services.AddSingleton<GameState>();

// Component
@inject GameState State
@implements IDisposable

protected override void OnInitialized() => State.OnChange += StateHasChanged;
public void Dispose() => State.OnChange -= StateHasChanged;
```

## Canvas Rendering

**Use Blazor.Extensions.Canvas for 2D graphics:**

```csharp
@using Blazor.Extensions
@using Blazor.Extensions.Canvas.Canvas2D

<BECanvas Width="800" Height="600" @ref="_canvasRef" />

@code {
    private BECanvasComponent? _canvasRef;
    private Canvas2DContext? _context;

    protected override async Task OnAfterRenderAsync(bool firstRender)
    {
        if (firstRender)
        {
            _context = await _canvasRef!.CreateCanvas2DAsync();
        }
    }

    private async Task Render()
    {
        await _context!.ClearRectAsync(0, 0, 800, 600);
        await _context.SetFillStyleAsync("green");
        await _context.FillRectAsync(x, y, width, height);
    }
}
```

## Collision Detection

**Axis-aligned bounding box (AABB) helper:**

```csharp
private static bool RectsIntersect(
    double x1, double y1, double w1, double h1,
    double x2, double y2, double w2, double h2)
{
    return x1 < x2 + w2 && x1 + w1 > x2 &&
           y1 < y2 + h2 && y1 + h1 > y2;
}
```

## Game Loop Pattern

**requestAnimationFrame via JS interop:**

```javascript
// wwwroot/js/gameLoop.js
let animationId = null;

window.startGameLoop = (dotNetRef) => {
  const loop = (timestamp) => {
    dotNetRef.invokeMethodAsync("OnFrame", timestamp);
    animationId = requestAnimationFrame(loop);
  };
  animationId = requestAnimationFrame(loop);
};

window.stopGameLoop = () => {
  if (animationId) cancelAnimationFrame(animationId);
};
```

```csharp
[JSInvokable]
public async Task OnFrame(double timestamp)
{
    Update();
    await Render();
    await InvokeAsync(StateHasChanged); // Sync Blazor UI
}
```

## Common Gotchas

- Call `InvokeAsync(StateHasChanged)` after canvas Render operations to sync Blazor markup
- Blazor WASM is single-threaded—avoid blocking calls
- Use `@key` directive when rendering lists that change order
- JS files must be in `wwwroot/` and referenced in `index.html`
- `OnAfterRenderAsync(firstRender: true)` is when DOM/canvas is ready
