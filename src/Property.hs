module Property where

import Text.Printf

type PropertyName = Text

newtype PropertyValue = PropertyValue Text deriving (Show)

data Property = Property PropertyName PropertyValue

class IsPropertyValue v where
  toPropertyValue :: v -> PropertyValue

instance IsPropertyValue PropertyValue where
  toPropertyValue = id

instance IsPropertyValue Text where
  toPropertyValue t = PropertyValue $ "\"" <> t <> "\""

instance IsPropertyValue a => IsPropertyValue [a] where
  toPropertyValue as =
    PropertyValue $
      "[" <> mconcat (intersperse ", " $ fmap ((\(PropertyValue v) -> v) . toPropertyValue) as) <> "]"

instance IsPropertyValue Bool where
  toPropertyValue True = PropertyValue "true"
  toPropertyValue False = PropertyValue "false"

instance IsPropertyValue Integer where
  toPropertyValue = PropertyValue . show

instance IsPropertyValue Float where
  toPropertyValue = PropertyValue . show

newtype Distance = Distance {getDistance :: Text}

instance IsPropertyValue Distance where
  toPropertyValue (Distance d) = PropertyValue d

px :: Integer -> Distance
px i = Distance $ show i <> "px"

em :: Float -> Distance
em i = Distance $ show i <> "em"

ch :: Float -> Distance
ch i = Distance $ show i <> "ch"

pct :: Float -> Distance
pct i = Distance $ show i <> "%"

mm :: Integer -> Distance
mm i = Distance $ show i <> "mm"

data Padding
  = Padding1 Distance
  | Padding2 Distance Distance
  | Padding3 Distance Distance Distance
  | Padding4 Distance Distance Distance Distance

instance IsPropertyValue Padding where
  toPropertyValue (Padding1 a) =
    propertyValueFromTokens
      [getDistance a]
  toPropertyValue (Padding2 topbottom leftright) =
    propertyValueFromTokens
      [getDistance topbottom, getDistance leftright]
  toPropertyValue (Padding3 top leftright bottom) =
    propertyValueFromTokens
      [getDistance top, getDistance leftright, getDistance bottom]
  toPropertyValue (Padding4 top right bottom left) =
    propertyValueFromTokens
      [getDistance top, getDistance right, getDistance bottom, getDistance left]

data Color = Rgba Integer Integer Integer Integer

instance IsPropertyValue Color where
  toPropertyValue (Rgba r g b a) = PropertyValue $ "#" <> mconcat (fmap (fromString . printf "%02x") [r, g, b, a])

rgba :: Integer -> Integer -> Integer -> Integer -> Color
rgba = Rgba

rgb :: Integer -> Integer -> Integer -> Color
rgb r g b = rgba r g b 255

data LineStyle = Dash | Solid

getLineStyle :: LineStyle -> Text
getLineStyle Dash = "dash"
getLineStyle Solid = "solid"

instance IsPropertyValue LineStyle where
  toPropertyValue = PropertyValue . getLineStyle

data Border
  = Border1 Distance LineStyle
  | Border2 Distance LineStyle Distance LineStyle
  | Border3 Distance LineStyle Distance LineStyle Distance LineStyle
  | Border4 Distance LineStyle Distance LineStyle Distance LineStyle Distance LineStyle

propertyValueFromTokens :: [Text] -> PropertyValue
propertyValueFromTokens = PropertyValue . mconcat . intersperse " "

instance IsPropertyValue Border where
  toPropertyValue (Border1 a aLS) =
    propertyValueFromTokens
      [getDistance a, getLineStyle aLS]
  toPropertyValue (Border2 topbottom topbottomLS leftright leftrightLS) =
    propertyValueFromTokens
      [getDistance topbottom, getLineStyle topbottomLS, getDistance leftright, getLineStyle leftrightLS]
  toPropertyValue (Border3 top topLS leftright leftrightLS bottom bottomLS) =
    propertyValueFromTokens
      [getDistance top, getLineStyle topLS, getDistance leftright, getLineStyle leftrightLS, getDistance bottom, getLineStyle bottomLS]
  toPropertyValue (Border4 top topLS right rightLS bottom bottomLS left leftLS) =
    propertyValueFromTokens
      [getDistance top, getLineStyle topLS, getDistance right, getLineStyle rightLS, getDistance bottom, getLineStyle bottomLS, getDistance left, getLineStyle leftLS]

data Cursor = Default | Pointer | Text

instance IsPropertyValue Cursor where
  toPropertyValue Default = PropertyValue "default"
  toPropertyValue Pointer = PropertyValue "pointer"
  toPropertyValue Text = PropertyValue "text"

data ImageScale = None | Both | Width | Height

getImageScale :: ImageScale -> Text
getImageScale None = "none"
getImageScale Both = "both"
getImageScale Width = "width"
getImageScale Height = "height"

data Image = Image Text | ScaledImage ImageScale Text

instance IsPropertyValue Image where
  toPropertyValue (Image url) =
    PropertyValue $
      "url(\"" <> url <> "\")"
  toPropertyValue (ScaledImage scale url) =
    PropertyValue $
      "url(\"" <> url <> ", " <> getImageScale scale <> "\")"

data Orientation = Horizontal | Vertical

instance IsPropertyValue Orientation where
  toPropertyValue Horizontal = PropertyValue "horizontal"
  toPropertyValue Vertical = PropertyValue "vertical"
