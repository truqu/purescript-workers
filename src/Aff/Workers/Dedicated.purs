module Aff.Workers.Dedicated
  ( new
  , new'
  , terminate
  , onMessage
  , onMessageError
  , module Workers.Dedicated
  , module Aff.Workers
  ) where


import Prelude                     (Unit, (<<<))

import Control.Monad.Aff           (Aff)
import Control.Monad.Eff           (Eff)
import Control.Monad.Eff.Exception (Error)
import Control.Monad.Eff.Class     (liftEff)

import Aff.Workers                 (WORKER, Credentials(..), Location, Navigator, Options, WorkerType(..), onError, postMessage, postMessage')
import Workers.Dedicated           (Dedicated)
import Workers.Dedicated            as W



-- | Returns a new Worker object. scriptURL will be fetched and executed in the background,
-- | creating a new global environment for which worker represents the communication channel.
new
  :: forall e
  .  String
  -> Aff (worker :: WORKER  | e) Dedicated
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
  -> Aff (worker :: WORKER | e) Dedicated
new' url =
  liftEff <<< W.new' url


-- | Aborts worker’s associated global environment.
terminate
  :: forall e
  .  Dedicated
  -> Aff (worker :: WORKER | e) Unit
terminate =
  liftEff <<< W.terminate


-- | Event handler for the `message` event
onMessage
  :: forall e e' msg
  .  Dedicated
  -> (msg -> Eff ( | e') Unit)
  -> Aff (worker :: WORKER | e) Unit
onMessage p =
  liftEff <<< W.onMessage p


-- | Event handler for the `messageError` event
onMessageError
  :: forall e e'
  .  Dedicated
  -> (Error -> Eff ( | e') Unit)
  -> Aff (worker :: WORKER | e) Unit
onMessageError p =
  liftEff <<< W.onMessageError p
