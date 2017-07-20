module Test.Workers.Worker07 where

import Prelude

import Control.Monad.Eff           (Eff)
import Control.Monad.Eff.Exception (throwException, error, name, catchException)

import Workers.GlobalScope.Dedicated(postMessage)

-- | Catch Data Clone Errors
main = do
  (name >>> postMessage) `catchException` postMessage ((+) 1)
