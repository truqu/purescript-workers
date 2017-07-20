module Aff.MessagePort
  ( class MessagePortAff, postMessage, postMessage', onMessage, onMessageError
  , module MessagePort
  ) where

import Prelude                     (Unit, (<<<))

import Control.Monad.Aff           (Aff)
import Control.Monad.Eff           (Eff)
import Control.Monad.Eff.Class     (liftEff)
import Control.Monad.Eff.Exception (EXCEPTION, Error)

import Aff.Workers                 (WORKER, DedicatedWorker)
import MessagePort                  as MP
import MessagePort                  hiding  (class MessagePortEff, postMessage, postMessage', onMessage, onMessageError)


class MessagePortAff port where
  -- | Clones message and transmits it to the Worker object.
  postMessage
    :: forall e msg
    . port
    -> msg
    -> Aff (worker :: WORKER, exception :: EXCEPTION | e) Unit

  -- | Clones message and transmits it to the port object associated with
  -- | dedicatedportGlobal.transfer can be passed as a list of objects that are to be
  -- | transferred rather than cloned.
  postMessage'
    :: forall e msg transfer
    . port
    -> msg
    -> Array transfer
    -> Aff (worker :: WORKER, exception :: EXCEPTION | e) Unit

  -- | Event handler for the `message` event
  onMessage
    :: forall e e' msg
    .  port
    -> (msg -> Eff ( | e') Unit)
    -> Aff (worker :: WORKER | e) Unit

  -- | Event handler for the `messageError` event
  onMessageError
    :: forall e e'
    .  port
    -> (Error -> Eff ( | e') Unit)
    -> Aff (worker :: WORKER | e) Unit


instance messagePortMessagePortAff :: MessagePortAff MessagePort where
  postMessage p      = liftEff <<< MP.postMessage p
  postMessage' p msg = liftEff <<< MP.postMessage' p msg
  onMessage p        = liftEff <<< MP.onMessage p
  onMessageError p   = liftEff <<< MP.onMessageError p


instance messagePortDedicatedWorkerAff :: MessagePortAff DedicatedWorker where
  postMessage p      = liftEff <<< MP.postMessage p
  postMessage' p msg = liftEff <<< MP.postMessage' p msg
  onMessage p        = liftEff <<< MP.onMessage p
  onMessageError p   = liftEff <<< MP.onMessageError p
