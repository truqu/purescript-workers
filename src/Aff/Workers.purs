module Aff.Workers
  ( onError
  , module Workers
  ) where

import Prelude

import Control.Monad.Aff(Aff)
import Control.Monad.Eff(Eff)
import Control.Monad.Eff.Class(liftEff)
import Control.Monad.Eff.Exception(Error)

import Workers as W
import Workers (WORKER, Location(..), Navigator(..), Options, WorkerType(..), Credentials(..))
import Workers.Class (class AbstractWorker)


-- | Event handler for the `error` event.
onError
  :: forall e e' worker. (AbstractWorker worker)
  => worker
  -> (Error -> Eff ( | e') Unit)
  -> Aff (worker :: WORKER | e) Unit
onError w =
  liftEff <<< W.onError w
