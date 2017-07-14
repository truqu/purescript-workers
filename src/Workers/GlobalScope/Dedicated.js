exports.name = function _name() {
    return function eff() {
        return name;
    };
};

exports._postMessage = function _postMessage(msg) {
    return function postMessage2(transfer) {
        return function eff() {
            postMessage(msg, transfer.length > 0 ? transfer : undefined);
        };
    };
};

exports.onMessage = function _onMessage(f) {
    return function eff() {
        onmessage = function onMessage(e) {
            f(e.data)();
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
