module UI.Workspaces where

import Data.GI.Base
import GI.Gtk

data WorkspacesConfig = WorkspacesConfig

workspacesNew :: WorkspacesConfig -> IO Widget
workspacesNew _ = do
  container <- new Box [#orientation := OrientationHorizontal]
  lab <- new Label [#label := "workspaces"]

  #append container lab

  toWidget container
