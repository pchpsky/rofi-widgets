{-# LANGUAGE LambdaCase #-}

module Main where

import Data.Text (strip)
import Rofi
import Shelly (Sh, cmd, escaping, shelly)
import qualified Theme
import Prelude hiding (Option)

main :: IO ()
main = shelly $ do
  response <- runPowermenu
  whenJust
    (readOption $ strip response)
    ( escaping False . cmd . \case
        Shutdown -> "systemctl poweroff"
        Reboot -> "systemctl reboot"
        Suspend -> "systemctl suspend"
        Logout -> "xdotool key super+shift+q"
    )

runPowermenu :: Sh Text
runPowermenu = escaping False . cmd . rofiToCmd $ powermenuCmd

powermenuCmd :: Rofi
powermenuCmd =
  rofi
    & dmenu
    & theme Theme.powermenu
    & input (fmap snd options)

data Option = Shutdown | Reboot | Suspend | Logout deriving (Show)

readOption :: Text -> Maybe Option
readOption s = find ((== s) . snd) options <&> fst

options :: [(Option, Text)]
options =
  [ (Shutdown, "\xf011"),
    (Reboot, "\xf021"),
    (Suspend, "\xf186"),
    (Logout, "\xf08b")
  ]
