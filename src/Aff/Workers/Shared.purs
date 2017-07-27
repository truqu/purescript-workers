module Aff.Workers.Shared
  ( port
  , new
  , new'
  , module Workers.Shared
  , module Aff.MessagePort
  , module Aff.Workers
  ) where

import Prelude                 ((<<<))

import Control.Monad.Aff       (Aff)
import Control.Monad.Eff.Class (liftEff)

import Aff.MessagePort         (MessagePort, close, start, onMessage, onMessageError, postMessage, postMessage')
import Aff.Workers             (WORKER, Credentials(..), Location, Navigator, Options, WorkerType(..), onError)
import Workers.Shared           as W
import Workers.Shared          (Shared)


-- | Returns a new Worker object. scriptURL will be fetched and executed in the background,
-- | creating a new global environment for which worker represents the communication channel.
new
  :: forall e
  .  String
  -> Aff (worker :: WORKER  | e) Shared
new =
  liftEff <<< W.new


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
  -> Aff (worker :: WORKER | e) Shared
new' url =
  liftEff <<< W.new' url


-- | Aborts worker’s associated global environment.
port
  :: Shared
  -> MessagePort
port =
  W.port
