module Aff.Workers
  ( class AbstractWorkerAff, onError, new, new'
  , module Workers
  ) where

import Prelude

import Control.Monad.Aff(Aff)
import Control.Monad.Eff(Eff)
import Control.Monad.Eff.Class(liftEff)
import Control.Monad.Eff.Exception(Error)

import Workers as W
import Workers (WORKER, Location(..), Navigator(..), WorkerOptions, WorkerType(..), Credentials(..),
SharedWorker, DedicatedWorker)

class AbstractWorkerAff worker where
  -- | Event handler for the `error` event.
  onError
    :: forall e e'
    .  worker
    -> (Error -> Eff ( | e') Unit)
    -> Aff (worker :: WORKER | e) Unit

  -- | Returns a new Worker object. scriptURL will be fetched and executed in the background,
  -- | creating a new global environment for which worker represents the communication channel.
  new
    :: forall e
    .  String
    -> Aff (worker :: WORKER  | e) worker

  -- | Returns a new Worker object. scriptURL will be fetched and executed in the background,
  -- | creating a new global environment for which worker represents the communication channel.
  -- | options can be used to define the name of that global environment via the name option,
  -- | primarily for debugging purposes. It can also ensure this new global environment supports
  -- | JavaScript modules (specify type: "module"), and if that is specified, can also be used
  -- | to specify how scriptURL is fetched through the credentials option
  new'
    :: forall e
    .  String
    -> WorkerOptions
    -> Aff (worker :: WORKER | e) worker


instance abstractWorkerDedicatedAff :: AbstractWorkerAff DedicatedWorker where
  onError w = liftEff <<< W.onError w
  new       = liftEff <<< W.new
  new' url  = liftEff <<< W.new' url


instance abstractWorkerSharedAff :: AbstractWorkerAff SharedWorker where
  onError w = liftEff <<< W.onError w
  new       = liftEff <<< W.new
  new' url  = liftEff <<< W.new' url
