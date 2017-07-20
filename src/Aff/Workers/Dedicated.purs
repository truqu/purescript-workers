module Aff.Workers.Dedicated
  ( class DedicatedWorkerAff, terminate
  , module Aff.Workers
  , module Aff.MessagePort
  ) where


import Prelude                 (Unit, (<<<))

import Control.Monad.Aff       (Aff)
import Control.Monad.Eff.Class (liftEff)

import Aff.Workers             (class AbstractWorkerAff, Credentials(..), DedicatedWorker, Location, Navigator, WORKER, WorkerOptions, WorkerType(..), new, new', onError)
import Aff.MessagePort         (class MessagePortAff, MessagePort, onMessage, onMessageError, postMessage, postMessage')
import Workers.Dedicated        as W


class (AbstractWorkerAff worker, MessagePortAff worker) <= DedicatedWorkerAff worker where
  -- | Aborts worker’s associated global environment.
  terminate
    :: forall e
    .  worker
    -> Aff (worker :: WORKER | e) Unit


instance dedicatedWorkerAff :: DedicatedWorkerAff DedicatedWorker where
  terminate = liftEff <<< W.terminate
