module Test.Workers.Worker04 where

import Prelude

import Control.Monad.Eff          (Eff)
import Data.NonEmpty              (head)

import Workers.GlobalScope.Shared (onConnect)
import Workers.MessagePort        (postMessage)

-- | Shared Worker working through a port
main = onConnect $ \ports -> postMessage (head ports) true
