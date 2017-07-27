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

exports._postMessage = function postMessage(port) {
    return function postMessage2(msg) {
        return function postMessage3(transfer) {
            return function eff() {
                port.postMessage(msg, transfer.length > 0 ? transfer : undefined);
            };
        };
    };
};

exports._onMessage = function _onMessage(constructor) {
    return function onMessage2(port) {
        return function onMessage3(f) {
            return function eff() {
                switch (constructor) {
                case 'Service':
                    navigator.serviceWorker.onmessage = function onMessage(e) {
                        f(e.data)();
                    };
                    break;
                default:
                    port.onmessage = function onMessage(e) {
                        f(e.data)();
                    };
                }
            };
        };
    };
};

exports._onMessageError = function _onMessageError(constructor) {
    return function _onMessageError2(port) {
        return function onMessageError3(f) {
            return function eff() {
                switch (constructor) {
                case 'Service':
                    // Nothing
                    break;
                default:
                    port.onmessageerror = function onMessageError(e) {
                        f(e.target.error)(); // FIXME
                    };
                }
            };
        };
    };
};
