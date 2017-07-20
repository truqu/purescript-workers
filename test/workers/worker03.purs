module Test.Workers.Worker03 where

import Prelude

import Control.Monad.Eff             (Eff)
import Control.Monad.Eff.Exception   (EXCEPTION)

import Workers                       (WORKER)
import Workers.GlobalScope.Dedicated (onMessage, postMessage, navigator)


-- | Worker accessing the navigator in its global scope
main :: forall e. Eff (worker :: WORKER, exception :: EXCEPTION | e) Unit
main =
  onMessage (\_ -> navigator `bind` postMessage)
