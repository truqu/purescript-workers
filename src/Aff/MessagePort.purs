module Aff.MessagePort
  ( onMessage
  , onMessageError
  , close
  , start
  , module MessagePort
  ) where

import Prelude                     (Unit, (<<<))

import Control.Monad.Aff           (Aff)
import Control.Monad.Eff           (Eff)
import Control.Monad.Eff.Class     (liftEff)
import Control.Monad.Eff.Exception (Error)

import Aff.Workers                 (WORKER)
import MessagePort                  as MP
import MessagePort                 (MessagePort)


-- | Event handler for the `message` event
onMessage
  :: forall e e' msg
  .  MessagePort
  -> (msg -> Eff ( | e') Unit)
  -> Aff (worker :: WORKER | e) Unit
onMessage p =
  liftEff <<< MP.onMessage p


-- | Event handler for the `messageError` event
onMessageError
  :: forall e e'
  .  MessagePort
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
