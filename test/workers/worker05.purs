module Test.Workers.Worker05 where

import Prelude

import Control.Monad.Eff             (Eff)
import Control.Monad.Eff.Exception   (EXCEPTION, throwException, error, name)

import Workers                       (WORKER)
import Workers.GlobalScope.Dedicated (onError, postMessage)


-- | Exception handling via onError
main :: forall e. Eff (worker :: WORKER, exception :: EXCEPTION | e) Unit
main = do
  onError (name >>> postMessage)
  throwException (error "patate")
