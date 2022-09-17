{-# OPTIONS_GHC -Wno-missing-fields #-}
{-# OPTIONS_GHC -Wno-unused-imports #-}

module Main where

import Control.Concurrent
import Element (HasSpacing (spacing))
import GI.Gdk
import GI.Gtk
import UI.Clock (ClockConfig (ClockConfig), clockNew)
import UI.Powermenu (PowermenuConfig (PowermenuConfig), powermenuNew)
import UI.Spotify (SpotifyConfig (SpotifyConfig), spotifyNew)
import UI.Strut
import UI.System (SystemConfig (..), systemNew)
import UI.Volume (VolumeConfig (VolumeConfig), volumeNew)
import UI.Workspaces (WorkspacesConfig (WorkspacesConfig), workspacesNew)
import Prelude hiding (on)

appId = "com.pchpsky.Widgets.Topbar"

styles = "./topbar/topbar.css"

main :: IO ()
main = do
  app <- new Application [#applicationId := appId]
  on app #startup (void loadCSS)
  on app #activate (buildUI app)
  fork $ #run app Nothing
  where
    fork = void . forkIO . void

loadCSS :: IO CssProvider
loadCSS = do
  provider <- new CssProvider []

  #loadFromPath provider styles

  Just display <- displayGetDefault
  styleContextAddProviderForDisplay display provider 800

  return provider

buildUI :: Application -> IO ()
buildUI app = do
  box <-
    new
      CenterBox
      [ #orientation := OrientationHorizontal,
        #vexpand := True,
        #hexpand := True,
        #valign := AlignFill,
        #halign := AlignFill,
        #cssClasses := ["bar-mainbox"]
      ]

  workspaces <- workspacesNew WorkspacesConfig
  left <- new Box [#cssClasses := ["left-container"]]
  #append left workspaces
  #setStartWidget box (Just left)

  spotify <- spotifyNew SpotifyConfig
  middle <- new Box [#cssClasses := ["middle-container"]]
  #append middle spotify
  #setCenterWidget box (Just middle)

  volume <- volumeNew VolumeConfig
  system <- systemNew SystemConfig
  clock <- clockNew ClockConfig
  powermenu <- powermenuNew PowermenuConfig
  right <- new Box [#cssClasses := ["right-container"]]
  #append right volume
  #append right system
  #append right clock
  #append right powermenu
  #setEndWidget box (Just right)

  window <-
    new
      Window
      [ #child := box,
        #application := app,
        #cssClasses := ["bar-window"]
      ]

  #show window

  let strutConfig =
        StrutConfig
          { strutWidth = ScreenRatio 1,
            strutHeight = ExactSize 40,
            strutOffsetX = 0,
            strutOffsetY = 0,
            strutMonitor = Just 1
          }
  setupStrutWindow strutConfig window
