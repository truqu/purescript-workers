module Test.Workers.Worker05 where

import Prelude

import Control.Monad.Eff             (Eff)
import Control.Monad.Eff.Exception   (throwException, error, name)

import Workers.GlobalScope.Dedicated (onError, postMessage)


-- | Exception handling via onError
main = do
  onError (name >>> postMessage)
  throwException (error "patate")
