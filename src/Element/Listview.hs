module Element.Listview where

import Element
import Property
import Widget

newtype Listview = Listview [Property]

instance IsElement Listview where
  name _ = "listview"
  props (Listview p) = p
  updateProps f (Listview p) = Listview $ f p

instance HasSpacing Listview

instance HasTextColor Listview

listview :: ElementBuilder Listview
listview = buildElement $ Listview []

columns :: Integer -> Listview -> Listview
columns = prop "columns"

lines :: Integer -> Listview -> Listview
lines = prop "lines"

layout :: Orientation -> Listview -> Listview
layout = prop "layout"

fixedColumns :: Bool -> Listview -> Listview
fixedColumns = prop "fixed-columns"

fixedHeight :: Bool -> Listview -> Listview
fixedHeight = prop "fixed-height"

cycle :: Bool -> Listview -> Listview
cycle = prop "cycle"

data ListviewElement
  = ListviewElement [Property]
  | ListviewElementSelected [Property]
  | ListviewElementSelectedNormal [Property]
  | ListviewElementNormalNormal [Property]

instance IsElement ListviewElement where
  name (ListviewElement _) = "element"
  name (ListviewElementSelected _) = "element selected"
  name (ListviewElementSelectedNormal _) = "element selected.normal"
  name (ListviewElementNormalNormal _) = "element normal.normal"

  props (ListviewElement p) = p
  props (ListviewElementSelected p) = p
  props (ListviewElementSelectedNormal p) = p
  props (ListviewElementNormalNormal p) = p

  updateProps f (ListviewElement p) = ListviewElement $ f p
  updateProps f (ListviewElementSelected p) = ListviewElementSelected $ f p
  updateProps f (ListviewElementSelectedNormal p) = ListviewElementSelectedNormal $ f p
  updateProps f (ListviewElementNormalNormal p) = ListviewElementNormalNormal $ f p

instance HasTextColor ListviewElement

instance HasSpacing ListviewElement

instance HasHeight ListviewElement

element :: ElementBuilder ListviewElement
element = buildElement $ ListviewElement []

elementSelected :: ElementBuilder ListviewElement
elementSelected = buildElement $ ListviewElementSelected []

elementSelectedNormal :: ElementBuilder ListviewElement
elementSelectedNormal = buildElement $ ListviewElementSelectedNormal []

elementNormalNormal :: ElementBuilder ListviewElement
elementNormalNormal = buildElement $ ListviewElementNormalNormal []

orientation :: Orientation -> ListviewElement -> ListviewElement
orientation = prop "orientation"

newtype ListviewIcon = ListviewIcon [Property]

instance IsElement ListviewIcon where
  name _ = "element-icon"
  props (ListviewIcon p) = p
  updateProps f (ListviewIcon p) = ListviewIcon $ f p

instance HasTextColor ListviewIcon

instance HasAlign ListviewIcon

elementIcon :: ElementBuilder ListviewIcon
elementIcon = buildElement $ ListviewIcon []

size :: Distance -> ListviewIcon -> ListviewIcon
size = prop "size"

newtype ListviewText = ListviewText [Property]

instance IsElement ListviewText where
  name _ = "element-text"
  props (ListviewText p) = p
  updateProps f (ListviewText p) = ListviewText $ f p

instance HasTextColor ListviewText

instance HasExpand ListviewText

instance HasAlign ListviewText

instance HasFont ListviewText

elementText :: ElementBuilder ListviewText
elementText = buildElement $ ListviewText []

newtype Scrollbar = Scrollbar [Property]

instance IsElement Scrollbar where
  name _ = "scrollbar"
  props (Scrollbar p) = p
  updateProps f (Scrollbar p) = Scrollbar $ f p

scrollbar :: ElementBuilder Scrollbar
scrollbar = buildElement $ Scrollbar []
