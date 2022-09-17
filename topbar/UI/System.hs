module UI.System where

import Data.GI.Base
import GI.Gtk

data SystemConfig = SystemConfig

systemNew :: SystemConfig -> IO Widget
systemNew _ = do
  container <- new Box [#orientation := OrientationHorizontal]
  lab <- new Label [#label := "system"]

  #append container lab

  toWidget container
