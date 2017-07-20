module Test.Workers.Worker01 where

import Prelude

import Control.Monad.Eff             (Eff)
import Control.Monad.Eff.Exception   (EXCEPTION)

import Workers                       (WORKER)
import Workers.GlobalScope.Dedicated (onMessage, postMessage)


-- | Basic Worker Replying "world" to any message
main :: forall e. Eff (worker :: WORKER, exception :: EXCEPTION | e) Unit
main =
  onMessage (\_ -> postMessage "world")
