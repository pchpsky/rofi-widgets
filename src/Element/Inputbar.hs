module Element.Inputbar where

import Element
import Property

newtype Inputbar = Inputbar [Property]

instance IsElement Inputbar where
  name _ = "inputbar"
  props (Inputbar p) = p
  updateProps f (Inputbar p) = Inputbar $ f p

inputbar :: Inputbar
inputbar = Inputbar []

instance HasChildren Inputbar

instance HasTextColor Inputbar

instance HasExpand Inputbar
