module Aff.ApplicationCache
  ( abort
  , swapCache
  , update
  , module ApplicationCache
  ) where

import Prelude

import Control.Monad.Aff           (Aff)
import Control.Monad.Eff.Class     (liftEff)

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
