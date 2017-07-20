module Test.Workers.Worker06 where

import Prelude

import Control.Monad.Eff           (Eff)
import Control.Monad.Eff.Exception (throwException, error)

-- | Error propagation to parent
main = do
  throwException (error "patate")
