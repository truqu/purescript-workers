module Workers where

import Prelude

import Control.Monad.Eff(kind Effect, Eff)
import Control.Monad.Eff.Exception(Error)
import Data.Version(Version)


foreign import data WORKER :: Effect


foreign import data SharedWorker :: Type


foreign import data DedicatedWorker :: Type


type Location =
  { origin   :: String
  , protocol :: String
  , host     :: String
  , hostname :: String
  , port     :: String
  , pathname :: String
  , search   :: String
  , hash     :: String
  }


type Navigator =
  { appCodeName :: String
  , appName     :: String
  , appVersion  :: Version
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


class AbstractWorkerI worker where
  -- | Event handler for the `error` event.
  onError
    :: forall e e'
    .  worker
    -> (Error -> Eff ( | e') Unit)
    -> Eff (worker :: WORKER | e) Unit


instance abstractWorkerDedicated :: AbstractWorkerI DedicatedWorker where
  onError = _onError


instance abstractWorkerShared:: AbstractWorkerI SharedWorker where
  onError = _onError


foreign import _onError
  :: forall e e' worker
  .  worker
  -> (Error -> Eff ( | e') Unit)
  -> Eff (worker :: WORKER | e) Unit
