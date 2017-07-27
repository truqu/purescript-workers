module Aff.MessagePort
  ( postMessage
  , postMessage'
  , onMessage
  , onMessageError
  , close
  , start
  , module MessagePort
  ) where

import Prelude                     (Unit, (<<<))

import Control.Monad.Aff           (Aff)
import Control.Monad.Eff           (Eff)
import Control.Monad.Eff.Class     (liftEff)
import Control.Monad.Eff.Exception (EXCEPTION, Error)

import Aff.Workers                 (WORKER)
import MessagePort                  as MP
import MessagePort                 (MessagePort)
import Workers.Class               (class MessagePort)


-- | Clones message and transmits it to the Worker object.
postMessage
  :: forall e msg port. (MessagePort port)
  => port
  -> msg
  -> Aff (worker :: WORKER, exception :: EXCEPTION | e) Unit
postMessage p =
  liftEff <<< MP.postMessage p


-- | Clones message and transmits it to the port object associated with
-- | dedicatedportGlobal.transfer can be passed as a list of objects that are to be
-- | transferred rather than cloned.
postMessage'
  :: forall e msg transfer port. (MessagePort port)
  => port
  -> msg
  -> Array transfer
  -> Aff (worker :: WORKER, exception :: EXCEPTION | e) Unit
postMessage' p m =
  liftEff <<< MP.postMessage' p m


-- | Event handler for the `message` event
onMessage
  :: forall e e' msg port. (MessagePort port)
  => port
  -> (msg -> Eff ( | e') Unit)
  -> Aff (worker :: WORKER | e) Unit
onMessage p =
  liftEff <<< MP.onMessage p


-- | Event handler for the `messageError` event
onMessageError
  :: forall e e' port. (MessagePort port)
  => port
  -> (Error -> Eff ( | e') Unit)
  -> Aff (worker :: WORKER | e) Unit
onMessageError p =
  liftEff <<< MP.onMessageError p


-- | TODO DOC
close
  :: forall e
  .  MessagePort
  -> Aff (worker :: WORKER | e) Unit
close =
  liftEff <<< MP.close


-- | TODO DOC
start
  :: forall e
  .  MessagePort
  -> Aff (worker :: WORKER | e) Unit
start =
  liftEff <<< MP.start
