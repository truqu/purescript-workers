module Test.Workers.Worker02 where

import Prelude

import Control.Monad.Eff(Eff)
import Control.Monad.Eff.Console(CONSOLE, log)
import Workers.Dedicated.GlobalScope(postMessage, onMessage, location)

main = onMessage (\_ -> location `bind` postMessage)
