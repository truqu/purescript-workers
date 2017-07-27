module Test.Main where

import Prelude                     (Unit, bind, discard, pure, unit, (<*))
import Control.Monad.Aff           (Aff, launchAff, delay)
import Control.Monad.Aff.AVar      (AVAR, makeVar, takeVar, putVar)
import Control.Monad.Eff           (Eff)
import Control.Monad.Eff.Class     (liftEff)
import Control.Monad.Eff.Exception (EXCEPTION, Error, name)
import Test.Spec                   (Spec, describe, it)
import Test.Spec.Assertions        (shouldEqual, fail)
import Test.Spec.Mocha             (MOCHA, runMocha)
import Data.Time.Duration          (Milliseconds(..))
import Data.Maybe                  (Maybe(..))

import Test.Spec(itOnly)
import Control.Monad.Aff.Console(log)

import Aff.Workers                 (WORKER, Location(..), Navigator(..), WorkerType(..))
import Aff.Workers.Dedicated       (Dedicated)
import Aff.Workers.Shared          (Shared)

import Aff.MessagePort              as MessagePort
import Aff.Workers.Dedicated        as DedicatedWorker
import Aff.Workers.Shared           as SharedWorker
import Aff.Workers.Service          as ServiceWorker

it' :: forall e. String -> Eff ( | e) Unit -> Spec e Unit
it' str body =
  it str (liftEff body)


launchAff' :: forall a e. Aff e a -> Eff (exception :: EXCEPTION | e) Unit
launchAff' aff =
  pure unit <* (launchAff aff)


-- main :: forall e. Eff (mocha :: MOCHA, avar :: AVAR, worker :: WORKER, exception :: EXCEPTION | e) Unit
main = runMocha do
  describe "[Dedicated Worker] Basic" do
    it "Hello World" do
      var <- makeVar
      (worker :: Dedicated) <- DedicatedWorker.new "base/worker01.js"
      DedicatedWorker.onMessage worker (\msg -> launchAff' do
        putVar var msg
      )
      DedicatedWorker.postMessage worker "hello"
      msg <- takeVar var
      msg `shouldEqual` "world"

    it "WorkerLocation object" do
      var <- makeVar
      (worker :: Dedicated) <- DedicatedWorker.new "base/worker02.js"
      DedicatedWorker.onMessage worker (\msg -> launchAff' do
        putVar var msg
      )
      DedicatedWorker.postMessage worker unit
      Location loc <- takeVar var
      loc.pathname `shouldEqual` "/base/worker02.js"

    it "WorkerNavigator object" do
      var <- makeVar
      (worker :: Dedicated) <- DedicatedWorker.new "base/worker03.js"
      DedicatedWorker.onMessage worker (\msg -> launchAff' do
        putVar var msg
      )
      DedicatedWorker.postMessage worker unit
      Navigator nav <- takeVar var
      nav.onLine `shouldEqual` true

    it "Shared Worker Connect" do
      var <- makeVar
      (worker :: Shared) <- SharedWorker.new "base/worker04.js"
      MessagePort.onMessage (SharedWorker.port worker) (\msg -> launchAff' do
        putVar var msg
      )
      (msg :: Boolean) <- takeVar var
      msg `shouldEqual` true

    it "Error Event - Handled by Worker" do
      var <- makeVar
      (worker :: Dedicated) <- DedicatedWorker.new "base/worker05.js"
      DedicatedWorker.onMessage worker (\msg -> launchAff' do
        putVar var msg
      )
      msg <- takeVar var
      msg `shouldEqual` "Error"

    it "Error Event - Bubble to Parent" do
      var <- makeVar
      (worker :: Dedicated) <- DedicatedWorker.new "base/worker06.js"
      DedicatedWorker.onError worker (\err -> launchAff' do
        putVar var err
      )
      (err :: Error) <- takeVar var
      (name err) `shouldEqual` "Error"

    it "Data Clone Error" do
      var <- makeVar
      (worker :: Dedicated) <- DedicatedWorker.new "base/worker07.js"
      DedicatedWorker.onMessage worker (\msg -> launchAff' do
        putVar var msg
      )
      msg <- takeVar var
      msg `shouldEqual` "DataCloneError"

    it "Worker terminate" do
      var <- makeVar
      (worker :: Dedicated) <- DedicatedWorker.new "base/worker01.js"
      DedicatedWorker.onMessage worker (\msg -> launchAff' do
        DedicatedWorker.terminate worker
        putVar var unit
      )
      DedicatedWorker.postMessage worker "patate"
      msg <- takeVar var
      msg `shouldEqual` unit

    it "Service Worker - using get with source id" do
      var <- makeVar
      registration <- ServiceWorker.register "base/worker08.js"
      ServiceWorker.onMessage (\msg -> launchAff' do
        putVar var msg
      )
      worker <- ServiceWorker.wait
      ServiceWorker.postMessage worker "patate"
      msg <- takeVar var
      msg `shouldEqual` "PATATE"


    it "Service Worker - matching all clients" do
      var <- makeVar
      registration <- ServiceWorker.register "base/worker09.js"
      ServiceWorker.onMessage (\msg -> launchAff' do
        putVar var msg
      )
      worker <- ServiceWorker.wait
      ServiceWorker.postMessage worker "patate"
      msg <- takeVar var
      msg `shouldEqual` "PATATE"
