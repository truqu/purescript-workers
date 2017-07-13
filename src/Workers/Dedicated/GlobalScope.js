exports.name = function name() {
    return function eff() {
        return name;
    };
};

exports._postMessage = function postMessage(msg) {
    return function postMessage2(transfer) {
        return function eff() {
            postMessage(msg, transfer.length > 0 ? transfer : undefined);
        };
    };
};

exports.onMessage = function _onMessage(f) {
    return function eff() {
        onmessage = function onMessage(e) {
            f(e.target);
        };
    };
};


exports.onMessageError = function _onMessageError(f) {
    return function eff() {
        onmessageerror = function onMessageError(e) {
            f(e.target.error);
        };
    };
};
