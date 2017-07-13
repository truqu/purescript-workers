module Aff.ApplicationCache
  ( module ApplicationCache
  ) where

import Prelude

import Control.Monad.Aff           (Aff)
import Control.Monad.Eff           (Eff)
import Control.Monad.Eff.Class     (liftEff)
import Control.Monad.Eff.Exception (Error)

import ApplicationCache             as A
import ApplicationCache            (APPCACHE, ApplicationCache, Status(..), status)


abort
  :: forall e
  .  ApplicationCache
  -> Aff (appcache :: APPCACHE | e) Unit
abort =
  liftEff <<< A.abort


swapCache
  :: forall e
  .  ApplicationCache
  -> Aff (appcache :: APPCACHE | e) Unit
swapCache =
  liftEff <<< A.swapCache


update
  :: forall e
  .  ApplicationCache
  -> Aff (appcache :: APPCACHE | e) Unit
update =
  liftEff <<< A.update
