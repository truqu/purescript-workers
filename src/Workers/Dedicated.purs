module Workers.Dedicated
  ( class DedicatedWorkerI, terminate
  , module Workers
  , module MessagePort
  ) where

import Prelude           (Unit)

import Control.Monad.Eff (Eff)

import Workers           (class AbstractWorkerI, Credentials(..), DedicatedWorker, Location, Navigator, WORKER, WorkerOptions, WorkerType(..), new, new', onError)
import MessagePort       (class MessagePortI, MessagePort, onMessage, onMessageError, postMessage, postMessage')


class (AbstractWorkerI worker, MessagePortI worker) <= DedicatedWorkerI worker where
  -- | Aborts worker’s associated global environment.
  terminate
    :: forall e
    .  worker
    -> Eff (worker :: WORKER | e) Unit


instance dedicatedWorker :: DedicatedWorkerI DedicatedWorker where
  terminate = _terminate


foreign import _terminate
  :: forall e
  .  DedicatedWorker
  -> Eff (worker :: WORKER | e) Unit
