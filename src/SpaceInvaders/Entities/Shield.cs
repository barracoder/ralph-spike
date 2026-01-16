namespace SpaceInvaders.Entities;

public class Shield
{
    public float X { get; set; }
    public float Y { get; set; }
    public float Width { get; set; }
    public float Height { get; set; }
    public int HP { get; private set; }
    public int MaxHP { get; }

    public bool IsAlive => HP > 0;

    public Shield(float x, float y, float width = 80, float height = 40, int maxHp = 3)
    {
        X = x;
        Y = y;
        Width = width;
        Height = height;
        MaxHP = maxHp;
        HP = maxHp;
    }

    public void TakeDamage(int amount = 1)
    {
        HP -= amount;
        if (HP < 0) HP = 0;
    }

    // Fractional health 0..1 for rendering opacity
    public float HealthFraction() => MaxHP == 0 ? 0 : (float)HP / MaxHP;
}
