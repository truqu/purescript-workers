module Test.Workers.Worker02 where

import Prelude

import Control.Monad.Eff             (Eff)
import Control.Monad.Eff.Exception   (EXCEPTION)

import Workers                       (WORKER)
import Workers.GlobalScope.Dedicated (postMessage, onMessage, location)


-- | Worker accessing the location in its global scope
main :: forall e. Eff (worker :: WORKER, exception :: EXCEPTION | e) Unit
main =
  onMessage (\_ -> location `bind` postMessage)
