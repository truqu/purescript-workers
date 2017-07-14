module Test.Workers.Worker03 where

import Prelude

import Control.Monad.Eff(Eff)
import Control.Monad.Eff.Exception(catchException)
import Workers.GlobalScope.Dedicated(onMessage, postMessage)

-- | Worker catching a Data Clone Err
main = onMessage $ \_ -> do
  let f x = "can't serialize function: " <> x
  (\_ -> postMessage true)
    `catchException`
  (postMessage f)
