module Element.Mainbox where

import Element
import Property

newtype Mainbox = Mainbox [Property]

instance IsElement Mainbox where
  name _ = "mainbox"
  props (Mainbox p) = p
  updateProps f (Mainbox p) = Mainbox $ f p

mainbox :: Mainbox
mainbox = Mainbox []

instance HasSpacing Mainbox

instance HasChildren Mainbox
