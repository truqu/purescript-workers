exports._new = function _new(src) {
    return function _new2(opts) {
        return function eff() {
            return new SharedWorker(src, opts);
        };
    };
};

exports._port = function _port(wrk) {
    return wrk.port;
};
