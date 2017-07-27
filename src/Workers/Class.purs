module Workers.Class
  ( class AbstractWorker
  , class Channel
  ) where


-- | An opaque class to perform high-level operations on workers
class AbstractWorker worker


-- | An opaque class to perform high-level operations on channels
class Channel port
