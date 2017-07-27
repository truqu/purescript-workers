module Test.Workers.Worker04 where

import Prelude

import Control.Monad.Eff           (Eff)
import Control.Monad.Eff.Exception (EXCEPTION)
import Data.NonEmpty               (head)

import GlobalScope.Shared          (onConnect)
import Workers.Shared              (WORKER, postMessage)


-- | Shared Worker working through a port
main :: forall e. Eff (worker :: WORKER, exception :: EXCEPTION | e) Unit
main =
  onConnect $ \ports -> postMessage (head ports) true
