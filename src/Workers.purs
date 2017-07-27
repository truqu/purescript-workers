module Workers
  ( WORKER
  , Location(..)
  , Navigator(..)
  , WorkerType(..)
  , Options
  , Credentials(..)
  , onError
  ) where

import Prelude

import Control.Monad.Eff           (kind Effect, Eff)
import Control.Monad.Eff.Exception (Error)
import Data.Generic                (class Generic, gShow)

import Workers.Class               (class AbstractWorker, class MessagePort)


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


--------------------
-- FFI
--------------------


foreign import _onError
  :: forall e e' worker
  .  worker
  -> (Error -> Eff ( | e') Unit)
  -> Eff (worker :: WORKER | e) Unit
