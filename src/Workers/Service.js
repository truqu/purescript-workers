/* SERVICE WORKER CONTAINER */

exports._controller = function eff() {
    return navigator.serviceWorker.controller;
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

exports._onControllerChange = function _onControllerChange(f) {
    return function eff() {
        navigator.serviceWorker.oncontrollerchange = function oncontrollerchange() {
            f();
        };
    };
};

exports._onMessage = function _onMessage(f) {
    return function eff() {
        navigator.serviceWorker.onmessage = function onmessage(e) {
            f(e.data)();
        };
    };
};


exports._ready = function aff(success, error) {
    try {
        navigator.serviceWorker
                 .ready
                 .then(success, error);
    } catch (err) {
        error(err);
    }
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

exports._startMessages = function eff() {
    navigator.serviceWorker
             .startMessages();
};

/* SERVICE WORKER */

exports._onStateChange = function _onStateChange(toState) {
    return function _onStateChange2(service) {
        return function _onStateChange3(f) {
            return function eff() {
                service.onstatechange = function onstatechange(e) {
                    f(toState(e.source.state))();
                };
            };
        };
    };
};

exports._scriptURL = function _scriptURL(service) {
    return service.scriptURL;
};

exports._state = function _state(toState) {
    return function _state2(service) {
        return toState(service.state);
    };
};

/* SERVICE WORKER REGISTRATION */

exports._active = function _active(registration) {
    return registration.active;
};

exports._installing = function _installing(registration) {
    return registration.installing;
};

exports._waiting = function _waiting(registration) {
    return registration.waiting;
};

exports._scope = function _scope(registration) {
    return registration.scope;
};

exports._update = function _update(registration) {
    return function aff(success, error) {
        try {
            registration.update().then(success, error);
        } catch (err) {
            error(err);
        }
    };
};

exports._unregister = function _unregister(registration) {
    return function aff(success, error) {
        try {
            registration.update().then(success, error);
        } catch (err) {
            error(err);
        }
    };
};

exports._onUpdateFound = function _onUpdateFound(registration) {
    return function _onUpdateFound2(f) {
        return function eff() {
            registration.onupdatefound = function onupdatefound() {
                f();
            };
        };
    };
};
