module MessagePort
  ( class MessagePortEff, postMessage, postMessage', onMessage, onMessageError
  , MessagePort
  , close
  , start
  ) where

import Prelude

import Control.Monad.Eff(Eff)
import Control.Monad.Eff.Exception(EXCEPTION, Error)

import Workers(WORKER, DedicatedWorker)


foreign import data MessagePort :: Type


class MessagePortEff port where
  -- | Clones message and transmits it to the Worker object.
  postMessage
    :: forall e msg
    . port
    -> msg
    -> Eff (worker :: WORKER, exception :: EXCEPTION | e) Unit

  -- | Clones message and transmits it to the port object associated with
  -- | dedicatedportGlobal.transfer can be passed as a list of objects that are to be
  -- | transferred rather than cloned.
  postMessage'
    :: forall e msg transfer
    . port
    -> msg
    -> Array transfer
    -> Eff (worker :: WORKER, exception :: EXCEPTION | e) Unit

  -- | Event handler for the `message` event
  onMessage
    :: forall e e' msg
    .  port
    -> (msg -> Eff ( | e') Unit)
    -> Eff (worker :: WORKER | e) Unit

  -- | Event handler for the `messageError` event
  onMessageError
    :: forall e e'
    .  port
    -> (Error -> Eff ( | e') Unit)
    -> Eff (worker :: WORKER | e) Unit


instance messagePortMessagePort :: MessagePortEff MessagePort where
  postMessage p msg = _postMessage p msg []
  postMessage'      = _postMessage
  onMessage         = _onMessage
  onMessageError    = _onMessageError


instance messagePortDedicatedWorker :: MessagePortEff DedicatedWorker where
  postMessage p msg = _postMessage p msg []
  postMessage'      = _postMessage
  onMessage         = _onMessage
  onMessageError    = _onMessageError


foreign import close
  :: forall e
  .  MessagePort
  -> Eff (worker :: WORKER | e) Unit


foreign import start
  :: forall e
  .  MessagePort
  -> Eff (worker :: WORKER | e) Unit


foreign import _postMessage
  :: forall e msg transfer port
  .  port
  ->  msg
  -> Array transfer
  -> Eff (worker :: WORKER, exception :: EXCEPTION | e) Unit


foreign import _onMessage
  :: forall e e' msg port
  .  port
  -> (msg -> Eff ( | e') Unit)
  -> Eff (worker :: WORKER | e) Unit


foreign import _onMessageError
  :: forall e e' port
  .  port
  -> (Error -> Eff ( | e') Unit)
  -> Eff (worker :: WORKER | e) Unit
