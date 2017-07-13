module Workers.Dedicated
  ( class DedicatedWorkerI, terminate
  , module Workers
  , module Workers.MessagePort
  ) where

import Prelude

import Control.Monad.Eff(Eff)
import Control.Monad.Eff.Exception(Error)

import Workers hiding (SharedWorker)
import Workers.MessagePort hiding (close, start)


class (AbstractWorkerI worker, MessagePortI worker) <= DedicatedWorkerI worker where
  -- | Aborts worker’s associated global environment.
  terminate
    :: forall e
    .  worker
    -> Eff (worker :: WORKER | e) Unit


instance dedicatedWorker :: DedicatedWorkerI DedicatedWorker where
  terminate  = _terminate


foreign import _terminate
  :: forall e
  .  DedicatedWorker
  -> Eff (worker :: WORKER | e) Unit
