module MessagePort
  -- * Types
  ( MessagePort

  -- * Interaction with MessagePort-like types
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
import Workers.Class               (class Channel)


--------------------
-- TYPES
--------------------


foreign import data MessagePort :: Type


--------------------
-- METHODS
--------------------

-- | Event handler for the `message` event
onMessage
  :: forall e e' msg
  .  MessagePort
  -> (msg -> Eff ( | e') Unit)
  -> Eff (worker :: WORKER | e) Unit
onMessage port =
  _onMessage port


-- | Event handler for the `messageError` event
onMessageError
  :: forall e e'
  .  MessagePort
  -> (Error -> Eff ( | e') Unit)
  -> Eff (worker :: WORKER | e) Unit
onMessageError port =
  _onMessageError port


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


instance channelMessagePort :: Channel MessagePort


--------------------
-- FFI
--------------------


foreign import _onMessage
  :: forall e e' msg
  .  MessagePort
  -> (msg -> Eff ( | e') Unit)
  -> Eff (worker :: WORKER | e) Unit


foreign import _onMessageError
  :: forall e e'
  .  MessagePort
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
