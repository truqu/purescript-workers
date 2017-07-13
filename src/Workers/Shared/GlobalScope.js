exports.name = function name() {
    return function eff() {
        return name;
    };
};

exports.applicationCache = function applicationCache() {
    return function eff() {
        return applicationCache;
    };
};

exports.onConnect = function onConnect(f) {
    return function eff() {
        onconnect = function onconnect() {
            f();
        };
    };
};
