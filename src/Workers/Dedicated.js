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
