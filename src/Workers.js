exports._onError = function _onError(wrk) {
    return function _onError2(f) {
        return function eff() {
            wrk.onerror = function onerror(err) {
                f(err)();
            };
        };
    };
};

exports._newSharedWorker = function _newSharedWorker(src) {
    return function _newSharedWorker2(opts) {
        return function eff() {
            return new SharedWorker(src, opts);
        };
    };
};

exports._newDedicatedWorker = function _newDedicatedWorker(src) {
    return function _newDedicatedWorker2(opts) {
        return function eff() {
            return new Worker(src, opts);
        };
    };
};
