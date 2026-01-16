namespace SpaceInvaders.Entities;

public class Player
{
    public float X { get; set; }
    public float Y { get; set; }
    public float Width { get; } = 50;
    public float Height { get; } = 20;
    public float Speed { get; } = 5;

    private const float CanvasWidth = 800;
    private const float CanvasHeight = 600;

    public Player()
    {
        // Start at bottom center
        X = (CanvasWidth - Width) / 2;
        Y = CanvasHeight - Height - 20;
    }

    public void MoveLeft()
    {
        X -= Speed;
        if (X < 0) X = 0;
    }

    public void MoveRight()
    {
        X += Speed;
        if (X + Width > CanvasWidth) X = CanvasWidth - Width;
    }

    public void Update(bool leftPressed, bool rightPressed)
    {
        if (leftPressed) MoveLeft();
        if (rightPressed) MoveRight();
    }
}
