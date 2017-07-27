exports._close = function _close(port) {
    return function eff() {
        port.close();
    };
};

exports._start = function _start(port) {
    return function eff() {
        port.start();
    };
};

exports._onMessage = function _onMessage(port) {
    return function onMessage2(f) {
        return function eff() {
            port.onmessage = function onmessage(e) {
                f(e.data)();
            };
        };
    };
};

exports._onMessageError = function _onMessageError(port) {
    return function onMessageError2(f) {
        return function eff() {
            port.onmessageerror = function onmessageerror(e) {
                f(e.target.error)(); // FIXME
            };
        };
    };
};
