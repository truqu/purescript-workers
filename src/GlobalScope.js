exports._location = function _location(toLocation) {
    return function eff() {
        // NOTE A Plain JS Object is created because the WorkerLocation object
        // can't be serialized and may lead to weird behavior.
        return toLocation({
            origin: location.origin || '',
            protocol: location.protocol || '',
            host: location.host || '',
            hostname: location.hostname || '',
            port: location.port || '',
            pathname: location.pathname || '',
            search: location.search || '',
            hash: location.hash || '',
        });
    };
};

exports._navigator = function _navigator(toNavigator) {
    return function eff() {
        // NOTE A Plain JS Object is created because the WorkerNavigator object
        // can't be serialized and may lead to weird behavior.
        return toNavigator({
            appCodeName: navigator.appCodeName || '',
            appName: navigator.appName || '',
            appVersion: navigator.appVersion || '',
            platform: navigator.platform || '',
            product: navigator.product || '',
            productSub: navigator.productSub || '',
            userAgent: navigator.userAgent || '',
            vendor: navigator.vendor || '',
            vendorSub: navigator.vendorSub || '',
            language: navigator.language || '',
            languages: Array.prototype.slice.apply(navigator.languages || []),
            onLine: navigator.onLine || false,
        });
    };
};

exports.close = function eff() {
    self.close();
};

exports.onError = function _onError(f) {
    return function eff() {
        self.onerror = function onerror(msg) {
            f(new Error(msg))();
            // NOTE indicates that the error has been handled,
            // so it isn't propagated to the parent
            return true;
        };
    };
};

exports.onLanguageChange = function _onLanguageChange(f) {
    return function eff() {
        self.onlanguagechange = function onlanguagechange() {
            f();
        };
    };
};

exports.onOffline = function _onOffline(f) {
    return function eff() {
        self.onoffline = function onoffline() {
            f();
        };
    };
};

exports.onOnline = function _onOnline(f) {
    return function eff() {
        self.ononline = function ononline() {
            f();
        };
    };
};

exports.onRejectionHandled = function _onRejectionHandled(f) {
    return function eff() {
        self.onrejectionhandled = function onrejectionhandled() {
            f();
        };
    };
};

exports.onUnhandledRejection = function _onUnhandledRejection(f) {
    return function eff() {
        self.onrejectionunhandled = function onrejectionunhandled() {
            f();
        };
    };
};
