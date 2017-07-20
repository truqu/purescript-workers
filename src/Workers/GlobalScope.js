exports.location = function eff() {
    // NOTE A Plain JS Object is created because the WorkerLocation object
    // can't be serialized and may lead to weird behavior.
    return {
        origin: location.origin,
        protocol: location.protocol,
        host: location.host,
        hostname: location.hostname,
        port: location.port,
        pathname: location.pathname,
        search: location.search,
        hash: location.hash,
    };
};

exports.navigator = function eff() {
    // NOTE A Plain JS Object is created because the WorkerNavigator object
    // can't be serialized and may lead to weird behavior.
    return {
        appCodeName: navigator.appCodeName,
        appName: navigator.appName,
        appVersion: navigator.appVersion, // TODO
        platform: navigator.platform,
        product: navigator.product,
        productSub: navigator.productSub,
        userAgent: navigator.userAgent,
        vendor: navigator.vendor,
        vendorSub: navigator.vendorSub,
        language: navigator.language,
        languages: Array.prototype.slice.apply(navigator.languages),
        online: navigator.online,
    };
};

exports.close = function eff() {
    close();
};

exports.onError = function _onError(f) {
    return function eff() {
        onerror = function onerror(msg) {
            f(new Error(msg))();
            return true; // NOTE indicates that the error has been handled, so it isn't propagated to the parent
        };
    };
};

exports.onLanguageChange = function _onLanguageChange(f) {
    return function eff() {
        onlanguagechange = function onlanguagechange() {
            f();
        };
    };
};

exports.onOffline = function _onOffline(f) {
    return function eff() {
        onoffline = function onoffline() {
            f();
        };
    };
};

exports.onOnline = function _onOnline(f) {
    return function eff() {
        ononline = function ononline() {
            f();
        };
    };
};

exports.onRejectionHandled = function _onRejectionHandled(f) {
    return function eff() {
        onrejectionhandled = function onrejectionhandled() {
            f();
        };
    };
};

exports.onUnhandledRejection = function _onUnhandledRejection(f) {
    return function eff() {
        onrejectionunhandled = function onrejectionunhandled() {
            f();
        };
    };
};
