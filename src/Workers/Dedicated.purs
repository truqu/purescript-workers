module Workers.Dedicated
  ( class DedicatedWorkerEff, terminate
  , module Workers
  , module MessagePort
  ) where

import Prelude           (Unit)

import Control.Monad.Eff (Eff)

import Workers           (class AbstractWorkerEff, Credentials(..), DedicatedWorker, Location, Navigator, WORKER, WorkerOptions, WorkerType(..), new, new', onError)
import MessagePort       (class MessagePortEff, MessagePort, onMessage, onMessageError, postMessage, postMessage')


class (AbstractWorkerEff worker, MessagePortEff worker) <= DedicatedWorkerEff worker where
  -- | Aborts worker’s associated global environment.
  terminate
    :: forall e
    .  worker
    -> Eff (worker :: WORKER | e) Unit


instance dedicatedWorker :: DedicatedWorkerEff DedicatedWorker where
  terminate = _terminate


foreign import _terminate
  :: forall e
  .  DedicatedWorker
  -> Eff (worker :: WORKER | e) Unit
