module Debounce where

import Control.Concurrent
import Prelude hiding (newEmptyMVar, takeMVar, tryPutMVar, tryTakeMVar)

mkDebouncedAction delay action = do
  baton <- newEmptyMVar
  void $
    forkIO $
      forever $ do
        takeMVar baton
        threadDelay delay
        void $ tryTakeMVar baton
        action
  return $ void $ tryPutMVar baton ()
