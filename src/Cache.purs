module Cache
  -- * Types
  ( CACHE
  , Cache
  , CacheStorage
  , CacheQueryOptions
  , defaultCacheQueryOptions

  -- * Cache Storage Manipulations
  , deleteCache
  , hasCache
  , keysCache
  , openCache

  -- * Cache Manipulations
  , add
  , addAll
  , delete
  , delete'
  , keys
  , keys'
  , match
  , match'
  , matchAll
  , matchAll'
  , put
  ) where

import Prelude

import Control.Monad.Aff (Aff)
import Control.Monad.Eff (kind Effect)
import Data.Maybe        (Maybe(..))
import Data.Nullable     (Nullable, toNullable)

import Fetch             (Response, RequestInfo)


--------------------
-- TYPES
--------------------

foreign import data CACHE :: Effect


foreign import data Cache :: Type


foreign import data CacheStorage :: Type



type CacheQueryOptions =
  { ignoreSearch :: Boolean
  , ignoreMethod :: Boolean
  , ignoreVary   :: Boolean
  }


defaultCacheQueryOptions :: CacheQueryOptions
defaultCacheQueryOptions =
  { ignoreSearch : false
  , ignoreMethod : false
  , ignoreVary   : false
  }


--------------------
-- METHODS
--------------------

-- Cache Storage

deleteCache
  :: forall e
  .  CacheStorage
  -> String
  -> Aff (cache :: CACHE | e) Boolean
deleteCache =
  _deleteCache


hasCache
  :: forall e
  .  CacheStorage
  -> String
  -> Aff (cache :: CACHE | e) Boolean
hasCache =
  _hasCache


keysCache
  :: forall e
  .  CacheStorage
  -> Aff (cache :: CACHE | e) (Array String)
keysCache =
  _keysCache


openCache
  :: forall e
  .  CacheStorage
  -> String
  -> Aff (cache :: CACHE | e) Cache
openCache =
  _openCache

-- Cache

add
  :: forall e
  .  Cache
  -> RequestInfo
  -> Aff (cache :: CACHE | e) Unit
add =
  _add


addAll
  :: forall e
  .  Cache
  -> Array RequestInfo
  -> Aff (cache :: CACHE | e) Unit
addAll =
  _addAll


delete
  :: forall e
  .  Cache
  -> RequestInfo
  -> Aff (cache :: CACHE | e) Boolean
delete cache req =
  _delete cache req defaultCacheQueryOptions


delete'
  :: forall e
  .  Cache
  -> RequestInfo
  -> CacheQueryOptions
  -> Aff (cache :: CACHE | e) Boolean
delete' =
  _delete


keys
  :: forall e
  .  Cache
  -> Aff (cache :: CACHE | e) (Array RequestInfo)
keys cache =
  _keys cache (toNullable Nothing) defaultCacheQueryOptions


keys'
  :: forall e
  .  Cache
  -> Maybe RequestInfo
  -> CacheQueryOptions
  -> Aff (cache :: CACHE | e) (Array RequestInfo)
keys' cache req opts =
  _keys cache (toNullable req) opts


match
  :: forall e
  .  Cache
  -> RequestInfo
  -> Aff (cache :: CACHE | e) Response
match cache req =
  _match cache req defaultCacheQueryOptions


match'
  :: forall e
  .  Cache
  -> RequestInfo
  -> CacheQueryOptions
  -> Aff (cache :: CACHE | e) Response
match' =
  _match


matchAll
  :: forall e
  .  Cache
  -> Aff (cache :: CACHE | e) (Array Response)
matchAll cache =
  _matchAll cache (toNullable Nothing) defaultCacheQueryOptions


matchAll'
  :: forall e
  .  Cache
  -> Maybe RequestInfo
  -> CacheQueryOptions
  -> Aff (cache :: CACHE | e) (Array Response)
matchAll' cache req opts =
  _matchAll cache (toNullable req) opts


put
  :: forall e
  .  Cache
  -> RequestInfo
  -> Response
  -> Aff (cache :: CACHE | e) Unit
put =
  _put


--------------------
-- FFI
--------------------

-- Cache Storage

foreign import _deleteCache
  :: forall e
  .  CacheStorage
  -> String
  -> Aff (cache :: CACHE | e) Boolean


foreign import _hasCache
  :: forall e
  .  CacheStorage
  -> String
  -> Aff (cache :: CACHE | e) Boolean


foreign import _keysCache
  :: forall e
  .  CacheStorage
  -> Aff (cache :: CACHE | e) (Array String)


foreign import _openCache
  :: forall e
  .  CacheStorage
  -> String
  -> Aff (cache :: CACHE | e) Cache


-- Cache

foreign import _add
  :: forall e
  .  Cache
  -> String
  -> Aff (cache :: CACHE | e) Unit


foreign import _addAll
  :: forall e
  .  Cache
  -> Array String
  -> Aff (cache :: CACHE | e) Unit


foreign import _delete
  :: forall e
  .  Cache
  -> String
  -> CacheQueryOptions
  -> Aff (cache :: CACHE | e) Boolean


foreign import _keys
  :: forall e
  .  Cache
  -> Nullable String
  -> CacheQueryOptions
  -> Aff (cache :: CACHE | e) (Array String)


foreign import _match
  :: forall e
  .  Cache
  -> String
  -> CacheQueryOptions
  -> Aff (cache :: CACHE | e) Response


foreign import _matchAll
  :: forall e
  .  Cache
  -> Nullable String
  -> CacheQueryOptions
  -> Aff (cache :: CACHE | e) (Array Response)


foreign import _put
  :: forall e
  .  Cache
  -> String
  -> Response
  -> Aff (cache :: CACHE | e) Unit
