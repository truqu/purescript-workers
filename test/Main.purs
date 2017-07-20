module Test.Main where

import Prelude                     (Unit, bind, discard, pure, unit, (<*))
import Control.Monad.Aff           (Aff, launchAff)
import Control.Monad.Aff.AVar      (AVAR, makeVar, takeVar, putVar)
import Control.Monad.Eff           (Eff)
import Control.Monad.Eff.Class     (liftEff)
import Control.Monad.Eff.Exception (EXCEPTION, Error, name)
import Test.Spec                   (Spec, describe, it)
import Test.Spec.Assertions        (shouldEqual)
import Test.Spec.Mocha             (MOCHA, runMocha)

import Aff.MessagePort             (onMessage, postMessage)
import Aff.Workers                 (WORKER, Location(..), Navigator(..), new, onError)
import Aff.Workers.Dedicated       (DedicatedWorker, terminate)
import Aff.Workers.Shared          (SharedWorker, port)

it' :: forall e. String -> Eff ( | e) Unit -> Spec e Unit
it' str body =
  it str (liftEff body)


launchAff' :: forall a e. Aff e a -> Eff (exception :: EXCEPTION | e) Unit
launchAff' aff =
  pure unit <* (launchAff aff)


main :: forall e. Eff (mocha :: MOCHA, avar :: AVAR, worker :: WORKER, exception :: EXCEPTION | e) Unit
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
      Location loc <- takeVar var
      loc.pathname `shouldEqual` "/base/dist/karma/worker02.js"

    it "WorkerNavigator object" do
      var <- makeVar
      (worker :: DedicatedWorker) <- new "base/dist/karma/worker03.js"
      onMessage worker (\msg -> launchAff' do
        putVar var msg
      )
      postMessage worker unit
      Navigator nav <- takeVar var
      nav.onLine `shouldEqual` true

    it "Shared Workers Connect" do
      var <- makeVar
      (worker :: SharedWorker) <- new "base/dist/karma/worker04.js"
      onMessage (port worker) (\msg -> launchAff' do
        putVar var msg
      )
      (msg :: Boolean) <- takeVar var
      msg `shouldEqual` true

    it "Error Event - Handled by Worker" do
      var <- makeVar
      (worker :: DedicatedWorker) <- new "base/dist/karma/worker05.js"
      onMessage worker (\msg -> launchAff' do
        putVar var msg
      )
      msg <- takeVar var
      msg `shouldEqual` "Error"

    it "Error Event - Bubble to Parent" do
      var <- makeVar
      (worker :: DedicatedWorker) <- new "base/dist/karma/worker06.js"
      onError worker (\err -> launchAff' do
        putVar var err
      )
      (err :: Error) <- takeVar var
      (name err) `shouldEqual` "Error"

    it "Data Clone Error" do
      var <- makeVar
      (worker :: DedicatedWorker) <- new "base/dist/karma/worker07.js"
      onMessage worker (\msg -> launchAff' do
        putVar var msg
      )
      msg <- takeVar var
      msg `shouldEqual` "DataCloneError"

    it "Worker Terminate" do
      var <- makeVar
      (worker :: DedicatedWorker) <- new "base/dist/karma/worker01.js"
      onMessage worker (\msg -> launchAff' do
        terminate worker
        putVar var unit
      )
      postMessage worker "hello"
      msg <- takeVar var
      msg `shouldEqual` unit
