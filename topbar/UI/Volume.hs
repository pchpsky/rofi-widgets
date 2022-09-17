module UI.Volume where

import Data.GI.Base
import GI.Gtk
import Prelude hiding (on)

data VolumeConfig = VolumeConfig

volume1 :: Prelude.Text
volume1 = "\61478"

volume2 :: Prelude.Text
volume2 = "\61479"

volume3 :: Prelude.Text
volume3 = "\61480"

volumeNew :: VolumeConfig -> IO Widget
volumeNew _ = do
  container <-
    new
      Box
      [ #orientation := OrientationHorizontal,
        #cssClasses := ["volume-container"]
      ]

  lab <- new Label [#label := volume3, #cssClasses := ["volume-icon"]]

  scale <- scaleNewWithRange OrientationHorizontal 0 100 1
  #addCssClass scale "volume-slider"

  revealer <-
    new
      Revealer
      [ revealerTransitionType := RevealerTransitionTypeSlideLeft,
        revealerTransitionDuration := 500,
        revealerChild := scale
      ]
  motionController <- new EventControllerMotion []

  on motionController #enter $ \_ _ -> do
    setRevealerRevealChild revealer True

  on motionController #leave $ do
    setRevealerRevealChild revealer False

  widgetAddController container motionController

  #append container lab
  #append container revealer

  toWidget container
