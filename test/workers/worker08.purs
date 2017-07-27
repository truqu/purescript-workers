module Test.Workers.Worker08 where

import Prelude

import Control.Monad.Eff           (Eff)
import Control.Monad.Eff.Exception (EXCEPTION)
import Control.Monad.Eff.Class     (liftEff)
import Control.Monad.Aff           (Aff)
import Data.Maybe                  (Maybe(..))
import Data.String                 (toUpper)

import Workers                     (WORKER, postMessage)
import GlobalScope.Service         (ClientId, clients, claim, get, onActivate, onMessage)


main :: forall e. Eff (worker :: WORKER, exception :: EXCEPTION | e) Unit
main = do
  onMessage  onMessageHandler
  onActivate onActivateHandler


onMessageHandler :: ClientId -> String -> Aff (worker :: WORKER, exception :: EXCEPTION) Unit
onMessageHandler cid msg = do
  mclient <- (liftEff clients) >>= flip get cid
  case mclient of
    Nothing     -> pure unit
    Just client -> liftEff $ postMessage client (toUpper msg)


onActivateHandler :: Aff (worker :: WORKER) Unit
onActivateHandler =
  liftEff clients >>= claim
