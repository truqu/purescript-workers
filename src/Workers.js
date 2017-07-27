exports._onError = function _onError(wrk) {
    return function _onError2(f) {
        return function eff() {
            wrk.onerror = function onerror(err) {
                f(err)();
            };
        };
    };
};

exports._postMessage = function postMessage(channel) {
    return function postMessage2(msg) {
        return function postMessage3(transfer) {
            return function eff() {
                channel.postMessage(msg, transfer.length > 0 ? transfer : undefined);
            };
        };
    };
};
