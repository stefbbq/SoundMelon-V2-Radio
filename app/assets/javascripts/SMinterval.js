var SMinterval = function(fn, time) {
    var timer = false;

    function start() {
        if(!isRunning()) {
            timer = setInterval(fn, time);
        }
    }

    function stop() {
        clearInterval(timer);
        timer = false;
    }

    function isRunning() {
        return timer !== false;
    }

    return {
        isRunning: isRunning,
        start: start,
        stop: stop
    }
}