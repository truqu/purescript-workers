module Workers.Shared
  ( class SharedWorkerI, port
  , module Workers
  , module Workers.MessagePort
  ) where

import Prelude

import Control.Monad.Eff(Eff)
import Control.Monad.Eff.Exception(Error)

import Workers hiding (DedicatedWorker)
import Workers.MessagePort


class (AbstractWorkerI worker) <= SharedWorkerI worker where
  -- | Returns sharedWorker’s MessagePort object which can be used
  -- | to communicate with the global environment.
  port
    :: worker
    -> MessagePort


instance sharedWorker :: SharedWorkerI SharedWorker where
  port = _port


foreign import _port
  :: SharedWorker
  -> MessagePort
