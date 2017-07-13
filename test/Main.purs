module Test.Main where

import Prelude
import Control.Monad.Aff           (Aff, launchAff)
import Control.Monad.Aff.Console   (log)
import Control.Monad.Aff.AVar      (makeVar, takeVar, putVar)
import Control.Monad.Eff           (Eff)
import Control.Monad.Eff.Exception (EXCEPTION, message)
import Control.Monad.Eff.Class     (liftEff)
import Data.Either                 (Either(..))
import Data.Enum                   (toEnum)
import Data.Maybe                  (Maybe(..), isNothing, maybe)
import Test.Spec                   (Spec, describe, describeOnly, it)
import Test.Spec.Assertions        (shouldEqual, fail)
import Test.Spec.Mocha             (MOCHA, runMocha)

import Aff.Workers.Dedicated


it' :: forall e. String -> Eff ( | e) Unit -> Spec e Unit
it' str body =
  it str (liftEff body)


launchAff' :: forall a e. Aff e a -> Eff (exception :: EXCEPTION | e) Unit
launchAff' aff =
  pure unit <* (launchAff aff)


--main :: forall e. Eff (console :: CONSOLE | e) Unit
main = runMocha do
  describe "[Dedicated Worker] Basic" do
    it "Hello World" do
      var <- makeVar
      (worker :: DedicatedWorker) <- new "base/dist/karma/worker01.js"
      onMessage worker (\msg -> launchAff' do
        putVar var msg
      )
      postMessage worker "hello"
      msg <- takeVar var
      msg `shouldEqual` "world"

    it "WorkerLocation object" do
      var <- makeVar
      (worker :: DedicatedWorker) <- new "base/dist/karma/worker02.js"
      onMessage worker (\msg -> launchAff' do
        putVar var msg
      )
      postMessage worker unit
      (loc :: Location) <- takeVar var
      loc.pathname `shouldEqual` "/base/dist/karma/worker02.js"
