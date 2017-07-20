module Workers
  ( WORKER
  , class AbstractWorkerEff, onError, new, new'
  , SharedWorker
  , DedicatedWorker
  , Location(..)
  , Navigator(..)
  , WorkerOptions
  , WorkerType (..)
  , Credentials (..)
  ) where

import Prelude

import Control.Monad.Eff           (kind Effect, Eff)
import Control.Monad.Eff.Exception (Error)
import Data.Generic                (class Generic, gShow)


foreign import data WORKER :: Effect


foreign import data SharedWorker :: Type


foreign import data DedicatedWorker :: Type


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


derive instance genericLocation :: Generic Location


instance showLocation :: Show Location where
  show = gShow


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


derive instance genericNavigator :: Generic Navigator


instance showNavigator :: Show Navigator where
  show = gShow


type WorkerOptions =
  { name               :: String
  , requestCredentials :: Credentials
  , workerType         :: WorkerType
  }


data WorkerType
  = Classic
  | Module


data Credentials
  = Omit
  | SameOrigin
  | Include


class AbstractWorkerEff worker where
  -- | Event handler for the `error` event.
  onError
    :: forall e e'
    .  worker
    -> (Error -> Eff ( | e') Unit)
    -> Eff (worker :: WORKER | e) Unit

  -- | Returns a new Worker object. scriptURL will be fetched and executed in the background,
  -- | creating a new global environment for which worker represents the communication channel.
  new
    :: forall e
    .  String
    -> Eff (worker :: WORKER  | e) worker

  -- | Returns a new Worker object. scriptURL will be fetched and executed in the background,
  -- | creating a new global environment for which worker represents the communication channel.
  -- | options can be used to define the name of that global environment via the name option,
  -- | primarily for debugging purposes. It can also ensure this new global environment supports
  -- | JavaScript modules (specify type: "module"), and if that is specified, can also be used
  -- | to specify how scriptURL is fetched through the credentials option
  new'
    :: forall e
    .  String
    -> WorkerOptions
    -> Eff (worker :: WORKER | e) worker


foreign import _onError
  :: forall e e' worker
  .  worker
  -> (Error -> Eff ( | e') Unit)
  -> Eff (worker :: WORKER | e) Unit


instance abstractWorkerDedicated :: AbstractWorkerEff DedicatedWorker where
  onError = _onError
  new url =
    _newDedicatedWorker url
      { name: ""
      , requestCredentials: (show Omit)
      , workerType: (show Classic)
      }
  new' url opts =
    _newDedicatedWorker url
      { name: opts.name
      , requestCredentials: (show opts.requestCredentials)
      , workerType: (show opts.workerType)
      }


instance abstractWorkerShared:: AbstractWorkerEff SharedWorker where
  onError = _onError
  new url =
    _newSharedWorker url
      { name: ""
      , requestCredentials: (show Omit)
      , workerType: (show Classic)
      }
  new' url opts =
    _newSharedWorker url
      { name: opts.name
      , requestCredentials: (show opts.requestCredentials)
      , workerType: (show opts.workerType)
      }


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


foreign import _newSharedWorker
  :: forall e
  .  String
  -> { name :: String, requestCredentials :: String, workerType :: String }
  -> Eff (worker :: WORKER | e) SharedWorker


foreign import _newDedicatedWorker
  :: forall e
  .  String
  -> { name :: String, requestCredentials :: String, workerType :: String }
  -> Eff (worker :: WORKER | e) DedicatedWorker
