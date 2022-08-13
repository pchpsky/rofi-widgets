module Rofi where

import Data.Text (unpack, unwords)
import Widget
import Prelude hiding (unwords)

data Rofi = Rofi {_theme :: Maybe Widget, _inputCmd :: Maybe [Text], _separator :: Maybe Text, _dmenu :: Bool}

rofi :: Rofi
rofi = Rofi Nothing Nothing Nothing False

dmenu :: Rofi -> Rofi
dmenu r = r {_dmenu = True}

theme :: Widget -> Rofi -> Rofi
theme w r = r {_theme = Just w}

input :: [Text] -> Rofi -> Rofi
input t r = r {_inputCmd = Just t}

sep :: Text -> Rofi -> Rofi
sep s r = r {_separator = Just s}

wrap :: Text -> Text -> Text -> Text
wrap b e c = b <> c <> e

rofiToCmd :: Rofi -> String
rofiToCmd Rofi {..} =
  cmdTokens
    & catMaybes
    & unwords
    & unpack
  where
    separator = fromMaybe "|" _separator
    cmdTokens =
      [ Just "rofi",
        "-dmenu"
          <$ guard _dmenu,
        _theme
          <&> toThemeStr
          <&> wrap "-theme <( echo '" "' )",
        _inputCmd
          <&> intersperse separator
          <&> mconcat
          <&> wrap "-input <( echo -n '" "' )",
        separator
          <$ _inputCmd
          <&> wrap "-sep '" "'"
      ]
