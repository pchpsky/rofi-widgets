module UI.Clock where

import Data.GI.Base
import GI.Gtk

data ClockConfig = ClockConfig

clockNew :: ClockConfig -> IO Widget
clockNew _ = do
  container <- new Box [#orientation := OrientationHorizontal]
  lab <- new Label [#label := "clock"]

  #append container lab

  toWidget container
