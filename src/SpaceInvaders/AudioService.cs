using Microsoft.JSInterop;

namespace SpaceInvaders.Services
{
    public class AudioService
    {
        private readonly IJSRuntime _js;
        public AudioService(IJSRuntime js) => _js = js;

        public ValueTask PlayAsync(string name) => _js.InvokeVoidAsync("audio.play", name);
        public ValueTask PlayShootAsync() => PlayAsync("shoot");
        public ValueTask PlayExplosionAsync() => PlayAsync("explosion");
        public ValueTask PlayMoveAsync() => PlayAsync("move");
        public ValueTask PlayDamageAsync() => PlayAsync("damage");
    }
}
