/* Cache Storage */

exports._deleteCache = function _deleteCache(cacheStorage) {
    return function _deleteCache2(cacheName) {
        return function aff(success, error) {
            try {
                cacheStorage.delete(cacheName).then(success, error);
            } catch (err) {
                error(err);
            }
        };
    };
};

exports._hasCache = function _hasCache(cacheStorage) {
    return function _hasCache2(cacheName) {
        return function aff(success, error) {
            try {
                cacheStorage.has(cacheName).then(success, error);
            } catch (err) {
                error(err);
            }
        };
    };
};

exports._openCache = function _openCache(cacheStorage) {
    return function _openCache2(cacheName) {
        return function aff(success, error) {
            try {
                cacheStorage.open(cacheName).then(success, error);
            } catch (err) {
                error(err);
            }
        };
    };
};

exports._keysCache = function _keysCache(cacheStorage) {
    return function aff(success, error) {
        try {
            cacheStorage.keys()
                        .then(function onSuccess(xs) {
                            return Array.prototype.slice.apply(xs);
                        })
                        .then(success, error);
        } catch (err) {
            error(err);
        }
    };
};

/* Cache */

exports._add = function _add(cache) {
    return function _add2(req) {
        return function aff(success, error) {
            try {
                cache.add(req).then(success, error);
            } catch (err) {
                error(err);
            }
        };
    };
};

exports._addAll = function _addAll(cache) {
    return function _addAll2(xs) {
        return function aff(success, error) {
            try {
                cache.addAll(xs).then(success, error);
            } catch (err) {
                error(err);
            }
        };
    };
};

exports._delete = function _delete(cache) {
    return function _delete2(req) {
        return function _delete3(opts) {
            return function aff(success, error) {
                try {
                    cache.delete(req, opts).then(success, error);
                } catch (err) {
                    error(err);
                }
            };
        };
    };
};

exports._keys = function _keys(cache) {
    return function _keys2(req) {
        return function _keys3(opts) {
            return function aff(success, error) {
                try {
                    cache.keys(req, opts)
                         .then(function onSuccess(xs) {
                             return Array.prototype.slice.apply(xs);
                         })
                         .then(success, error);
                } catch (err) {
                    error(err);
                }
            };
        };
    };
};

exports._match = function _match(cache) {
    return function _match2(req) {
        return function _match3(opts) {
            return function aff(success, error) {
                try {
                    cache.match(req, opts).then(success, error);
                } catch (err) {
                    error(err);
                }
            };
        };
    };
};

exports._matchAll = function _matchAll(cache) {
    return function _matchAll2(xs) {
        return function _matchAll3(opts) {
            return function aff(success, error) {
                try {
                    cache.matchAll(xs, opts)
                         .then(function onSuccess(xs_) {
                             return Array.prototype.slice.apply(xs_);
                         })
                         .then(success, error);
                } catch (err) {
                    error(err);
                }
            };
        };
    };
};

exports._put = function _put(cache) {
    return function _put2(req) {
        return function _put3(res) {
            return function aff(success, error) {
                try {
                    cache.put(req, res).then(success, error);
                } catch (err) {
                    error(err);
                }
            };
        };
    };
};
