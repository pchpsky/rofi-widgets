module Element.Entry where

import Element
import Property
import Widget

newtype Entry = Entry [Property]

instance IsElement Entry where
  name _ = "entry"
  props (Entry p) = p
  updateProps f (Entry p) = Entry $ f p

entry :: ElementBuilder Entry
entry = buildElement (Entry [])

instance HasTextColor Entry

instance HasPlaceholder Entry

instance HasExpand Entry

instance HasAlign Entry

instance HasBlink Entry
