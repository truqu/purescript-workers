exports._onError = function _onError(wrk) {
    return function _onError2(f) {
        return function eff() {
            wrk.onerror = function onerror(e) {
                f(e.target.error);
            };
        };
    };
};
