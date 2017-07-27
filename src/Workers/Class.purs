module Workers.Class
  ( class AbstractWorker, abstractWorkerConstructor
  , class MessagePort, messagePortConstructor
  ) where


-- | An opaque class to perform high-level operations on workers
class AbstractWorker worker where
  abstractWorkerConstructor
    :: worker
    -> String


-- | An opaque class to perform high-level operations on ports
class MessagePort port where
  messagePortConstructor
    :: port
    -> String
