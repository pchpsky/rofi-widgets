module UI.Volume where

import Control.Concurrent (forkIO, killThread)
import qualified Control.Foldl as Fold
import Data.GI.Base
import Data.Maybe (fromJust)
import Data.Text (isInfixOf, isPrefixOf, isSuffixOf, stripPrefix, stripStart, stripSuffix)
import Debounce (mkDebouncedAction)
import GI.Gtk
import Relude.Unsafe (at)
import Shelly (run, shelly)
import Turtle (foldIO, inshell, lineToText)
import Prelude hiding (isPrefixOf, on)

data VolumeConfig = VolumeConfig

volumeLabel :: Prelude.Text
volumeLabel = "\61480"

data Volume = Volume {volumeLevel :: Integer, volumeOn :: Bool} deriving (Show)

readAmixerVolume :: Prelude.Text -> Volume
readAmixerVolume amixerOut =
  let channels = filter (isPrefixOf "Front") . fmap stripStart $ lines amixerOut
      channels' = fmap (fromJust . (stripPrefix "[" >=> stripSuffix "]")) . filter (isSuffixOf "]") . filter (isPrefixOf "[") . words <$> channels
      level = foldr max 0 . fmap ((fromJust . ((readMaybe . toString) <=< stripSuffix "%")) . at 0) $ channels'
      isOn = isJust . find (== "on") . fmap (at 1) $ channels'
   in Volume level isOn

currentVolume :: IO Volume
currentVolume = shelly $ do
  out <- run "amixer" ["get", "Master"]
  return $ readAmixerVolume out

volumeNew :: VolumeConfig -> IO Widget
volumeNew _ = do
  container <-
    new
      Box
      [ #orientation := OrientationHorizontal,
        #cssClasses := ["volume-container"]
      ]

  lab <- new Label [#label := volumeLabel, #cssClasses := ["volume-icon"]]

  scale <- scaleNewWithRange OrientationHorizontal 0 100 1
  let setVolLevel = do
        vol <- currentVolume
        rangeSetValue scale (fromInteger $ volumeLevel vol)
  setVolLevel
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

  on container #realize $ do
    thread <- forkIO $ do
      updateVolume <- mkDebouncedAction 50000 setVolLevel
      let onEvent message = when (("sink" `isInfixOf` lineToText message) || ("source-output" `isInfixOf` lineToText message)) updateVolume
      foldIO (inshell "pactl subscribe" mempty) (Fold.mapM_ onEvent)
    void $ onWidgetUnrealize container (killThread thread)

  toWidget container
