/* Fetch */

exports._fetch = function _fetch(req) {
    return function aff(success, error) {
        try {
            fetch(req).then(success, error);
        } catch (err) {
            error(err);
        }
    };
};


/* Clone */

exports._clone = function _clone(obj) {
    return function eff() {
        return obj.clone();
    };
};


/* Hasbody */

exports._text = function _text(body) {
    return function aff(success, error) {
        try {
            body.text().then(success, error);
        } catch (err) {
            error(err);
        }
    };
};


exports._json = function _json(body) {
    return function aff(success, error) {
        try {
            body.json().then(success, error);
        } catch (err) {
            error(err);
        }
    };
};


/* Request */

exports._new = function _new(url) {
    return new Request(url);
};

exports._newPrime = function _newPrime(url, init) {
    return new Request(url, init);
};

exports._requestCache = function _requestCache(constructor) {
    return function _requestCache2(req) {
        return constructor(req.cache);
    };
};

exports._requestCredentials = function _requestCredentials(constructor) {
    return function _requestCredentials2(req) {
        return constructor(req.credentials);
    };
};

exports._requestDestination = function _requestDestination(constructor) {
    return function _requestDestination2(req) {
        return constructor(req.destination);
    };
};

exports._requestHeaders = function _requestHeaders(Header) {
    return function _requestHeaders2(constructor) {
        return function _requestHeaders3(req) {
            var headers = [];
            var gen = req.headers.entries();
            var entry = gen.next();
            while (!entry.done) {
                headers.push(constructor(Header(entry.value[0]))(entry.value[1]));
                entry = gen.next();
            }

            return headers;
        };
    };
};

exports._requestIntegrity = function _requestIntegrity(req) {
    return req.integrity;
};

exports._requestKeepAlive = function _requestKeepAlive(req) {
    return req.keepalive;
};

exports._requestMethod = function _requestMethod(constructor) {
    return function _requestMethod2(req) {
        return constructor(req.method);
    };
};

exports._requestMode = function _requestMode(constructor) {
    return function _requestMode2(req) {
        return constructor(req.mode);
    };
};

exports._requestRedirect = function _requestRedirect(constructor) {
    return function _requestRedirect2(req) {
        return constructor(req.redirect);
    };
};

exports._requestReferrer = function _requestReferrer(req) {
    return req.referrer;
};

exports._requestReferrerPolicy = function _requestReferrerPolicy(constructor) {
    return function _requestReferrerPolicy2(req) {
        return constructor(req.referrerPolicy);
    };
};

exports._requestURL = function _requestURL(req) {
    return req.url;
};

exports._requestType = function _requestType(constructor) {
    return function _requestType2(req) {
        return constructor(req.type);
    };
};


/* Response */

exports._responseError = function _responseError(res) {
    return res.error();
};

exports._responseHeaders = function _responseHeaders(Header) {
    return function _responseHeaders2(constructor) {
        return function _responseHeaders3(res) {
            var headers = [];
            var gen = res.headers.entries();
            var entry = gen.next();
            while (!entry.done) {
                headers.push(constructor(Header(entry.value[0]))(entry.value[1]));
                entry = gen.next();
            }

            return headers;
        };
    };
};

exports._responseOk = function _responseOk(res) {
    return res.ok;
};

exports._responseRedirect = function _responseRedirect(res) {
    return function _responseRedirect2(url) {
        return function _responseRedirect3(statusCode) {
            return res.redirect(url, statusCode || undefined);
        };
    };
};

exports._responseRedirected = function _responseRedirected(res) {
    return res.redirected;
};

exports._responseStatus = function _responseStatus(constructor) {
    return function _responseStatus2(res) {
        return constructor(res.status);
    };
};

exports._responseStatusCode = function _responseStatusCode(res) {
    return res.status;
};

exports._responseType = function _responseType(constructor) {
    return function _responseType2(res) {
        return constructor(res.type);
    };
};

exports._responseURL = function _responseURL(res) {
    return res.url;
};
