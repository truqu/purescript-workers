exports.name = function eff() {
    return self.name;
};

exports.applicationCache = function eff() {
    return self.applicationCache;
};

exports._onConnect = function _onConnect(nonEmpty) {
    return function _onConnect2(f) {
        return function eff() {
            self.onconnect = function onconnect(e) {
                const head = e.ports[0];
                const queue = Array.prototype.slice.call(e.ports, 1);
                f(nonEmpty(head)(queue))();
            };
        };
    };
};
