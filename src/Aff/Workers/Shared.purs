module Aff.Workers.Shared
  ( class SharedWorkerAff, port
  , module Aff.Workers
  , module Aff.MessagePort
  ) where

import Aff.MessagePort (class MessagePortAff, MessagePort, onMessage, onMessageError, postMessage, postMessage')
import Aff.Workers     (class AbstractWorkerAff, Credentials(..), Location(..), Navigator(..), SharedWorker, WORKER, WorkerOptions, WorkerType(..), new, new', onError)
import Workers.Shared   as W


class (AbstractWorkerAff worker) <= SharedWorkerAff worker where
  -- | Aborts worker’s associated global environment.
  port
    :: worker
    -> MessagePort


instance dedicatedWorkerAff :: SharedWorkerAff SharedWorker where
  port = W.port
