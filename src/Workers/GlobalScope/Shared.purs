module Workers.GlobalScope.Shared
  ( name
  , applicationCache
  , onConnect
  , module Workers.GlobalScope
  , module ApplicationCache
  ) where

import Prelude

import Control.Monad.Eff(Eff)

import ApplicationCache
import Workers(WORKER)
import Workers.GlobalScope


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
foreign import onConnect
  :: forall e e'
  .  Eff ( | e') Unit
  -> Eff (worker :: WORKER | e) Unit
