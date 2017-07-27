module Workers.Shared
  -- * Types
  ( Shared
  , port

  -- * Constructors
  , new
  , new'

  -- * Re-Exports
  , module Workers
  , module MessagePort
  ) where

import Prelude           (show)

import Control.Monad.Eff (Eff)

import MessagePort       (MessagePort, close, start, onMessage, onMessageError)
import Workers           (WORKER, Credentials(..), Location, Navigator, Options, WorkerType(..), onError, postMessage, postMessage')
import Workers.Class     (class AbstractWorker)


--------------------
-- TYPES
--------------------


foreign import data Shared :: Type


--------------------
-- METHODS
--------------------


-- | Returns a new Worker object. scriptURL will be fetched and executed in the background,
-- | creating a new global environment for which worker represents the communication channel.
new
  :: forall e
  .  String
  -> Eff (worker :: WORKER  | e) Shared
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
  -> Eff (worker :: WORKER | e) Shared
new' url opts =
  _new url
    { name: opts.name
    , requestCredentials: (show opts.requestCredentials)
    , workerType: (show opts.workerType)
    }


-- | Returns sharedWorker’s MessagePort object which can be used
-- | to communicate with the global environment.
port
  :: Shared
  -> MessagePort
port =
  _port


--------------------
-- INSTANCES
--------------------


instance abstractWorkerShared :: AbstractWorker Shared


--------------------
-- FFI
--------------------


foreign import _new
  :: forall e
  .  String
  -> { name :: String, requestCredentials :: String, workerType :: String }
  -> Eff (worker :: WORKER | e) Shared


foreign import _port
  :: Shared
  -> MessagePort
