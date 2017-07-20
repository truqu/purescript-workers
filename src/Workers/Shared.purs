module Workers.Shared
  ( class SharedWorkerI, port
  , module Workers
  , module MessagePort
  ) where

import MessagePort (class MessagePortI, MessagePort, close, onMessage, onMessageError, postMessage, postMessage', start)
import Workers     (class AbstractWorkerI, Credentials(..), SharedWorker, Location, Navigator, WORKER, WorkerOptions, WorkerType(..), new, new', onError)


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
