module Element.Prompt where

import Element
import Property
import Widget

newtype Prompt = Prompt [Property]

instance IsElement Prompt where
  name _ = "prompt"
  props (Prompt p) = p
  updateProps f (Prompt p) = Prompt $ f p

prompt :: ElementBuilder Prompt
prompt = buildElement $ Prompt []

instance HasTextColor Prompt
