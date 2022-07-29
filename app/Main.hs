{-# LANGUAGE ExistentialQuantification #-}

module Main where

import MyWidgets
import Shelly
import Widget
import Prelude hiding (cycle, lines)

main :: IO ()
main = do
  putTextLn (toThemeStr MyWidgets.run)
  shelly runRun

runLauncher :: Sh ()
runLauncher = do
  setStdin $ toThemeStr MyWidgets.launcher
  run_
    "rofi"
    ["-no-lazy-grab", "-show", "drun", "-modi", "drun", "-theme", "/dev/stdin"]

runRun :: Sh ()
runRun = do
  setStdin $ toThemeStr MyWidgets.run
  run_
    "rofi"
    ["-no-lazy-grab", "-show", "run", "-modi", "run", "-theme", "/dev/stdin"]
