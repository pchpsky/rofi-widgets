module ColorScheme where

import Property

data ColorScheme = ColorScheme
  { background :: Color,
    backgroundAlt :: Color,
    foreground :: Color,
    selected :: Color,
    active :: Color,
    urgent :: Color
  }

onedark :: ColorScheme
onedark =
  ColorScheme
    { background = rgba 0x1E 0x21 0x27 0xFF,
      backgroundAlt = rgba 0x28 0x2B 0x31 0xFF,
      foreground = rgba 0xFF 0xFF 0xFF 0xFF,
      selected = rgba 0x61 0xAF 0xEF 0xFF,
      active = rgba 0x98 0xC3 0x79 0xFF,
      urgent = rgba 0xE0 0x6C 0x75 0xFF
    }
