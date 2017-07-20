module Test.Workers.Worker07 where

import Prelude

import Control.Monad.Eff           (Eff)
import Control.Monad.Eff.Exception (EXCEPTION, name, catchException)

import Workers                     (WORKER)
import GlobalScope.Dedicated       (postMessage)


-- | Catch Data Clone Errors
main :: forall e. Eff (worker :: WORKER, exception :: EXCEPTION | e) Unit
main = do
  (name >>> postMessage) `catchException` postMessage ((+) 1)
