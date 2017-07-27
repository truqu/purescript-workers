module Workers.Service
  -- * Constructors & Setup
  ( Registration
  , RegistrationOptions
  , controller
  , getRegistration
  , onControllerChange
  , onMessage'
  , ready
  , register
  , register'
  , startMessages
  , wait

  -- * Service Worker Manipulations
  , State(..)
  , Service
  , onStateChange
  , scriptURL
  , state

  -- * Registration Manipulations
  , active
  , installing
  , waiting
  , scope
  , update
  , unregister
  , onUpdateFound

  -- * Re-exports
  , module MessagePort
  , module Workers
  ) where

import Prelude

import Control.Monad.Aff       (Aff, delay)
import Control.Monad.Eff       (Eff)
import Control.Monad.Eff.Class (liftEff)
import Data.Maybe              (Maybe(..))
import Data.Nullable           (Nullable, toMaybe, toNullable)
import Data.String.Read        (class Read, read)
import Data.Time.Duration      (Milliseconds(Milliseconds))

import MessagePort             (postMessage, postMessage', onMessage)
import Workers                 (WORKER, WorkerType(..), onError)
import Workers.Class           (class AbstractWorker, class MessagePort)


--------------------
-- TYPES
--------------------


foreign import data Service :: Type


foreign import data Registration :: Type


type RegistrationOptions =
  { scope      :: String
  , workerType :: WorkerType
  }


data State
  = Installing
  | Installed
  | Activating
  | Activated
  | Redundant


--------------------
-- METHODS
--------------------

-- SERVICE WORKER CONTAINER ~ navigator.serviceWorker globals

controller
  :: forall e
  .  Eff (worker :: WORKER | e) (Maybe Service)
controller =
  toMaybe <$> _controller


getRegistration
  :: forall e
  .  Maybe String
  -> Aff (worker :: WORKER | e) (Maybe Registration)
getRegistration =
    toNullable >>> _getRegistration >=> toPureMaybe
  where
    toPureMaybe = toMaybe >>> pure


onControllerChange
  :: forall e e'
  .  Eff ( | e') Unit
  -> Eff (worker :: WORKER | e) Unit
onControllerChange =
    _onControllerChange


onMessage'
 :: forall e e' msg
 .  (msg -> Eff ( | e') Unit)
 -> Eff (worker :: WORKER | e) Unit
onMessage' =
  _onMessage


ready
  :: forall e
  .  Aff (worker :: WORKER | e) Registration
ready =
  _ready


register
  :: forall e
  .  String
  -> Aff (worker :: WORKER | e) Registration
register url =
  _register url
    { scope: ""
    , workerType: Classic
    }


register'
  :: forall e
  .  String
  -> RegistrationOptions
  -> Aff (worker :: WORKER | e) Registration
register' =
  _register


startMessages
  :: forall e
  .  Eff (worker :: WORKER | e) Unit
startMessages =
  _startMessages


wait
  :: forall e
  .  Aff (worker :: WORKER | e) Service
wait = do
  mworker <- liftEff controller
  case mworker of
    Nothing -> do
      delay (Milliseconds 50.0)
      wait
    Just worker -> do
      pure worker


-- SERVICE WORKER ~ instance methods

onStateChange
  :: forall e e'
  .  Service
  -> (State -> Eff ( | e') Unit)
  -> Eff (worker :: WORKER | e) Unit
onStateChange =
  _onStateChange (read >>> toNullable)


scriptURL
  :: Service
  -> String
scriptURL =
  _scriptURL


state
  :: Service
  -> State
state =
  _state (read >>> toNullable)


-- SERVICE WORKER REGISTRATION ~ instance method

active
  :: Registration
  -> Maybe Service
active =
  _active >>> toMaybe


installing
  :: Registration
  -> Maybe Service
installing =
  _installing >>> toMaybe


waiting
  :: Registration
  -> Maybe Service
waiting =
  _waiting >>> toMaybe


scope
  :: Registration
  -> String
scope =
  _scope


update
  :: forall e
  .  Registration
  -> Aff (worker :: WORKER | e) Unit
update =
  _update


unregister
  :: forall e
  .  Registration
  -> Aff (worker :: WORKER | e) Boolean
unregister =
  _unregister


onUpdateFound
  :: forall e e'
  .  Registration
  -> Eff ( | e') Unit
  -> Eff (worker :: WORKER | e) Unit
onUpdateFound =
  _onUpdateFound


--------------------
-- INSTANCES
--------------------


instance abstractWorkerService :: AbstractWorker Service where
  abstractWorkerConstructor _ =
    "Service"


instance messagePortService :: MessagePort Service where
  messagePortConstructor _ =
    "Service"


instance showState :: Show State where
  show s =
    case s of
      Installing -> "installing"
      Installed  -> "installed"
      Activating -> "activating"
      Activated  -> "activated"
      Redundant  -> "redundant"


instance readState :: Read State where
  read s =
    case s of
      "installing" -> pure Installing
      "installed"  -> pure Installed
      "activating" -> pure Activating
      "activated"  -> pure Activated
      "redundant"  -> pure Redundant
      _            -> Nothing


--------------------
-- FFI
--------------------


foreign import _controller
  :: forall e
  .  Eff (worker :: WORKER | e) (Nullable Service)


foreign import _getRegistration
  :: forall e
  .  Nullable String
  -> Aff (worker :: WORKER | e) (Nullable Registration)


foreign import _onControllerChange
  :: forall e e'
  .  Eff ( | e') Unit
  -> Eff (worker :: WORKER | e) Unit


foreign import _onMessage
  :: forall e e' msg
  .  (msg -> Eff ( | e') Unit)
  -> Eff (worker :: WORKER | e) Unit


foreign import _ready
  :: forall e
  .  Aff (worker :: WORKER | e) Registration


foreign import _register
  :: forall e
  .  String
  -> RegistrationOptions
  -> Aff (worker :: WORKER | e) Registration


foreign import _startMessages
  :: forall e
  .  Eff (worker :: WORKER | e) Unit


foreign import _onStateChange
  :: forall e e'
  .  (String -> Nullable State)
  ->  Service
  -> (State -> Eff ( | e') Unit)
  -> Eff (worker :: WORKER | e) Unit


foreign import _scriptURL
  :: Service
  -> String


foreign import _state
  :: (String -> Nullable State)
  -> Service
  -> State


foreign import _active
  :: Registration
  -> Nullable Service


foreign import _installing
  :: Registration
  -> Nullable Service


foreign import _waiting
  :: Registration
  -> Nullable Service


foreign import _scope
  :: Registration
  -> String


foreign import _update
  :: forall e
  .  Registration
  -> Aff (worker :: WORKER | e) Unit


foreign import _unregister
  :: forall e
  .  Registration
  -> Aff (worker :: WORKER | e) Boolean


foreign import _onUpdateFound
  :: forall e e'
  .  Registration
  -> Eff ( | e') Unit
  -> Eff (worker :: WORKER | e) Unit
