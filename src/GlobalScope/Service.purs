module GlobalScope.Service
  -- * Global Scope
  ( caches
  , clients
  , registration
  , skipWaiting
  , onInstall
  , onActivate
  , onFetch
  , onMessage

  -- * Clients Interface
  , Clients
  , ClientQueryOptions
  , get
  , matchAll
  , matchAll'
  , openWindow
  , claim


  -- * Client Interface
  , Client
  , ClientId
  , ClientType(..)
  , url
  , frameType
  , clientId


  -- * Window Client Interface
  , WindowClient
  , FrameType(..)
  , VisibilityState(..)
  , visibilityState
  , focused
  , focus
  , navigate
  ) where


import Prelude

import Control.Monad.Aff (Aff)
import Control.Monad.Eff (Eff)
import Data.Maybe        (Maybe(..))
import Data.Nullable     (Nullable, toMaybe, toNullable)
import Data.String.Read  (class Read, read)

import Workers.Service   (WORKER, Registration)
import Workers.Class     (class Channel)
import Cache             (CacheStorage)
import Fetch             (Request, Response)


--------------------
-- TYPES
--------------------


foreign import data Clients :: Type


foreign import data Client :: Type


foreign import data WindowClient :: Type


type ClientId = String


type ClientQueryOptions =
  { includeUncontrolled :: Boolean
  , clientType :: ClientType
  }


data ClientType
  = Window
  | Worker
  | SharedWorker
  | All


data FrameType
  = Auxiliary
  | TopLevel
  | Nested
  | None


data VisibilityState
  = Hidden
  | Visible
  | PreRender
  | Unloaded


--------------------
-- METHODS
--------------------

-- Global Scope

caches
  :: forall e
  .  Eff (worker :: WORKER | e) CacheStorage
caches =
  _caches


clients
  :: forall e
  .  Eff (worker :: WORKER | e) Clients
clients =
  _clients


registration
  :: forall e
  .  Eff (worker :: WORKER | e) Registration
registration =
  _registration


skipWaiting
  :: forall e
  .  Eff (worker :: WORKER | e) Unit
skipWaiting =
  _skipWaiting


onInstall
  :: forall e e'
  .  Aff ( | e') Unit
  -> Eff (worker :: WORKER | e) Unit
onInstall =
  _onInstall


onActivate
  :: forall e e'
  .  Aff ( | e') Unit
  -> Eff (worker :: WORKER | e) Unit
onActivate =
  _onActivate


onFetch
  :: forall e e' e''
  .  (Request -> Aff ( | e') (Maybe Response))
  -> (Request -> Aff ( | e'') Unit)
  -> Eff (worker :: WORKER | e) Unit
onFetch f =
  _onFetch toNullable f


onMessage
  :: forall e e' msg
  .  (ClientId -> msg -> Aff ( | e') Unit)
  -> Eff (worker :: WORKER | e) Unit
onMessage =
  _onMessage

-- Clients Interface

get
  :: forall e
  .  Clients
  -> ClientId
  -> Aff (worker :: WORKER | e) (Maybe Client)
get cls cid =
  toMaybe <$> _get cls cid


matchAll
  :: forall e
  .  Clients
  -> Aff (worker :: WORKER | e) (Array Client)
matchAll cls =
  _matchAll cls { includeUncontrolled: false, clientType: Window }


matchAll'
  :: forall e
  .  Clients
  -> ClientQueryOptions
  -> Aff (worker :: WORKER | e) (Array Client)
matchAll' =
  _matchAll


openWindow
  :: forall e
  .  Clients
  -> String
  -> Aff (worker :: WORKER | e) WindowClient
openWindow =
  _openWindow


claim
  :: forall e
  .  Clients
  -> Aff (worker :: WORKER | e) Unit
claim =
  _claim

-- Client Interface

url
  :: Client
  -> String
url =
  _url


frameType
  :: Client
  -> FrameType
frameType =
  _frameType (read >>> toNullable)


clientId
  :: Client
  -> ClientId
clientId =
  _clientId

-- Window Client Interface

visibilityState
  :: WindowClient
  -> VisibilityState
visibilityState =
  _visibilityState (read >>> toNullable)


focused
  :: WindowClient
  -> Boolean
focused =
  _focused


focus
  :: forall e
  .  WindowClient
  -> Aff (worker :: WORKER | e) WindowClient
focus =
  _focus


navigate
  :: forall e
  .  WindowClient
  -> String
  -> Aff (worker :: WORKER | e) WindowClient
navigate =
  _navigate


--------------------
-- INSTANCES
--------------------


instance channelClient :: Channel Client where


instance showClientType :: Show ClientType where
  show x =
    case x of
      Window       -> "window"
      Worker       -> "worker"
      SharedWorker -> "sharedworker"
      All          -> "all"


instance showFrameType :: Show FrameType where
  show x =
    case x of
      Auxiliary -> "auxiliary"
      TopLevel  -> "top-level"
      Nested    -> "nested"
      None      -> "none"


instance showVisibilityState :: Show VisibilityState where
  show x =
    case x of
      Hidden    -> "hidden"
      Visible   -> "visible"
      PreRender -> "prerender"
      Unloaded  -> "unloaded"


instance readClientType :: Read ClientType where
  read s =
    case s of
      "window"       -> pure Window
      "worker"       -> pure Worker
      "sharedworker" -> pure SharedWorker
      "all"          -> pure All
      _              -> Nothing


instance readFrameType :: Read FrameType where
  read s =
    case s of
      "auxiliary" -> pure Auxiliary
      "top-level" -> pure TopLevel
      "nested"    -> pure Nested
      "none"      -> pure None
      _           -> Nothing


instance readVisibilityState :: Read VisibilityState where
  read s =
    case s of
      "hidden"    -> pure Hidden
      "visible"   -> pure Visible
      "prerender" -> pure PreRender
      "unloaded"  -> pure Unloaded
      _           -> Nothing


--------------------
-- FFI
--------------------

-- Global Scope

foreign import _caches
  :: forall e
  .  Eff (worker :: WORKER | e) CacheStorage


foreign import _clients
  :: forall e
  .  Eff (worker :: WORKER | e) Clients


foreign import _registration
  :: forall e
  .  Eff (worker :: WORKER | e) Registration


foreign import _skipWaiting
  :: forall e
  .  Eff (worker :: WORKER | e) Unit


foreign import _onInstall
  :: forall e e'
  .  Aff ( | e') Unit
  -> Eff (worker :: WORKER | e) Unit


foreign import _onActivate
  :: forall e e'
  .  Aff ( | e') Unit
  -> Eff (worker :: WORKER | e) Unit


foreign import _onFetch
  :: forall a e e' e''
  .  (Maybe a -> Nullable a)
  -> (Request -> Aff ( | e') (Maybe Response))
  -> (Request -> Aff ( | e'') Unit)
  -> Eff (worker :: WORKER | e) Unit


foreign import _onMessage
  :: forall e e' msg
  .  (ClientId -> msg -> Aff ( | e') Unit)
  -> Eff (worker :: WORKER | e) Unit

-- Clients Interface

foreign import _get
  :: forall e
  .  Clients
  -> ClientId
  -> Aff (worker :: WORKER | e) (Nullable Client)


foreign import _matchAll
  :: forall e
  .  Clients
  -> ClientQueryOptions
  -> Aff (worker :: WORKER | e) (Array Client)


foreign import _openWindow
  :: forall e
  .  Clients
  -> String
  -> Aff (worker :: WORKER | e) WindowClient


foreign import _claim
  :: forall e
  .  Clients
  -> Aff (worker :: WORKER | e) Unit

-- Client Interface

foreign import _url
  :: Client
  -> String


-- NOTE The null case is "unsafely" ignored
foreign import _frameType
  :: (String -> Nullable FrameType)
  -> Client
  -> FrameType


foreign import _clientId
  :: Client
  -> ClientId

-- Window Client Interface

-- NOTE The null case is "unsafely" ignored
foreign import _visibilityState
  :: (String -> Nullable VisibilityState)
  -> WindowClient
  -> VisibilityState


foreign import _focused
  :: WindowClient
  -> Boolean


foreign import _focus
  :: forall e
  .  WindowClient
  -> Aff (worker :: WORKER | e) WindowClient


foreign import _navigate
  :: forall e
  .  WindowClient
  -> String
  -> Aff (worker :: WORKER | e) WindowClient
