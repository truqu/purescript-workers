module Workers.Class
  ( class AbstractWorker
  , class MessagePort
  ) where


-- | An opaque class to perform high-level operations on workers
class AbstractWorker worker

-- | An opaque class to perform high-level operations on ports
class MessagePort port
