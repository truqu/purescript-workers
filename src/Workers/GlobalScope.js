exports.location = function location() {
    return function eff() {
        return location;
    };
};

exports.navigator = function navigator() {
    return function eff() {
        return navigator;
    };
};

exports.close = function close() {
    return function eff() {
        close();
    };
};

exports.onError = function onError(f) {
    return function eff() {
        onerror = function onerror(e) {
            f(e.target.error);
        };
    };
};

exports.onLanguageChange = function onLanguageChange(f) {
    return function eff() {
        onlanguagechange = function onlanguagechange() {
            f();
        };
    };
};

exports.onOffline = function onOffline(f) {
    return function eff() {
        onoffline = function onoffline() {
            f();
        };
    };
};

exports.onOnline = function onOnline(f) {
    return function eff() {
        ononline = function ononline() {
            f();
        };
    };
};

exports.onRejectionHandled = function onRejectionHandled(f) {
    return function eff() {
        onrejectionhandled = function onrejectionhandled() {
            f();
        };
    };
};

exports.onUnhandledRejection = function onUnhandledRejection(f) {
    return function eff() {
        onrejectionunhandled = function onrejectionunhandled() {
            f();
        };
    };
};
