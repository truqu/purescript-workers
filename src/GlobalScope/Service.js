/* Global Scope */

exports._clients = function eff() {
    return self.clients;
};

exports._registration = function eff() {
    return self.registration;
};

exports._skipWaiting = function eff() {
    self.skipWaiting();
};

exports._onInstall = function _onInstall(f) {
    return function eff() {
        self.oninstall = function oninstall(e) {
            e.waitUntil(new Promise(function waitUntil(resolve, reject) {
                try {
                    f(resolve, reject);
                } catch (err) {
                    reject(err);
                }
            }));
        };
    };
};

exports._onActivate = function _onActivate(f) {
    return function eff() {
        self.onactivate = function onactivate(e) {
            e.waitUntil(new Promise(function waitUntil(resolve, reject) {
                try {
                    f(resolve, reject);
                } catch (err) {
                    reject(err);
                }
            }));
        };
    };
};

exports._onFetch = function _onFetch(f) {
    return function eff() {
        self.onfetch = function onfetch(e) {
            e.waitUntil(new Promise(function waitUntil(resolve, reject) {
                try {
                    f(resolve, reject);
                } catch (err) {
                    reject(err);
                }
            }));
        };
    };
};

exports._onMessage = function _onMessage(f) {
    return function eff() {
        self.onmessage = function onmessage(e) {
            e.waitUntil(new Promise(function waitUntil(resolve, reject) {
                try {
                    f(e.source.id)(e.data)(resolve, reject);
                } catch (err) {
                    reject(err);
                }
            }));
        };
    };
};

/* Clients Interface */

exports._get = function _get(clients) {
    return function _get2(id) {
        return function aff(success, error) {
            try {
                clients.get(id).then(success, error);
            } catch (err) {
                error(err);
            }
        };
    };
};

exports._matchAll = function _matchAll(clients) {
    return function _matchAll2(opts) {
        return function aff(success, error) {
            try {
                clients.matchAll(opts)
                       .then(function onSuccess(matches) {
                           success(Array.prototype.slice.apply(matches));
                       })
                       .catch(error);
            } catch (err) {
                error(err);
            }
        };
    };
};

exports._openWindow = function _openWindow(clients) {
    return function _openWindow2(url) {
        return function aff(success, error) {
            try {
                clients.openWindow(url).then(success, error);
            } catch (err) {
                error(err);
            }
        };
    };
};

exports._claim = function _claim(clients) {
    return function aff(success, error) {
        try {
            clients.claim().then(success, error);
        } catch (err) {
            error(err);
        }
    };
};

/* Client Interface */

exports._url = function _url(client) {
    return client.url;
};

exports._frameType = function _frameType(toFrameType) {
    return function _frameType2(client) {
        return toFrameType(client.frameType);
    };
};

exports._clientId = function _clientId(client) {
    return client.id;
};

/* Window Client Interface */

exports._visibilityState = function _visibilityState(toVisibilityState) {
    return function _visibilityState2(client) {
        return toVisibilityState(client.visibilityState);
    };
};

exports._focused = function _focused(client) {
    return client.focused;
};

exports._focus = function _focus(client) {
    return function aff(success, error) {
        try {
            client.focus().then(success, error);
        } catch (err) {
            error(err);
        }
    };
};

exports._navigate = function _navigate(client) {
    return function _navigate2(url) {
        return function aff(success, error) {
            client.navigate(url).then(success, error);
        };
    };
};
