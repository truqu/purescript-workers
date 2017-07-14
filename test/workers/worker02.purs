module Test.Workers.Worker02 where

import Prelude

import Control.Monad.Eff(Eff)
import Control.Monad.Eff.Console(CONSOLE, log)
import Workers.GlobalScope.Dedicated(postMessage, onMessage, location)

-- | Worker accessing the location its global scope
main = onMessage (\_ -> location `bind` postMessage)
