module UI.Spotify where

import Data.GI.Base
import GI.Gtk

data SpotifyConfig = SpotifyConfig

spotifyNew :: SpotifyConfig -> IO Widget
spotifyNew _ = do
  container <- new Box [#orientation := OrientationHorizontal]
  lab <- new Label [#label := "spotify"]

  #append container lab

  toWidget container
