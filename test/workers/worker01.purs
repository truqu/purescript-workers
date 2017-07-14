module Test.Workers.Worker01 where

import Prelude

import Control.Monad.Eff(Eff)
import Control.Monad.Eff.Console(CONSOLE, log)
import Workers.GlobalScope.Dedicated(onMessage, postMessage)

main = onMessage (\_ -> postMessage "world")
