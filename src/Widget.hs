module Widget where

import Element
import Property

data Widget = Widget {configuration :: [Property], elements :: [Element]}

newtype Globals = Globals [Property]

instance IsElement Globals where
  name _ = "*"
  props (Globals p) = p
  updateProps f (Globals p) = Globals (f p)

type ElementBuilder e = (e -> e) -> Widget -> Widget

globals :: ElementBuilder Globals
globals = buildElement (Globals [])

buildElement :: IsElement e => e -> (e -> e) -> Widget -> Widget
buildElement e b w = w {elements = elements w ++ [Element $ b e]}

instance IsElement Widget where
  name _ = "configuration"
  props = configuration
  updateProps f w = w {configuration = f (configuration w)}

buildWidget :: (Widget -> Widget) -> Widget
buildWidget f = f $ Widget [] []

var :: IsPropertyValue v => PropertyName -> v -> Widget -> Widget
var n v w = w {configuration = configuration w ++ [Property n (toPropertyValue v)]}

(#) :: IsElement e => Widget -> e -> Widget
w # el = w {elements = elements w ++ [Element el]}

toThemeStr :: Widget -> Text
toThemeStr w = mconcat $ intersperse "\n" $ elementToThemeStr <$> (Element w : elements w)
  where
    elementToThemeStr :: Element -> Text
    elementToThemeStr (Element e) = name e <> " {\n" <> propertiesToThemeStr (props e) <> "}\n"

    propertiesToThemeStr :: [Property] -> Text
    propertiesToThemeStr ps = mconcat $ fmap propertyToThemeStr ps

    propertyToThemeStr :: Property -> Text
    propertyToThemeStr (Property n (PropertyValue v)) = "  " <> n <> ": " <> v <> ";\n"

font :: Text -> Widget -> Widget
font = prop "font"

showIcons :: Bool -> Widget -> Widget
showIcons = prop "show-icons"

displayDrun :: Text -> Widget -> Widget
displayDrun = prop "display-drun"

displayRun :: Text -> Widget -> Widget
displayRun = prop "display-run"

drunDisplayFormat :: Text -> Widget -> Widget
drunDisplayFormat = prop "drun-display-format"

disableHistory :: Bool -> Widget -> Widget
disableHistory = prop "disable-history"

sidebarMode :: Bool -> Widget -> Widget
sidebarMode = prop "sidebar-mode"
