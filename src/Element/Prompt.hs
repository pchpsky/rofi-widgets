module Element.Prompt where

import Element
import Property

newtype Prompt = Prompt [Property]

instance IsElement Prompt where
  name _ = "prompt"
  props (Prompt p) = p
  updateProps f (Prompt p) = Prompt $ f p

prompt :: Prompt
prompt = Prompt []

instance HasTextColor Prompt
