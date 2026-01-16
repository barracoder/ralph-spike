window.audio = {
    ctx: null,
    ensureCtx: function() {
        if (!this.ctx) this.ctx = new (window.AudioContext || window.webkitAudioContext)();
        return this.ctx;
    },
    play: function(name) {
        var ctx = this.ensureCtx();
        var now = ctx.currentTime;
        var o = ctx.createOscillator();
        var g = ctx.createGain();
        var freq = 440;
        var dur = 0.1;
        switch(name){
            case 'shoot': freq=900; dur=0.05; break;
            case 'explosion': freq=120; dur=0.25; break;
            case 'move': freq=600; dur=0.02; break;
            case 'damage': freq=220; dur=0.18; break;
            default: freq=440; dur=0.1;
        }
        o.type = 'square';
        o.frequency.setValueAtTime(freq, now);
        g.gain.setValueAtTime(0.15, now);
        o.connect(g);
        g.connect(ctx.destination);
        o.start(now);
        o.stop(now + dur);
    }
};
