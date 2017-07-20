module Test.Workers.Worker03 where

import Prelude

import Control.Monad.Eff(Eff)
import Control.Monad.Eff.Exception(catchException)
import Workers.GlobalScope.Dedicated(onMessage, postMessage, navigator)

-- | Worker accessing the navigator in its global scope
main = onMessage (\_ -> navigator `bind` postMessage)
