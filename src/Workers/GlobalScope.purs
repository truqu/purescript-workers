module Workers.GlobalScope where

import Prelude

import Control.Monad.Eff(Eff)
import Control.Monad.Eff.Exception(Error)

import Workers(WORKER, Location, Navigator)


foreign import location
  :: forall e
  .  Eff (worker :: WORKER | e) Location


foreign import navigator
  :: forall e
  .  Eff (worker :: WORKER | e) Navigator


foreign import close
  :: forall e
  . Eff (worker :: WORKER | e) Unit


foreign import onError
  :: forall e e'
  .  (Error -> Eff ( | e') Unit)
  -> Eff (worker :: WORKER | e) Unit


foreign import onLanguageChange
  :: forall e e'
  .  Eff ( | e') Unit
  -> Eff (worker :: WORKER | e) Unit


foreign import onOffline
  :: forall e e'
  .  Eff ( | e') Unit
  -> Eff (worker :: WORKER | e) Unit


foreign import onOnline
  :: forall e e'
  .  Eff ( | e') Unit
  -> Eff (worker :: WORKER | e) Unit


foreign import onRejectionHandled
  :: forall e e'
  .  Eff ( | e') Unit
  -> Eff (worker :: WORKER | e) Unit


foreign import onUnhandledRejection
  :: forall e e'
  .  Eff ( | e') Unit
  -> Eff (worker :: WORKER | e) Unit
