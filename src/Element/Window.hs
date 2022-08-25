{-# LANGUAGE RankNTypes #-}

module Element.Window where

import Element
import Property
import Widget

newtype Window = Window [Property]

instance IsElement Window where
  name = const "window"
  props (Window p) = p
  updateProps f (Window p) = Window $ f p

instance HasTransparency Window

instance HasTextColor Window

instance HasWidth Window

instance HasHeight Window

instance HasExpand Window

window :: ElementBuilder Window
window = buildElement $ Window []

location :: Location -> Window -> Window
location = prop "location"

anchor :: Location -> Window -> Window
anchor = prop "anchor"
