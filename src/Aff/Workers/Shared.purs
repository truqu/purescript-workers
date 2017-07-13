module Aff.Workers.Shared
  ( class SharedWorkerAff, port
  , module Aff.Workers
  , module Aff.Workers.MessagePort
  ) where


import Aff.Workers                  hiding (DedicatedWorker)
import Aff.Workers.MessagePort      hiding (close, start)
import Workers.Shared               as W


class (AbstractWorkerAff worker) <= SharedWorkerAff worker where
  -- | Aborts worker’s associated global environment.
  port
    :: worker
    -> MessagePort


instance dedicatedWorkerAff :: SharedWorkerAff SharedWorker where
  port = W.port
