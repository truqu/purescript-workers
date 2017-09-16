PureScript Web Workers [![](https://img.shields.io/badge/doc-pursuit-60b5cc.svg)](http://pursuit.purescript.org/packages/purescript-workers) 
=====

This package offers bindings of the Web Workers (Dedicated, Shared & Service) APIs.

> **DISCLAIMER** This package is still highly experimental. Do not hesitate to fill in an issue
> if you encounter any trouble. Any feedback is welcome!

## Overview 

TODO

## How To: Run Examples

The [examples](https://github.com/truqu/purescript-workers/tree/master/examples) contains few
examples of the [Service Worker Cookbook](https://serviceworke.rs/) translated to PureScript.
This is still work-in-progress and still relies on the [sources provided by
Mozilla](https://github.com/truqu/purescript-workers/tree/master/examples) included as a
submodule.

Therefore,

> *commands are written as if you were running them from the root of the repository*

1. Make sure the submodule is installed

```
git submodule init
git submodule update
```

2. Install dependencies of the Service Worker Cookbook

```
cd examples/serviceworker-cookbook
npm i
```

3. Install dependencies of an example

```
cd examples/cache-and-update
npm i
```

4. Compile the example's PureScript sources

```
cd examples/cache-and-update
npm run build
```

5. Start the Service Worker Cookbook server 

```
cd examples/serviceworker-cookbook
gulp start-server
```

> If the server doesn't start because you don't have any GCM API Key, you can simply remove all the `push-*` examples from there and try again.

6. Visit your localhost on port 3003


```
firefox http://localhost:3003/strategy-cache-and-update_demo.html
```


## Changelog

### Roadmap

- Re-write in PureScript examples from the [Service Worker Cookbook](https://github.com/mozilla/serviceworker-cookbook)

- Write complete example & PoC of ServiceWorkers based on [Web Fundamentals - PWA Weather](https://github.com/ArturKlajnerok/pwa-weather)

- Document undocumented functions and module

### v2.1.0

- Implement Fetch, Request & Response API

- Basic example for service workers from mozilla/serviceworkers-cookbook

### v2.0.0

- Internal implementation rework

- Supports for Service Workers

- Supports for Cache & CacheStorage

#### v1.0.0

- Supports for the Dedicated Workers 
- Supports for the Shared Workers
- Supports for the Application Cache

## Documentation

Module documentation is [published on Pursuit](http://pursuit.purescript.org/packages/purescript-workers).

Some additionals links:

- [Web Workers API specifications](https://w3c.github.io/workers)
- [Service Workers API specifications](https://www.w3.org/TR/service-workers-1)
- [Fetch specifications](https://fetch.spec.whatwg.org)
- [Service Workers examples](https://serviceworke.rs/)
- [W3C Platform Tests](https://github.com/w3c/web-platform-tests)
