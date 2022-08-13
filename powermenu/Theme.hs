{-# LANGUAGE BlockArguments #-}
{-# LANGUAGE RebindableSyntax #-}

module Theme where

import Config
import Element
import Element.Listview
import Element.Mainbox
import Element.Window
import Property
import Widget
import Prelude hiding (cycle, lines, (>>))

powermenu :: Widget
powermenu = buildWidget do
  font fontName
  showIcons False
  disableHistory False
  sidebarMode False

  globals do
    borderColor (rgba 0x3f 0x9c 0xe8 0xaa)

  window do
    transparencyReal
    backgroundColor background
    borderColor backgroundSelected
    border1 (px 3)
    textColor foreground
    borderRadius1 (px 5)
    height (px 246)
    width (px 789)

  mainbox do
    backgroundColor backgroundAlt
    children ["listview"]

  listview do
    backgroundColor backgroundAlt
    padding1 (px 40)
    spacing (px 20)
    cycle True
    prop "dynamic" False
    layout Horizontal

  element do
    backgroundColor backgroundAlt
    textColor foreground

  elementText do
    backgroundColor backgroundAlt
    textColor foreground
    font "Font Awesome 6 Free 60"
    expand True
    horizontalAlign 0.5
    verticalAlign 0.5
    margin2 (px 40) (px 40)

  elementSelected do
    backgroundColor backgroundSelected
    textColor foreground
    border1 (px 1)
    borderRadius1 (px 5)
    borderColor (rgba 0x3f 0x9c 0xe8 0xaa)
