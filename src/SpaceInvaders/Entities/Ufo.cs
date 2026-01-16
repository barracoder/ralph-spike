namespace SpaceInvaders.Entities;

public class Ufo
{
    public float X { get; set; }
    public float Y { get; set; }
    public float Width { get; } = 40;
    public float Height { get; } = 20;
    public float Speed { get; set; }
    public bool IsAlive { get; set; } = true;

    public Ufo(float x, float y, float speed)
    {
        X = x;
        Y = y;
        Speed = speed;
    }

    public void Update()
    {
        X += Speed;
    }

    public bool IsOffScreen()
    {
        return X + Width < 0 || X > 800;
    }
}
