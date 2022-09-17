module UI.Powermenu where

import Data.GI.Base
import GI.Gtk

data PowermenuConfig = PowermenuConfig

powermenuNew :: PowermenuConfig -> IO Widget
powermenuNew _ = do
  container <- new Box [#orientation := OrientationHorizontal]
  lab <- new Label [#label := "powermenu"]

  #append container lab

  toWidget container
