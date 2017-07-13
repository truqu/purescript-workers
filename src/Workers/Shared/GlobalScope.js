exports.name = function eff() {
    return name;
};

exports.applicationCache = function eff() {
    return applicationCache;
};

exports.onConnect = function _onConnect(f) {
    return function eff() {
        onconnect = function onconnect() {
            f();
        };
    };
};
