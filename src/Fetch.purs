module Fetch where

import Prelude

import Control.Monad.Aff           (Aff)
import Control.Monad.Eff           (kind Effect, Eff)
import Control.Monad.Eff.Exception (EXCEPTION, Error)
import Data.Maybe                  (Maybe(..))
import Data.Either                 (Either(..))
import Data.Nullable               (Nullable, toNullable)
import Network.HTTP                (Verb, Header)
import Data.Argonaut.Core          (Json)


--------------------
-- TYPES
--------------------

foreign import data FETCH :: Effect


foreign import data Response :: Type


foreign import data Request :: Type


class IsRequest req where
  toRequest :: req -> Request


class HasBody body where
  json :: body -> Either Error Json
  text :: body -> String


class Clone a where
  clone :: a -> a


type RequestInfo = String


type RequestInit =
  { method             :: Verb
  , headers            :: Array Header
  , body               :: Maybe String
  , referrer           :: Maybe String
  , referrerPolicy     :: Maybe ReferrerPolicy
  , requestMode        :: RequestMode
  , requestCredentials :: Maybe RequestCredentials
  , requestCache       :: RequestCache
  , requestRedirect    :: Maybe RequestRedirect
  , integrity          :: Maybe String
  , keepalive          :: Boolean
  }


data RequestType
  = UnknownType
  | Audio
  | Font
  | Image
  | Script
  | Style
  | Track
  | Video


data RequestDestination
  = UnknownDestination
  | Type RequestType
  | Document
  | Embed
  | Manifest
  | Object
  | Report
  | ServiceWorker
  | SharedWorker
  | DedicatedWorker
  | XSLT


data RequestRedirect
  = Follow
  | Error
  | Manual


data RequestCache
  = Default
  | NoStore
  | Reload
  | NoCache
  | ForceCache
  | OnlyIfCached


data RequestCredentials
  = Omit
  | SameOriginCredentials
  | Include


data RequestMode
  = Navigate
  | SameOrigin
  | NoCors
  | Cors


data ReferrerPolicy
  = NoReferrer
  | NoReferrerWhenDowngrade
  | SameOriginPolicy
  | Origin
  | StrictOrigin
  | OriginWhenCrossOrigin
  | StrictOriginWhenCrossOrigin
  | UnsafeURL


--------------------
-- METHODS
--------------------

new
  :: String
  -> Request
new url =
  _new url


new'
  :: String
  -> RequestInit
  -> Eff (exception :: EXCEPTION) Request
new' url opts =
  _new' url opts


fetch
  :: forall e req. (IsRequest req)
  => req
  -> Aff (fetch :: FETCH | e) Response
fetch =
  _fetch

--------------------
-- INSTANCES
--------------------

instance isRequestRequest :: IsRequest Request where
  toRequest =
    id


instance isRequestString :: IsRequest String where
  toRequest =
    new


instance showRequestType :: Show RequestType where
  show reqType =
    case reqType of
      UnknownType -> ""
      Audio       -> "audio"
      Font        -> "font"
      Image       -> "image"
      Script      -> "script"
      Style       -> "style"
      Track       -> "track"
      Video       -> "video"


instance showRequestDestination :: Show RequestDestination where
  show reqDestination =
    case reqDestination of
      UnknownDestination -> ""
      Type t             -> show t
      Document           -> "document"
      Embed              -> "embed"
      Manifest           -> "manifest"
      Object             -> "object"
      Report             -> "report"
      ServiceWorker      -> "serviceworker"
      SharedWorker       -> "sharedworker"
      DedicatedWorker    -> "worker"
      XSLT               -> "xslt"


instance showRequestRedirect :: Show RequestRedirect where
  show reqRedirect =
    case reqRedirect of
      Follow -> "follow"
      Error  -> "error"
      Manual -> "manual"


instance showRequestCache :: Show RequestCache where
  show reqCache =
    case reqCache of
      Default      -> "default"
      NoStore      -> "no-store"
      Reload       -> "reload"
      NoCache      -> "no-cache"
      ForceCache   -> "force-cache"
      OnlyIfCached -> "only-if-cached"


instance showRequestCredentials :: Show RequestCredentials where
  show reqCredentials =
    case reqCredentials of
      Omit                  -> "omit"
      SameOriginCredentials -> "same-origin"
      Include               -> "include"


instance showRequestMode :: Show RequestMode where
  show reqMode =
    case reqMode of
      Navigate   -> "navigate"
      SameOrigin -> "same-origin"
      NoCors     -> "no-cors"
      Cors       -> "cors"


instance showReferrerPolicy :: Show ReferrerPolicy where
  show policy =
    case policy of
      NoReferrer                  -> "no-referrer"
      NoReferrerWhenDowngrade     -> "no-referrer-when-downgrade"
      SameOriginPolicy            -> "same-origin"
      Origin                      -> "origin"
      StrictOrigin                -> "strict-origin"
      OriginWhenCrossOrigin       -> "origin-when-cross-origin"
      StrictOriginWhenCrossOrigin -> "strict-origin-when-cross-origin"
      UnsafeURL                   -> "unsafe-url"


--------------------
-- FFI
--------------------

foreign import _fetch
  :: forall e req. (IsRequest req)
  => req
  -> Aff (fetch :: FETCH | e) Response

foreign import _new
  :: String
  -> Request

foreign import _new'
  :: forall e
  .  String
  -> RequestInit
  -> Eff (exception :: EXCEPTION | e) Request
