// Game loop JS interop for Blazor
window.gameLoop = {
    animationFrameId: null,
    dotNetRef: null,
    isRunning: false,

    start: function (dotNetReference) {
        this.dotNetRef = dotNetReference;
        this.isRunning = true;
        this.tick();
    },

    tick: function () {
        if (!this.isRunning) return;
        
        this.dotNetRef.invokeMethodAsync('GameLoopTick')
            .then(() => {
                this.animationFrameId = requestAnimationFrame(() => this.tick());
            })
            .catch(err => {
                console.error('Game loop error:', err);
                this.stop();
            });
    },

    stop: function () {
        this.isRunning = false;
        if (this.animationFrameId) {
            cancelAnimationFrame(this.animationFrameId);
            this.animationFrameId = null;
        }
    }
};
