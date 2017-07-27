exports._controller = function _controller() {
    return function eff() {
        return navigator.serviceWorker.controller;
    };
};

exports._getRegistration = function _getRegistration(url) {
    return function aff(success, error) {
        try {
            navigator.serviceWorker
                     .getRegistration(url || '')
                     .then(success, error);
        } catch (err) {
            error(err);
        }
    };
};

exports._ready = function _ready() {
    return function aff(success, error) {
        try {
            navigator.serviceWorker
                     .ready
                     .then(success, error);
        } catch (err) {
            error(err);
        }
    };
};

exports._register = function _register(url) {
    return function _register2(opts) {
        return function aff(success, error) {
            try {
                navigator.serviceWorker
                         .register(url, opts)
                         .then(success, error);
            } catch (err) {
                error(err);
            }
        };
    };
};
