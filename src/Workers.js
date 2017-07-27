exports._onError = function _onError(wrk) {
    return function _onError2(f) {
        return function eff() {
            wrk.onerror = function onerror(err) {
                f(err)();
            };
        };
    };
};
