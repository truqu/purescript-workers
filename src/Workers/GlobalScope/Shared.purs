module Workers.GlobalScope.Shared
  ( name
  , applicationCache
  , onConnect
  , module Workers.GlobalScope
  , module ApplicationCache
  ) where

import Prelude

import Control.Monad.Eff   (Eff)
import Data.NonEmpty       (NonEmpty(..))

import ApplicationCache
import Workers             (WORKER)
import Workers.GlobalScope
import Workers.MessagePort (MessagePort)


  -- | Returns sharedWorkerGlobal’s name, i.e. the value given to the SharedWorker constructor.
  -- | Multiple SharedWorker objects can correspond to the same shared worker (and
  -- | SharedWorkerGlobalScope), by reusing the same name.
foreign import name
  :: forall e
  .  Eff (worker :: WORKER | e) String


-- | The applicationCache attribute returns the ApplicationCache object for the worker.
foreign import applicationCache
  :: forall e
  .  Eff (worker :: WORKER | e) ApplicationCache


-- | Event handler for the `connect` event
onConnect
    :: forall e e'
    .  (NonEmpty Array MessagePort -> Eff ( | e') Unit)
    -> Eff (worker :: WORKER | e) Unit
onConnect =
    _onConnect NonEmpty


foreign import _onConnect
  :: forall e e'
  .  (MessagePort -> Array MessagePort -> NonEmpty Array MessagePort)
  -> (NonEmpty Array MessagePort -> Eff ( | e') Unit)
  -> Eff (worker :: WORKER | e) Unit
