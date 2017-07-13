module Workers.Dedicated.GlobalScope
  ( name
  , postMessage
  , postMessage'
  , onMessage
  , onMessageError
  , module Workers.GlobalScope
  ) where

import Prelude

import Control.Monad.Eff(Eff)
import Control.Monad.Eff.Exception(Error)

import Workers(WORKER)
import Workers.GlobalScope


-- | Returns dedicatedWorkerGlobal’s name, i.e. the value given to the Worker constructor.
-- | Primarily useful for debugging.
foreign import name
  :: forall e
  .  Eff (worker :: WORKER | e) String


-- | Clones message and transmits it to the Worker object.
postMessage
  :: forall e msg
  .  msg
  -> Eff (worker :: WORKER | e) Unit
postMessage msg =
  _postMessage msg []


-- | Clones message and transmits it to the Worker object associated with
-- | dedicatedWorkerGlobal.transfer can be passed as a list of objects that are to be
-- | transferred rather than cloned.
postMessage'
  :: forall e msg transfer
  .  msg
  -> Array transfer
  -> Eff (worker :: WORKER | e) Unit
postMessage' =
  _postMessage


foreign import _postMessage
  :: forall e msg transfer
  .  msg
  -> Array transfer
  -> Eff (worker :: WORKER | e) Unit


-- | Event handler for the `message` event
foreign import onMessage
  :: forall e e' msg
  .  (msg -> Eff ( | e') Unit)
  -> Eff (worker :: WORKER | e) Unit


-- | Event handler for the `messageError` event
foreign import onMessageError
  :: forall e e'
  .  (Error -> Eff ( | e') Unit)
  -> Eff (worker :: WORKER | e) Unit
