namespace SpaceInvaders.Entities;

public class Invader
{
    public float X { get; set; }
    public float Y { get; set; }
    public float Width { get; } = 30;
    public float Height { get; } = 20;
    public int Row { get; }
    public int Column { get; }
    public bool IsAlive { get; set; } = true;

    public Invader(int row, int column, float x, float y)
    {
        Row = row;
        Column = column;
        X = x;
        Y = y;
    }
}
