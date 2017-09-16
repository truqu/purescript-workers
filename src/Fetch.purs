module Fetch
  -- * Effects & Classes
  ( FETCH
  , class IsRequest, toRequest
  , class HasBody, text, json
  , class Clone, clone

  -- * Fetch
  , fetch

  -- * Request
  , Request
  , RequestInfo
  , RequestInit
  , Credentials
  , Destination
  , Mode
  , Redirect
  , ReferrerPolicy
  , RequestCache
  , RequestType
  , new
  , new'
  , requestCache
  , requestCredentials
  , requestDestination
  , requestHeaders
  , requestIntegrity
  , requestKeepAlive
  , requestMethod
  , requestMode
  , requestRedirect
  , requestReferrer
  , requestReferrerPolicy
  , requestURL
  , requestType

  -- * Response
  , Response
  , ResponseType
  , responseError
  , responseHeaders
  , responseOk
  , responseRedirect
  , responseRedirected
  , responseStatus
  , responseStatusCode
  , responseType
  , responseURL
  ) where

import Prelude

import Control.Monad.Aff           (Aff)
import Control.Monad.Eff           (kind Effect, Eff)
import Control.Monad.Eff.Exception (EXCEPTION)
import Data.Argonaut.Core          (Json)
import Data.Maybe                  (Maybe(..))
import Data.Nullable               (Nullable, toNullable)
import Data.String.Read            (class Read, read)
import Network.HTTP                (Verb, Header(..), HeaderHead, StatusCode, string2Head, string2Verb, number2Status, status2Number)


--------------------
-- TYPES
--------------------

foreign import data FETCH :: Effect


foreign import data Response :: Type


foreign import data Request :: Type


class IsRequest req where
  toRequest :: req -> Request


class HasBody body where
  json :: forall e. body -> Aff (fetch :: FETCH | e) Json
  text :: forall e. body -> Aff (fetch :: FETCH | e) String


class Clone object where
  clone :: forall e. object -> Eff (exception :: EXCEPTION | e) object


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


data ResponseType
  = Basic
  | CorsResponse
  | DefaultResponse
  | ErrorResponse
  | Opaque
  | OpaqueRedirect


--------------------
-- METHODS
--------------------

-- Fetch

fetch
  :: forall e req. (IsRequest req)
  => req
  -> Aff (fetch :: FETCH | e) Response
fetch =
  toRequest >>> _fetch


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
  _newPrime url opts


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

-- Response

responseError
  :: Response
  -> Response
responseError =
  _responseError


responseHeaders
  :: Response
  -> Array Header
responseHeaders =
  _responseHeaders string2Head Header


responseOk
  :: Response
  -> Boolean
responseOk =
  _responseOk


responseRedirect
  :: Response
  -> String
  -> Maybe StatusCode
  -> Response
responseRedirect res url code =
  _responseRedirect res url (toNullable (status2Number <$> code))


responseRedirected
  :: Response
  -> Boolean
responseRedirected =
  _responseRedirected


responseStatus
  :: Response
  -> StatusCode
responseStatus =
  _responseStatus (number2Status >>> toNullable)


responseStatusCode
  :: Response
  -> Int
responseStatusCode =
  _responseStatusCode


responseType
  :: Response
  -> ResponseType
responseType =
  _responseType (read >>> toNullable)


responseURL
  :: Response
  -> String
responseURL =
  _responseURL


--------------------
-- INSTANCES
--------------------

instance isRequestRequest :: IsRequest Request where
  toRequest =
    id


instance isRequestString :: IsRequest String where
  toRequest =
    new


instance hasBodyRequest :: HasBody Request where
  text =
    _text

  json =
    _json


instance hasBodyResponse :: HasBody Response where
  text =
    _text

  json =
    _json


instance cloneRequest :: Clone Request where
  clone =
    _clone


instance cloneResponse :: Clone Response where
  clone =
    _clone


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


instance showResponseType :: Show ResponseType where
  show resType =
    case resType of
      Basic           -> "basic"
      CorsResponse    -> "cors"
      DefaultResponse -> "default"
      ErrorResponse   -> "error"
      Opaque          -> "opaque"
      OpaqueRedirect  -> "opaqueredirect"


instance readResponseType :: Read ResponseType where
  read s =
    case s of
      "basic"          -> pure Basic
      "cors"           -> pure CorsResponse
      "default"        -> pure DefaultResponse
      "error"          -> pure ErrorResponse
      "opaque"         -> pure Opaque
      "opaqueredirect" -> pure OpaqueRedirect
      _                -> Nothing


--------------------
-- FFI
--------------------

-- Fetch

foreign import _fetch
  :: forall e
  .  Request
  -> Aff (fetch :: FETCH | e) Response

-- Clone

foreign import _clone
  :: forall object e
  .  object
  -> Eff (exception :: EXCEPTION | e) object

-- HasBody

foreign import _text
  :: forall e body
  .  body
  -> Aff (fetch :: FETCH | e) String


foreign import _json
  :: forall e body
  .  body
  -> Aff (fetch :: FETCH | e) Json


-- Request

foreign import _new
  :: String
  -> Request


foreign import _newPrime
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

-- Response

foreign import _responseError
  :: Response
  -> Response


foreign import _responseHeaders
  :: (String -> HeaderHead)
  -> (HeaderHead -> String -> Header)
  -> Response
  -> Array Header


foreign import _responseOk
  :: Response
  -> Boolean


foreign import _responseRedirect
  :: Response
  -> String
  -> Nullable Int
  -> Response


foreign import _responseRedirected
  :: Response
  -> Boolean


foreign import _responseStatus
  :: (Int -> Nullable StatusCode)
  -> Response
  -> StatusCode


foreign import _responseStatusCode
  :: Response
  -> Int


foreign import _responseType
  :: (String -> Nullable ResponseType)
  -> Response
  -> ResponseType


foreign import _responseURL
  :: Response
  -> String
