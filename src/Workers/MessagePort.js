exports.close = function close(port) {
    return function eff() {
        port.close();
    };
};

exports.start = function start(port) {
    return function eff() {
        port.start();
    };
};

exports._postMessage = function postMessage(port) {
    return function postMessage2(msg) {
        return function postMessage3(transfer) {
            return function eff() {
                port.postMessage(msg, transfer.length > 0 ? transfer : undefined);
            };
        };
    };
};

exports._onMessage = function _onMessage(port) {
    return function onMessage2(f) {
        return function eff() {
            port.onmessage = function onMessage(e) {
                f(e.data)();
            };
        };
    };
};


exports._onMessageError = function _onMessageError(port) {
    return function onMessageError2(f) {
        return function eff() {
            port.onmessageerror = function onMessageError(e) {
                f(e.target.error)();
            };
        };
    };
};
