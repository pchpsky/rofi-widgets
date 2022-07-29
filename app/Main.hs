{-# LANGUAGE ExistentialQuantification #-}

module Main where

import MyWidgets
import Shelly
import Widget
import Prelude hiding (cycle, lines)

main :: IO ()
main = do
  putTextLn (toThemeStr launcher)
  shelly runLauncher

runLauncher :: Sh ()
runLauncher = do
  setStdin $ toThemeStr launcher
  run_
    "rofi"
    ["-no-lazy-grab", "-show", "drun", "-modi", "drun", "-theme", "/dev/stdin"]
