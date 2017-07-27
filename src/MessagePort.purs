module MessagePort
  -- * Types
  ( MessagePort

  -- * Interaction with MessagePort-like types
  , postMessage
  , postMessage'
  , onMessage
  , onMessageError

  -- * MessagePort specific manipulations
  , close
  , start
  ) where

import Prelude

import Control.Monad.Eff           (Eff)
import Control.Monad.Eff.Exception (EXCEPTION, Error)

import Workers                     (WORKER)
import Workers.Class               (class MessagePort, messagePortConstructor)


--------------------
-- TYPES
--------------------


foreign import data MessagePort :: Type


--------------------
-- METHODS
--------------------

-- | Clones message and transmits it to the Worker object.
postMessage
  :: forall e msg port. (MessagePort port)
  => port
  -> msg
  -> Eff (worker :: WORKER, exception :: EXCEPTION | e) Unit
postMessage p msg =
  _postMessage p msg []


-- | Clones message and transmits it to the port object associated with
-- | dedicatedportGlobal.transfer can be passed as a list of objects that are to be
-- | transferred rather than cloned.
postMessage'
  :: forall e msg transfer port. (MessagePort port)
  => port
  -> msg
  -> Array transfer
  -> Eff (worker :: WORKER, exception :: EXCEPTION | e) Unit
postMessage' =
  _postMessage


-- | Event handler for the `message` event
onMessage
  :: forall e e' msg port. (MessagePort port)
  => port
  -> (msg -> Eff ( | e') Unit)
  -> Eff (worker :: WORKER | e) Unit
onMessage port =
  _onMessage (messagePortConstructor port) port


-- | Event handler for the `messageError` event
onMessageError
  :: forall e e' port. (MessagePort port)
  => port
  -> (Error -> Eff ( | e') Unit)
  -> Eff (worker :: WORKER | e) Unit
onMessageError port =
  _onMessageError (messagePortConstructor port) port


-- | TODO DOC
close
  :: forall e
  .  MessagePort
  -> Eff (worker :: WORKER | e) Unit
close =
  _close


-- | TODO DOC
start
  :: forall e
  .  MessagePort
  -> Eff (worker :: WORKER | e) Unit
start =
  _start


--------------------
-- INSTANCES
--------------------


instance messagePortMessagePort :: MessagePort MessagePort where
  messagePortConstructor _ =
    "MessagePort"


--------------------
-- FFI
--------------------


foreign import _postMessage
  :: forall e msg transfer port
  .  port
  ->  msg
  -> Array transfer
  -> Eff (worker :: WORKER, exception :: EXCEPTION | e) Unit


foreign import _onMessage
  :: forall e e' msg port
  .  String
  -> port
  -> (msg -> Eff ( | e') Unit)
  -> Eff (worker :: WORKER | e) Unit


foreign import _onMessageError
  :: forall e e' port
  .  String
  -> port
  -> (Error -> Eff ( | e') Unit)
  -> Eff (worker :: WORKER | e) Unit


foreign import _close
  :: forall e
  .  MessagePort
  -> Eff (worker :: WORKER | e) Unit


foreign import _start
  :: forall e
  .  MessagePort
  -> Eff (worker :: WORKER | e) Unit
