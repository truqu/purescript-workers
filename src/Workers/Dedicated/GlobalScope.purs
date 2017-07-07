module Workers.Dedicated.GlobalScope
  ( name
  , postMessage
  , onMessage
  , onMessageError
  , module Workers.GlobalScope
  ) where

import Prelude

import Control.Monad.Eff(Eff)

import Workers(WORKER, Location, Navigator)
import Workers.GlobalScope


-- | Returns dedicatedWorkerGlobal’s name, i.e. the value given to the Worker constructor.
-- | Primarily useful for debugging.
foreign import name
  :: forall e
  .  Eff (worker :: WORKER | e) String


-- | Clones message and transmits it to the Worker object.
foreign import postMessage
  :: forall e msg
  .  msg
  -> Eff (worker :: WORKER | e) Unit


-- | Clones message and transmits it to the Worker object associated with
-- | dedicatedWorkerGlobal.transfer can be passed as a list of objects that are to be
-- | transferred rather than cloned.
foreign import postMessage'
  :: forall e msg transfer
  .  msg
  -> Array transfer
  -> Eff (worker :: WORKER | e) Unit


-- | Event handler for the `message` event
foreign import onMessage
  :: forall e e' msg.
  => (msg -> Eff ( | e') Unit)
  -> Eff (worker :: WORKER | e) Unit


-- | Event handler for the `messageError` event
foreign import onMessageError
  :: forall e e'.
  => (Error -> Eff ( | e') Unit)
  -> Eff (worker :: WORKER | e) Unit
