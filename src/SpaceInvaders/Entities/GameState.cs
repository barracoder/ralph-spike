namespace SpaceInvaders.Entities
{
    public enum GameState
    {
        Start,
        Playing,
        GameOver
    }

    public class GameStateService
    {
        public GameState Current { get; private set; } = GameState.Start;
        public void StartGame() => Current = GameState.Playing;
        public void SetGameOver() => Current = GameState.GameOver;
        public void Reset() => Current = GameState.Start;
    }
}
