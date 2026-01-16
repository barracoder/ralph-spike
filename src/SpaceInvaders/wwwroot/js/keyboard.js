// Keyboard input handling for game controls
window.keyboard = {
    keys: {},

    init: function () {
        document.addEventListener('keydown', (e) => {
            this.keys[e.code] = true;
            // Prevent page scrolling with arrow keys
            if (['ArrowLeft', 'ArrowRight', 'ArrowUp', 'ArrowDown', 'Space'].includes(e.code)) {
                e.preventDefault();
            }
        });

        document.addEventListener('keyup', (e) => {
            this.keys[e.code] = false;
        });
    },

    isLeftPressed: function () {
        return this.keys['ArrowLeft'] || this.keys['KeyA'] || false;
    },

    isRightPressed: function () {
        return this.keys['ArrowRight'] || this.keys['KeyD'] || false;
    },

    isSpacePressed: function () {
        return this.keys['Space'] || false;
    },

    getState: function () {
        return {
            left: this.isLeftPressed(),
            right: this.isRightPressed(),
            space: this.isSpacePressed()
        };
    }
};
