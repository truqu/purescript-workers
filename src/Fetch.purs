module Fetch where

import Prelude

import Control.Monad.Aff           (Aff)
import Control.Monad.Eff           (kind Effect, Eff)
import Control.Monad.Eff.Exception (EXCEPTION, Error)
import Data.Maybe                  (Maybe(..))
import Data.Either                 (Either(..))
import Data.Nullable               (Nullable, toNullable)
import Network.HTTP                (Verb, Header(..), HeaderHead, string2Head, string2Verb)
import Data.String.Read            (class Read, read)
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
  { requestMethod         :: Verb
  , requestHeaders        :: Array Header
  , requestMode           :: Mode
  , requestCache          :: RequestCache
  , requestKeepAlive      :: Boolean
  , requestCredentials    :: Maybe Credentials
  , requestBody           :: Maybe String
  , requestReferrer       :: Maybe String
  , requestReferrerPolicy :: Maybe ReferrerPolicy
  , requestRedirect       :: Maybe Redirect
  , requestIntegrity      :: Maybe String
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


data Destination
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


data Redirect
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


data Credentials
  = Omit
  | SameOriginCredentials
  | Include


data Mode
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

-- Fetch

fetch
  :: forall e req. (IsRequest req)
  => req
  -> Aff (fetch :: FETCH | e) Response
fetch =
  _fetch


-- Request

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


requestCache
  :: Request
  -> RequestCache
requestCache =
  _requestCache (read >>> toNullable)


requestCredentials
  :: Request
  -> Credentials
requestCredentials =
  _requestCredentials (read >>> toNullable)


requestDestination
  :: Request
  -> Destination
requestDestination =
  _requestDestination (read >>> toNullable)


requestHeaders
  :: Request
  -> Array Header
requestHeaders =
  _requestHeaders string2Head Header

requestIntegrity
  :: Request
  -> String
requestIntegrity =
  _requestIntegrity


requestKeepAlive
  :: Request
  -> Boolean
requestKeepAlive =
  _requestKeepAlive


requestMethod
  :: Request
  -> Verb
requestMethod =
  _requestMethod (string2Verb >>> toNullable)


requestMode
  :: Request
  -> Mode
requestMode =
  _requestMode (read >>> toNullable)


requestRedirect
  :: Request
  -> Redirect
requestRedirect =
  _requestRedirect (read >>> toNullable)


requestReferrer
  :: Request
  -> String
requestReferrer =
  _requestReferrer


requestReferrerPolicy
  :: Request
  -> ReferrerPolicy
requestReferrerPolicy =
  _requestReferrerPolicy (read >>> toNullable)


requestURL
  :: Request
  -> String
requestURL =
  _requestURL


requestType
  :: Request
  -> RequestType
requestType =
  _requestType (read >>> toNullable)


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


instance readRequestType :: Read RequestType where
  read s =
    case s of
      "audio"  -> pure Audio
      "font"   -> pure Font
      "image"  -> pure Image
      "script" -> pure Script
      "style"  -> pure Style
      "track"  -> pure Track
      "video"  -> pure Video
      ""       -> pure UnknownType
      _        -> Nothing


instance showDestination :: Show Destination where
  show destination =
    case destination of
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


instance readDestination :: Read Destination where
  read s =
    case s of
      "document"      -> pure Document
      "embed"         -> pure Embed
      "manifest"      -> pure Manifest
      "object"        -> pure Object
      "report"        -> pure Report
      "serviceworker" -> pure ServiceWorker
      "sharedworker"  -> pure SharedWorker
      "worker"        -> pure DedicatedWorker
      "xslt"          -> pure XSLT
      ""              -> pure UnknownDestination
      t               -> Type <$> read t


instance showRedirect :: Show Redirect where
  show redirect =
    case redirect of
      Follow -> "follow"
      Error  -> "error"
      Manual -> "manual"


instance readRedirect :: Read Redirect where
  read s =
    case s of
      "follow" -> pure Follow
      "error"  -> pure Error
      "manual" -> pure Manual
      _        -> Nothing


instance showRequestCache :: Show RequestCache where
  show reqCache =
    case reqCache of
      Default      -> "default"
      NoStore      -> "no-store"
      Reload       -> "reload"
      NoCache      -> "no-cache"
      ForceCache   -> "force-cache"
      OnlyIfCached -> "only-if-cached"


instance readRequestCache :: Read RequestCache where
  read s =
    case s of
      "default"        -> pure Default
      "no-store"       -> pure NoStore
      "reload"         -> pure Reload
      "no-cache"       -> pure NoCache
      "force-cache"    -> pure ForceCache
      "only-if-cached" -> pure OnlyIfCached
      _                -> Nothing


instance showCredentials :: Show Credentials where
  show credentials =
    case credentials of
      Omit                  -> "omit"
      SameOriginCredentials -> "same-origin"
      Include               -> "include"


instance readCredentials :: Read Credentials where
  read credentials =
    case credentials of
      "omit"        -> pure Omit
      "same-origin" -> pure SameOriginCredentials
      "include"     -> pure Include
      _             -> Nothing


instance showMode :: Show Mode where
  show mode =
    case mode of
      Navigate   -> "navigate"
      SameOrigin -> "same-origin"
      NoCors     -> "no-cors"
      Cors       -> "cors"


instance readMode :: Read Mode where
  read s =
    case s of
      "navigate"    -> pure Navigate
      "same-origin" -> pure SameOrigin
      "no-cors"     -> pure NoCors
      "cors"        -> pure Cors
      _             -> Nothing


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


instance readReferrerPolicy :: Read ReferrerPolicy where
  read s =
    case s of
      "no-referrer"                     -> pure NoReferrer
      "no-referrer-when-downgrade"      -> pure NoReferrerWhenDowngrade
      "same-origin"                     -> pure SameOriginPolicy
      "origin"                          -> pure Origin
      "strict-origin"                   -> pure StrictOrigin
      "origin-when-cross-origin"        -> pure OriginWhenCrossOrigin
      "strict-origin-when-cross-origin" -> pure StrictOriginWhenCrossOrigin
      "unsafe-url"                      -> pure UnsafeURL
      _                                 -> Nothing


--------------------
-- FFI
--------------------

-- Fetch

foreign import _fetch
  :: forall e req. (IsRequest req)
  => req
  -> Aff (fetch :: FETCH | e) Response

-- Request

foreign import _new
  :: String
  -> Request


foreign import _new'
  :: forall e
  .  String
  -> RequestInit
  -> Eff (exception :: EXCEPTION | e) Request


foreign import _requestCache
  :: (String -> Nullable RequestCache)
  -> Request
  -> RequestCache


foreign import _requestCredentials
  :: (String -> Nullable Credentials)
  -> Request
  -> Credentials


foreign import _requestDestination
  :: (String -> Nullable Destination)
  -> Request
  -> Destination


foreign import _requestHeaders
  :: (String -> HeaderHead)
  -> (HeaderHead -> String -> Header)
  -> Request
  -> Array Header

foreign import _requestIntegrity
  :: Request
  -> String


foreign import _requestKeepAlive
  :: Request
  -> Boolean


foreign import _requestMethod
  :: (String -> Nullable Verb)
  -> Request
  -> Verb


foreign import _requestMode
  :: (String -> Nullable Mode)
  -> Request
  -> Mode


foreign import _requestRedirect
  :: (String -> Nullable Redirect)
  -> Request
  -> Redirect


foreign import _requestReferrer
  :: Request
  -> String


foreign import _requestReferrerPolicy
  :: (String -> Nullable ReferrerPolicy)
  -> Request
  -> ReferrerPolicy


foreign import _requestURL
  :: Request
  -> String


foreign import _requestType
  :: (String -> Nullable RequestType)
  -> Request
  -> RequestType
