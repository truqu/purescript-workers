module Workers.Dedicated
  -- * Types
  ( Dedicated
  , terminate

  -- * Constructors
  , new
  , new'

  -- * Re-exports
  , module Workers
  , module MessagePort
  ) where

import Prelude           (Unit, show)

import Control.Monad.Eff (Eff)

import Workers           (WORKER, Credentials(..), Location, Navigator, Options, WorkerType(..), onError)
import MessagePort       (onMessage, onMessageError, postMessage, postMessage')
import Workers.Class     (class AbstractWorker, class MessagePort)


--------------------
-- TYPES
--------------------


foreign import data Dedicated :: Type


--------------------
-- METHODS
--------------------


-- | Returns a new Worker object. scriptURL will be fetched and executed in the background,
-- | creating a new global environment for which worker represents the communication channel.
new
  :: forall e
  .  String
  -> Eff (worker :: WORKER  | e) Dedicated
new url =
  _new url
    { name: ""
    , requestCredentials: (show Omit)
    , workerType: (show Classic)
    }


-- | Returns a new Worker object. scriptURL will be fetched and executed in the background,
-- | creating a new global environment for which worker represents the communication channel.
-- | options can be used to define the name of that global environment via the name option,
-- | primarily for debugging purposes. It can also ensure this new global environment supports
-- | JavaScript modules (specify type: "module"), and if that is specified, can also be used
-- | to specify how scriptURL is fetched through the credentials option
new'
  :: forall e
  .  String
  -> Options
  -> Eff (worker :: WORKER | e) Dedicated
new' url opts =
  _new url
    { name: opts.name
    , requestCredentials: (show opts.requestCredentials)
    , workerType: (show opts.workerType)
    }


-- | Aborts worker’s associated global environment.
terminate
  :: forall e
  .  Dedicated
  -> Eff (worker :: WORKER | e) Unit
terminate =
  _terminate


--------------------
-- INSTANCES
--------------------


instance abstractWorkerDedicated :: AbstractWorker Dedicated where
  abstractWorkerConstructor _ =
    "Dedicated"


instance messagePortDedicated :: MessagePort Dedicated where
  messagePortConstructor _ =
    "Dedicated"


--------------------
-- FFI
--------------------


foreign import _new
  :: forall e
  .  String
  -> { name :: String, requestCredentials :: String, workerType :: String }
  -> Eff (worker :: WORKER | e) Dedicated


foreign import _terminate
  :: forall e
  .  Dedicated
  -> Eff (worker :: WORKER | e) Unit
