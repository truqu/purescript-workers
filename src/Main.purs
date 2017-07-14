module Main where

import Prelude
import Workers.Shared
import Control.Monad.Eff.Console(log)

main = do
  worker :: SharedWorker <- new "worker.js"
  onMessage (port worker) $ \msg -> do
    log "On Message"
    log msg

  start (port worker)
