module Main where

import Prelude

import Control.Monad.Aff         (Aff)
import Control.Monad.Aff.Console (CONSOLE, log)
import Control.Monad.Eff         (Eff)
import Control.Monad.Eff.Class   (liftEff)
import Data.Maybe                (Maybe)

import Cache                      as Cache
import Cache                     (CACHE)
import Fetch                     (FETCH, Request, Response, fetch, requestURL)
import GlobalScope.Service       (onInstall, onFetch, caches)
import Workers                   (WORKER)


main
  :: forall e
  .  Eff (worker :: WORKER | e) Unit
main =
  preCache *> fromCache


-- Our cache name in the cache storage
cacheName :: String
cacheName =
  "cache-and-update"


-- Register an event listener for the `install` event
--
-- This is called once at the beginning when the cache first get initialized
preCache
  :: forall e
  .  Eff (worker :: WORKER | e) Unit
preCache = onInstall $ do
  log "The service worker is being installed"
  storage <- liftEff caches
  cache   <- Cache.openCache storage cacheName
  Cache.addAll cache
    [ "./controlled.html"
    , "./asset"
    ]


-- Register an event listener for the `fetch` event
--
-- There are 2 phases here:
--
-- - first, we immediately handle the response to the request
-- - secondly, we update the cache in background with the actual response
fromCache
  :: forall e
  .  Eff (worker :: WORKER | e) Unit
fromCache = onFetch respondWith waitUntil
  where
    respondWith
      :: forall e'
      .  Request
      -> Aff (worker :: WORKER, cache :: CACHE, console :: CONSOLE | e') (Maybe Response)
    respondWith req = do
      log "The service worker is serving the asset."
      storage <- liftEff caches
      cache   <- Cache.openCache storage cacheName
      Cache.match cache (requestURL req)

    waitUntil
      :: forall e''
      .  Request
      -> Aff (worker :: WORKER, fetch :: FETCH, cache :: CACHE | e'') Unit
    waitUntil req = do
      storage <- liftEff caches
      cache   <- Cache.openCache storage cacheName
      res     <- fetch req
      Cache.put cache (requestURL req) res
