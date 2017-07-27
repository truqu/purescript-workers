module Workers.Service
  --( class ServiceWorkerEff, register, controller, ready, getRegistration, startMessages, state, onStateChange, onControllerChange
  --, class ServiceWorkerRegistrationEff, installing, waiting, active, scope, update, unregister, onUpdateFound
  ( RegistrationOptions
  , State(..)
  , module Workers
  , module MessagePort
  ) where

import Prelude

import Data.Maybe        (Maybe)
import Control.Monad.Eff (Eff)
import Control.Monad.Aff (Aff)
import Data.Nullable     (Nullable, toMaybe, toNullable)

import Workers           (WORKER, Service, WorkerType(..), onError)
import MessagePort       (postMessage, postMessage')


-- class (AbstractWorkerEff worker, MessagePortEff worker, ServiceWorkerRegistrationEff registration) <= ServiceWorkerEff worker where
--  startMessages
--    :: Eff (worker :: WORKER | e) Unit
--
--  state
--    :: worker
--    -> State
--
--  onStateChange
--    :: forall e e'
--    .  (State -> Eff ( | e') Unit)
--    -> Eff (worker :: WORKER | e) Unit
--
--  onControllerChange
--    :: forall e e'
--    .  Eff ( | e') Unit
--    -> Eff (worker :: WORKER | e) Unit


-- class (ServiceWorkerEff worker) <= ServiceWorkerRegistrationEff  registration where
--   installing
--     :: registration
--     -> Maybe worker
--
--   waiting
--     :: registration
--     -> Maybe worker
--
--   active
--     :: registration
--     -> Maybe worker
--
--   scope
--     :: registration
--     -> String
--
--   update
--     :: forall e
--     .  registration
--     -> Aff (worker :: WORKER | e) Unit
--
--   unregister
--     :: forall e
--     .  registration
--     -> Aff (worker :: WORKER | e) Boolean
--
--   onUpdateFound
--     :: forall e e'
--     .  registration
--     -> Eff ( | e') Unit
--     -> Eff (worker :: WORKER | e) Unit


--------------------
-- TYPES
--------------------

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


ready
  :: forall e
  .  Aff (worker :: WORKER | e) Registration
ready =
  _ready


register
  :: forall e
  .  String
  -> RegistrationOptions
  -> Aff (worker :: WORKER | e) Registration
register =
  _register


--------------------
-- INSTANCES
--------------------


instance showState :: Show State where
  show s =
    case s of
      Installing -> "installing"
      Installed  -> "installed"
      Activating -> "activating"
      Activated  -> "activated"
      Redundant  -> "redundant"


--------------------
-- FFI
--------------------


foreign import _register
  :: forall e
  .  String
  -> RegistrationOptions
  -> Aff (worker :: WORKER | e) Registration


foreign import _controller
  :: forall e
  .  Eff (worker :: WORKER | e) (Nullable Service)


foreign import _ready
  :: forall e
  .  Aff (worker :: WORKER | e) Registration


foreign import _getRegistration
  :: forall e
  .  Nullable String
  -> Aff (worker :: WORKER | e) (Nullable Registration)
