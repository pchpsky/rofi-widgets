{-# LANGUAGE BlockArguments #-}
{-# LANGUAGE RebindableSyntax #-}

module MyWidgets where

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

(>>) :: (a -> b) -> (b -> c) -> a -> c
(>>) = (>>>)

bgc :: Color
bgc = rgba 0x24 0x29 0x36 0xcd

bgcAlt :: Color
bgcAlt = rgba 0 0 0 0

bgcSelected :: Color
bgcSelected = rgba 0x1f 0x24 0x30 0x55

foreground :: Color
foreground = rgba 0xcc 0xca 0xc2 0xff

launcher :: Widget
launcher = buildWidget do
  font "RobotoMono Nerd Font 11"
  showIcons True
  displayDrun "Search :: "
  drunDisplayFormat "{name}"
  disableHistory False
  sidebarMode False

  globals do
    borderColor (rgba 0x3f 0x9c 0xe8 0xaa)

  window do
    transparencyReal
    backgroundColor bgc
    border1 (px 3)
    borderColor bgcSelected
    borderRadius1 (px 5)
    width (px 540)
    height (px 620)

  mainbox do
    backgroundColor bgcAlt
    children ["inputbar", "listview"]
    spacing (px 15)
    padding1 (px 15)

  inputbar do
    children ["prompt", "entry"]
    backgroundColor bgcAlt
    textColor foreground
    expand False
    border1 (px 1)
    borderRadius1 (px 5)
    padding2 (px 10) (px 15)

  prompt do
    enabled True
    textColor foreground
    backgroundColor bgcAlt

  entry do
    backgroundColor bgcAlt
    textColor foreground
    placeholderColor foreground
    expand True
    horizontalAlign 0
    blink True

  listview do
    backgroundColor bgcAlt
    columns 2
    lines 10
    spacing (px 0)
    layout Vertical
    fixedColumns True
    fixedHeight True
    cycle True

  element do
    backgroundColor bgcAlt
    textColor foreground
    orientation Horizontal
    borderRadius1 (px 0)
    padding1 (px 8)
    spacing (px 10)
    height (px 30)

  elementIcon do
    backgroundColor bgcAlt
    textColor foreground
    horizontalAlign 0.5
    verticalAlign 0.5
    size (px 25)
    border1 (px 0)

  elementText do
    backgroundColor bgcAlt
    textColor foreground
    expand True
    verticalAlign 0.5

  elementSelected do
    backgroundColor bgcSelected
    textColor foreground
    border1 (px 1)
    borderRadius1 (px 5)
    borderColor (rgba 0x3f 0x9c 0xe8 0xaa)
