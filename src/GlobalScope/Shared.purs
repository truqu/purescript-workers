module GlobalScope.Shared
  ( name
  , applicationCache
  , onConnect
  , module GlobalScope
  , module ApplicationCache
  ) where

import Prelude           (Unit)

import Control.Monad.Eff (Eff)
import Data.NonEmpty     (NonEmpty(..))

import ApplicationCache  (APPCACHE, ApplicationCache, Status(..), abort, status, swapCache, update)
import GlobalScope       (close, location, navigator, onError, onLanguageChange, onOffline, onOnline, onRejectionHandled, onUnhandledRejection)
import Workers           (WORKER)
import MessagePort       (MessagePort)


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
