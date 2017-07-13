module ApplicationCache
  ( APPCACHE
  , ApplicationCache
  , Status(..)
  , abort
  , status
  , update
  , swapCache
  ) where

import Prelude

import Control.Monad.Eff(kind Effect, Eff)


foreign import data APPCACHE :: Effect


foreign import data ApplicationCache :: Type


data Status
  = Uncached
  | Idle
  | Checking
  | Downloading
  | UpdateReady
  | Obsolete


type StatusRec =
  { uncached    :: Status
  , idle        :: Status
  , checking    :: Status
  , downloading :: Status
  , updateReady :: Status
  , obsolete    :: Status
  }


foreign import abort
  :: forall e
  .  ApplicationCache
  -> Eff (appcache :: APPCACHE | e) Unit


status
  :: ApplicationCache
  -> Status
status =
  _status { uncached    : Uncached
          , idle        : Idle
          , checking    : Checking
          , downloading : Downloading
          , updateReady : UpdateReady
          , obsolete    : Obsolete
          }


foreign import _status
  :: StatusRec
  -> ApplicationCache
  -> Status


foreign import swapCache
  :: forall e
  .  ApplicationCache
  -> Eff (appcache :: APPCACHE | e) Unit


foreign import update
  :: forall e
  .  ApplicationCache
  -> Eff (appcache :: APPCACHE | e) Unit
