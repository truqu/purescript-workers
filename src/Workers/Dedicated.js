exports._terminate = function _terminate(wrk) {
    return function eff() {
        wrk.terminate();
    };
};
