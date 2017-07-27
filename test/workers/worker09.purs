module Test.Workers.Worker09 where

import Prelude

import Control.Monad.Eff           (Eff, foreachE)
import Control.Monad.Eff.Exception (EXCEPTION)
import Control.Monad.Eff.Class     (liftEff)
import Control.Monad.Aff           (Aff)
import Data.String                 (toUpper)

import Workers                     (WORKER, postMessage)
import GlobalScope.Service         (ClientId, clients, claim, matchAll, onActivate, onMessage)


main :: forall e. Eff (worker :: WORKER, exception :: EXCEPTION | e) Unit
main = do
  onMessage  onMessageHandler
  onActivate onActivateHandler


onMessageHandler :: ClientId -> String -> Aff (worker :: WORKER, exception :: EXCEPTION) Unit
onMessageHandler _ msg =
  liftEff clients
  >>= matchAll
  >>= forEachA (\client -> postMessage client (toUpper msg))


onActivateHandler :: Aff (worker :: WORKER) Unit
onActivateHandler =
  liftEff clients >>= claim


forEachA :: forall e a. (a -> Eff e Unit) -> (Array a) -> (Aff e Unit)
forEachA f xs =
  liftEff (foreachE xs f)
