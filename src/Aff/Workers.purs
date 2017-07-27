module Aff.Workers
  ( onError
  , postMessage
  , postMessage'
  , module Workers
  ) where

import Prelude

import Control.Monad.Aff           (Aff)
import Control.Monad.Eff           (Eff)
import Control.Monad.Eff.Class     (liftEff)
import Control.Monad.Eff.Exception (EXCEPTION, Error)

import Workers                      as W
import Workers                     (WORKER, Location(..), Navigator(..), Options, WorkerType(..), Credentials(..))
import Workers.Class               (class AbstractWorker, class Channel)


-- | Event handler for the `error` event.
onError
  :: forall e e' worker. (AbstractWorker worker)
  => worker
  -> (Error -> Eff ( | e') Unit)
  -> Aff (worker :: WORKER | e) Unit
onError w =
  liftEff <<< W.onError w


-- | Clones message and transmits it to the Worker object.
postMessage
  :: forall e msg channel. (Channel channel)
  => channel
  -> msg
  -> Aff (worker :: WORKER, exception :: EXCEPTION | e) Unit
postMessage p =
  liftEff <<< W.postMessage p


-- | Clones message and transmits it to the port object associated with
-- | dedicatedportGlobal.transfer can be passed as a list of objects that are to be
-- | transferred rather than cloned.
postMessage'
  :: forall e msg transfer channel. (Channel channel)
  => channel
  -> msg
  -> Array transfer
  -> Aff (worker :: WORKER, exception :: EXCEPTION | e) Unit
postMessage' p m =
  liftEff <<< W.postMessage' p m
