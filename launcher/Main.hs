module Main where

import Data.Text
import Shelly
import qualified Theme
import Widget

-- TODO: use Rofi

main :: IO ()
main = shelly runLauncher

runLauncher :: Sh ()
runLauncher =
  escaping False . cmd . unpack $
    "rofi -no-lazy-grab -show drun -modi drun -theme <( echo '" <> toThemeStr Theme.launcher <> "' )"
