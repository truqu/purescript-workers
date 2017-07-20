module Test.Workers.Worker05 where

import Prelude

import Control.Monad.Eff             (Eff)
import Control.Monad.Eff.Exception   (throwException, error, message)

import Workers.GlobalScope.Dedicated (onError, postMessage)


-- | Exception handling via onError
main = do
  onError (message >>> postMessage)
  throwException (error "patate")
