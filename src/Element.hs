{-# LANGUAGE ExistentialQuantification #-}

module Element where

import Property

data Element = forall e. IsElement e => Element e

class IsElement e where
  name :: e -> Text
  props :: e -> [Property]
  updateProps :: ([Property] -> [Property]) -> e -> e

prop :: (IsElement e, IsPropertyValue v) => PropertyName -> v -> e -> e
prop n v = updateProps (append property)
  where
    property = Property n (toPropertyValue v)
    append a = (++ [a])

-- enable/disable the widget
enabled :: IsElement e => Bool -> e -> e
enabled = prop "enabed"

-- Padding on the inside of the widget
padding :: IsElement e => Padding -> e -> e
padding = prop "padding"

padding1 :: IsElement e => Distance -> e -> e
padding1 = padding . Padding1

padding2 :: IsElement e => Distance -> Distance -> e -> e
padding2 tb lr = padding $ Padding2 tb lr

padding3 :: IsElement e => Distance -> Distance -> Distance -> e -> e
padding3 t lr b = padding $ Padding3 t lr b

padding4 :: IsElement e => Distance -> Distance -> Distance -> Distance -> e -> e
padding4 t r b l = padding $ Padding4 t r b l

-- Margin on the outside of the widget
margin :: IsElement e => Padding -> e -> e
margin = prop "margin"

margin1 :: IsElement e => Distance -> e -> e
margin1 = margin . Padding1

margin2 :: IsElement e => Distance -> Distance -> e -> e
margin2 tb lr = margin $ Padding2 tb lr

margin3 :: IsElement e => Distance -> Distance -> Distance -> e -> e
margin3 t lr b = margin $ Padding3 t lr b

margin4 :: IsElement e => Distance -> Distance -> Distance -> Distance -> e -> e
margin4 t r b l = margin $ Padding4 t r b l

-- Border around the widget (between padding and margin
border :: IsElement e => Border -> e -> e
border = prop "border"

border1 :: IsElement e => Distance -> e -> e
border1 d = prop "border" $ Border1 d Solid

border2 :: IsElement e => Distance -> Distance -> e -> e
border2 tb lr = border $ Border2 tb Solid lr Solid

border3 :: IsElement e => Distance -> Distance -> Distance -> e -> e
border3 t lr b = border $ Border3 t Solid lr Solid b Solid

border4 :: IsElement e => Distance -> Distance -> Distance -> Distance -> e -> e
border4 t r b l = border $ Border4 t Solid r Solid b Solid l Solid

-- Sets a radius on the corners of the borders.
borderRadius :: IsElement e => Padding -> e -> e
borderRadius = prop "border-radius"

borderRadius1 :: IsElement e => Distance -> e -> e
borderRadius1 = borderRadius . Padding1

borderRadius2 :: IsElement e => Distance -> Distance -> e -> e
borderRadius2 tb lr = borderRadius $ Padding2 tb lr

borderRadius3 :: IsElement e => Distance -> Distance -> Distance -> e -> e
borderRadius3 t lr b = borderRadius $ Padding3 t lr b

borderRadius4 :: IsElement e => Distance -> Distance -> Distance -> Distance -> e -> e
borderRadius4 t r b l = borderRadius $ Padding4 t r b l

-- Background color
backgroundColor :: IsElement e => Color -> e -> e
backgroundColor = prop "background-color"

-- Background image
backgroundImage :: IsElement e => Image -> e -> e
backgroundImage = prop "background-image"

-- Color of the border
borderColor :: IsElement e => Color -> e -> e
borderColor = prop "border-color"

-- Type of mouse cursor that is set when the mouse pointer is hovered over the widget.
cursor :: IsElement e => Cursor -> e -> e
cursor = prop "cursor"

class IsElement e => HasTransparency e where
  transparencyReal :: e -> e
  transparencyReal = prop "transparency" $ PropertyValue "\"real\""

  transparencyBackground :: e -> e
  transparencyBackground = prop "transparency" $ PropertyValue "\"background\""

  transparencyScreenshot :: e -> e
  transparencyScreenshot = prop "screenshot" $ PropertyValue "\"screenshot\""

class IsElement e => HasWidth e where
  width :: Distance -> e -> e
  width = prop "width"

class IsElement e => HasHeight e where
  height :: Distance -> e -> e
  height = prop "height"

class IsElement e => HasSpacing e where
  spacing :: Distance -> e -> e
  spacing = prop "spacing"

class IsElement e => HasChildren e where
  children :: [Text] -> e -> e
  children cs = prop "children" $ fmap PropertyValue cs

class IsElement e => HasTextColor e where
  textColor :: Color -> e -> e
  textColor = prop "text-color"

class IsElement e => HasExpand e where
  expand :: Bool -> e -> e
  expand = prop "expand"

class IsElement e => HasPlaceholder e where
  placeholder :: Text -> e -> e
  placeholder = prop "placeholder"

  placeholderColor :: Color -> e -> e
  placeholderColor = prop "placeholder-color"

class IsElement e => HasAlign e where
  verticalAlign :: Float -> e -> e
  verticalAlign = prop "vertical-align"

  horizontalAlign :: Float -> e -> e
  horizontalAlign = prop "horizontal-align"

class IsElement e => HasBlink e where
  blink :: Bool -> e -> e
  blink = prop "blink"
