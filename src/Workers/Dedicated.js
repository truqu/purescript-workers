exports._new = function _new(src) {
    return function _new2(opts) {
        return function eff() {
            return new Worker(src, opts);
        };
    };
};

exports._terminate = function _terminate(wrk) {
    return function eff() {
        wrk.terminate();
    };
};

exports._onMessage = function _onMessage(wrk) {
    return function onMessage2(f) {
        return function eff() {
            wrk.onmessage = function onmessage(e) {
                f(e.data)();
            };
        };
    };
};

exports._onMessageError = function _onMessageError(wrk) {
    return function onMessageError2(f) {
        return function eff() {
            wrk.onmessageerror = function onmessageerror(e) {
                f(e.target.error)(); // FIXME
            };
        };
    };
};
