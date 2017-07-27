module Aff.Workers.Service
  ( controller
  , getRegistration
  , onControllerChange
  , ready
  , register
  , startMessages
  , onStateChange
  , scriptURL
  , state
  , active
  , installing
  , waiting
  , scope
  , update
  , unregister
  , onUpdateFound
  , module Workers.Service
  , module Aff.MessagePort
  , module Aff.Workers
  ) where


import Prelude                 (Unit, (<<<))

import Control.Monad.Aff       (Aff)
import Control.Monad.Eff       (Eff)
import Control.Monad.Eff.Class (liftEff)
import Data.Maybe              (Maybe(..))

import Aff.MessagePort         (onMessage, postMessage, postMessage')
import Aff.Workers             (WORKER, WorkerType(..), onError)
import Workers.Service         (Service, Registration, RegistrationOptions, State(..))
import Workers.Service          as W


-- SERVICE WORKER CONTAINER ~ navigator.serviceWorker globals

controller
  :: forall e
  .  Aff (worker :: WORKER | e) (Maybe Service)
controller =
  liftEff W.controller


getRegistration
  :: forall e
  .  Maybe String
  -> Aff (worker :: WORKER | e) (Maybe Registration)
getRegistration =
  W.getRegistration


onControllerChange
  :: forall e e'
  .  Eff ( | e') Unit
  -> Aff (worker :: WORKER | e) Unit
onControllerChange =
  liftEff <<< W.onControllerChange


ready
  :: forall e
  .  Aff (worker :: WORKER | e) Registration
ready =
  W.ready


register
  :: forall e
  .  String
  -> RegistrationOptions
  -> Aff (worker :: WORKER | e) Registration
register =
  W.register


startMessages
  :: forall e
  .  Aff (worker :: WORKER | e) Unit
startMessages =
  liftEff W.startMessages


-- SERVICE WORKER ~ instance methods

onStateChange
  :: forall e e'
  .  Service
  -> (State -> Eff ( | e') Unit)
  -> Aff (worker :: WORKER | e) Unit
onStateChange service =
  liftEff <<< W.onStateChange service


scriptURL
  :: Service
  -> String
scriptURL =
  W.scriptURL


state
  :: Service
  -> State
state =
  W.state


-- SERVICE WORKER REGISTRATION ~ instance method

active
  :: Registration
  -> Maybe Service
active =
  W.active


installing
  :: Registration
  -> Maybe Service
installing =
  W.installing


waiting
  :: Registration
  -> Maybe Service
waiting =
  W.waiting


scope
  :: Registration
  -> String
scope =
  W.scope


update
  :: forall e
  .  Registration
  -> Aff (worker :: WORKER | e) Unit
update =
  W.update


unregister
  :: forall e
  .  Registration
  -> Aff (worker :: WORKER | e) Boolean
unregister =
  W.unregister


onUpdateFound
  :: forall e e'
  .  Registration
  -> Eff ( | e') Unit
  -> Aff (worker :: WORKER | e) Unit
onUpdateFound registration =
  liftEff <<< W.onUpdateFound registration
