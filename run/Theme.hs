{-# LANGUAGE BlockArguments #-}
{-# LANGUAGE RebindableSyntax #-}

module Theme where

import Config
import Element
import Element.Entry
import Element.Inputbar
import Element.Listview
import Element.Mainbox
import Element.Prompt
import Element.Window
import Property
import Widget
import Prelude hiding (cycle, lines, (>>))

run :: Widget
run = buildWidget do
  font "RobotoMono Nerd Font 11"
  showIcons False
  displayRun "$ "
  disableHistory False
  sidebarMode False

  globals do
    borderColor (rgba 0x3f 0x9c 0xe8 0xaa)

  window do
    transparencyReal
    backgroundColor background
    border1 (px 3)
    borderColor backgroundSelected
    borderRadius1 (px 5)
    width (px 480)
    height (px 640)

  mainbox do
    backgroundColor backgroundAlt
    children ["inputbar", "listview"]
    spacing (px 15)
    padding1 (px 15)

  inputbar do
    children ["prompt", "entry"]
    backgroundColor backgroundAlt
    textColor foreground
    expand False
    border1 (px 1)
    borderRadius1 (px 5)
    padding2 (px 10) (px 15)

  prompt do
    enabled True
    backgroundColor backgroundAlt
    textColor foreground

  entry do
    backgroundColor backgroundAlt
    textColor foreground
    placeholderColor foreground
    expand True
    horizontalAlign 0
    blink True

  listview do
    backgroundColor backgroundAlt
    columns 1
    lines 10
    spacing (px 0)
    layout Vertical
    fixedColumns True
    fixedHeight True
    cycle True

  element do
    backgroundColor backgroundAlt
    textColor foreground
    orientation Horizontal
    borderRadius1 (px 0)
    padding1 (px 8)
    spacing (px 10)
    height (px 30)

  elementText do
    backgroundColor backgroundAlt
    textColor foreground
    expand True
    verticalAlign 0.5

  elementSelected do
    backgroundColor backgroundSelected
    textColor foreground
    border1 (px 1)
    borderRadius1 (px 5)
    borderColor (rgba 0x3f 0x9c 0xe8 0xaa)
