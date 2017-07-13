module Workers.Shared
  ( SharedWorkerI
  , WorkerOptions
  , WorkerType
  , RequestCredentials
  , terminate
  , postMessage
  , postMessage'
  , onMessage
  , onMessageError
  , module Workers
  ) where

import Prelude

import Control.Monad.Eff(Eff)

import Workers(WORKER, class AbstractWorkerI, DedicatedWorker, Location, Navigator)


class DedicatedWorkerI worker where
  -- | Clones message and transmits it to the Worker object.
  postMessage
    :: forall e msg
    . worker
    -> msg
    -> Eff (worker :: WORKER | e) Unit

  -- | Clones message and transmits it to the Worker object associated with
  -- | dedicatedWorkerGlobal.transfer can be passed as a list of objects that are to be
  -- | transferred rather than cloned.
  postMessage'
    :: forall e msg transfer
    . worker
    -> msg
    -> Array transfer
    -> Eff (worker :: WORKER | e) Unit

  -- | Aborts worker’s associated global environment.
  terminate
    :: forall e
    .  worker
    -> Eff (worker :: WORKER | e) Unit

  -- | Event handler for the `message` event
  onMessage
    :: forall e e' msg
    .  worker
    -> (msg -> Eff ( | e') Unit)
    -> Eff (worker :: WORKER | e) Unit

  -- | Event handler for the `messageError` event
  onMessageError
    :: forall e e'
    .  worker
    -> (Error -> Eff ( | e') Unit)
    -> Eff (worker :: WORKER | e) Unit


type WorkerOptions =
  { workerType         :: WorkerType
  , requestCredentials :: Credentials
  }


data WorkerType
  = Classic
  | Module


instance showWorkerType :: Show WorkerType where
  show workerType =
    case workerType of
      Classic -> "classic"
      Module  -> "module"


data Credentials
  = Omit
  | SameOrigin
  | Include


instance showCredentials :: Show Credentials where
  show cred =
    case cred of
      Omit       -> "omit"
      SameOrigin -> "same-origin"
      Include    -> "include"


-- | Returns a new Worker object. scriptURL will be fetched and executed in the background,
-- | creating a new global environment for which worker represents the communication channel.
new :: forall e. String -> Eff (worker :: WORKER  | e) DedicatedWorker
new url =
  _new url { workerType: (show Classic), requestCredentials: (show Omit) }


-- | Returns a new Worker object. scriptURL will be fetched and executed in the background,
-- | creating a new global environment for which worker represents the communication channel.
-- | options can be used to define the name of that global environment via the name option,
-- | primarily for debugging purposes. It can also ensure this new global environment supports
-- | JavaScript modules (specify type: "module"), and if that is specified, can also be used
-- | to specify how scriptURL is fetched through the credentials option
new' :: forall e. String -> WorkerOptions -> Eff (worker :: WORKER | e) DedicatedWorker
new' url opts =
  _new url { workerType: (show opts.workerType), requestCredentials: (show opts.requestCredentials) }


instance dedicatedWorker :: DedicatedWorkerI DedicatedWorker where
  terminate       = _terminate
  postMessage msg = _postMessage msg []
  postMessage'    = _postMessage
  onMessage       = _onMessage
  onMessageError  = _onMessageError


foreign import _new
  :: forall e
  .  String
  -> { workerType :: String, requestCredentials :: String }
  -> Eff (worker :: WORKER | e) DedicatedWorker


foreign import _postMessage
  :: forall e msg transfer
  .  DedicatedWorker
  ->  msg
  -> Array transfer
  -> Eff (worker :: WORKER | e) Unit


foreign import _terminate
  :: forall e
  .  worker
  -> Eff (worker :: WORKER | e) Unit


foreign import _onMessage
  :: forall e e' msg
  .  DedicatedWorker
  -> (msg -> Eff ( | e') Unit)
  -> Eff (worker :: WORKER | e) Unit


foreign import _onMessageError
  :: forall e e'
  .  DedicatedWorker
  -> (Error -> Eff ( | e') Unit)
  -> Eff (worker :: WORKER | e) Unit
