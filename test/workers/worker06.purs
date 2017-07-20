module Test.Workers.Worker06 where

import Prelude

import Control.Monad.Eff           (Eff)
import Control.Monad.Eff.Exception (EXCEPTION, throwException, error)


-- | Error propagation to parent
main :: forall e. Eff (exception :: EXCEPTION | e) Unit
main = do
  throwException (error "patate")
