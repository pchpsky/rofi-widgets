module Main where

import Data.Text
import Shelly
import qualified Theme
import Widget

-- TODO: use Rofi

main :: IO ()
main = shelly runRun

runRun :: Sh ()
runRun =
  escaping False . cmd . unpack $
    "rofi -no-lazy-grab -show run -modi run -theme <( echo '" <> toThemeStr Theme.run <> "' )"
