module Workers
  ( WORKER
  , Location(..)
  , Navigator(..)
  , WorkerType(..)
  , Options
  , Credentials(..)
  , onError
  , postMessage
  , postMessage'
  ) where

import Prelude

import Control.Monad.Eff           (kind Effect, Eff)
import Control.Monad.Eff.Exception (EXCEPTION, Error)
import Data.Generic                (class Generic, gShow)
import Data.Maybe                  (Maybe(..))
import Data.String.Read            (class Read)

import Workers.Class               (class AbstractWorker, class Channel)


--------------------
-- TYPES
--------------------


foreign import data WORKER :: Effect


newtype Location = Location
  { origin   :: String
  , protocol :: String
  , host     :: String
  , hostname :: String
  , port     :: String
  , pathname :: String
  , search   :: String
  , hash     :: String
  }


-- TODO Add missing worker navigator specific fields
-- https://html.spec.whatwg.org/multipage/workers.html#workernavigator

newtype Navigator = Navigator
  { appCodeName :: String
  , appName     :: String
  , appVersion  :: String
  , platform    :: String
  , product     :: String
  , productSub  :: String
  , userAgent   :: String
  , vendor      :: String
  , vendorSub   :: String
  , language    :: String
  , languages   :: Array String
  , onLine      :: Boolean
  }


data WorkerType
  = Classic
  | Module


data Credentials
  = Omit
  | SameOrigin
  | Include


type Options =
  { name               :: String
  , requestCredentials :: Credentials
  , workerType         :: WorkerType
  }


--------------------
-- METHODS
--------------------


-- | Event handler for the `error` event.
onError
  :: forall e e' worker. (AbstractWorker worker)
  => worker
  -> (Error -> Eff ( | e') Unit)
  -> Eff (worker :: WORKER | e) Unit
onError =
  _onError


-- | Clones message and transmits it to the Worker object.
postMessage
  :: forall e msg channel. (Channel channel)
  => channel
  -> msg
  -> Eff (worker :: WORKER, exception :: EXCEPTION | e) Unit
postMessage p msg =
  _postMessage p msg []


-- | Clones message and transmits it to the port object associated with
-- | dedicatedWorker-Global.transfer can be passed as a list of objects
-- | that are to be transferred rather than cloned.
postMessage'
  :: forall e msg transfer channel. (Channel channel)
  => channel
  -> msg
  -> Array transfer
  -> Eff (worker :: WORKER, exception :: EXCEPTION | e) Unit
postMessage' =
  _postMessage


--------------------
-- INSTANCES
--------------------


derive instance genericLocation :: Generic Location


derive instance genericNavigator :: Generic Navigator


instance showLocation :: Show Location where
  show = gShow


instance showNavigator :: Show Navigator where
  show = gShow


instance showWorkerType :: Show WorkerType where
  show workerType =
    case workerType of
      Classic -> "classic"
      Module  -> "module"


instance showCredentials :: Show Credentials where
  show cred =
    case cred of
      Omit       -> "omit"
      SameOrigin -> "same-origin"
      Include    -> "include"


instance readWorkerType :: Read WorkerType where
  read s =
    case s of
      "classic" -> pure Classic
      "module"  -> pure Module
      _         -> Nothing


instance readCredentials :: Read Credentials where
  read s =
    case s of
      "omit"        -> pure Omit
      "same-origin" -> pure SameOrigin
      "include"     -> pure Include
      _             -> Nothing


--------------------
-- FFI
--------------------


foreign import _onError
  :: forall e e' worker
  .  worker
  -> (Error -> Eff ( | e') Unit)
  -> Eff (worker :: WORKER | e) Unit


foreign import _postMessage
  :: forall e msg transfer channel
  .  channel
  ->  msg
  -> Array transfer
  -> Eff (worker :: WORKER, exception :: EXCEPTION | e) Unit
