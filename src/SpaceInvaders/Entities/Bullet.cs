namespace SpaceInvaders.Entities;

public class Bullet
{
    public float X { get; set; }
    public float Y { get; set; }
    public float Width { get; } = 4;
    public float Height { get; } = 10;
    public float Speed { get; }

    private const float CanvasHeight = 600;

    public Bullet(float x, float y, float speed = -8)
    {
        X = x;
        Y = y;
        Speed = speed; // Negative for upward movement
    }

    public void Update()
    {
        Y += Speed;
    }

    public bool IsOffScreen()
    {
        return Y + Height < 0 || Y > CanvasHeight;
    }
}
