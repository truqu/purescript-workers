module Test.Workers.Worker01 where

import Prelude

import Control.Monad.Eff(Eff)
import Workers.GlobalScope.Dedicated(onMessage, postMessage)

-- | Basic Worker Replying "world" to any message
main = onMessage (\_ -> postMessage "world")
