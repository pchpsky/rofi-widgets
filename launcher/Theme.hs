{-# LANGUAGE BlockArguments #-}
{-# LANGUAGE RebindableSyntax #-}

module Theme where

import ColorScheme
import Config (fontName)
import Element
import Element.Entry
import Element.Inputbar (inputbar)
import Element.Listview
import Element.Mainbox
import Element.Prompt
import Element.Window
import Property
import Widget
import Prelude hiding (cycle, (>>))

launcher :: ColorScheme -> Widget
launcher cs = buildWidget do
  colorScheme cs
  font fontName
  displayDrun "\xf002 ::"
  drunDisplayFormat "{name}"
  showIcons True

  window do
    transparencyReal
    location Center
    anchor Center
    width (px 400)
    enabled True
    borderRadius1 (px 12)
    borderColor (selected cs)
    backgroundColor (background cs)
    cursor Default

  mainbox do
    enabled True
    borderColor (selected cs)
    backgroundColor Transparent
    children ["inputbar", "listview"]

  inputbar do
    spacing (px 10)
    padding1 (px 15)
    borderColor (selected cs)
    backgroundColor (selected cs)
    textColor (background cs)
    children ["prompt", "entry"]

  prompt do
    enabled True
    backgroundColor Inherit
    textColor Inherit

  entry do
    backgroundColor Inherit
    textColor Inherit
    cursor Text
    placeholder "Search..."
    placeholderColor Inherit

  listview do
    columns 1
    prop "lines" (6 :: Integer)
    cycle True
    prop "dynamic" True
    prop "scrollbar" False
    layout Vertical
    fixedHeight True
    fixedColumns True
    spacing (px 5)
    borderRadius1 (px 0)
    borderColor (selected cs)
    backgroundColor Transparent
    textColor (foreground cs)
    cursor Default

  scrollbar do
    prop "handle-width" (px 5)
    prop "handle-color" (selected cs)
    borderRadius1 (px 0)
    backgroundColor (backgroundAlt cs)

  element do
    enabled True
    spacing (px 10)
    padding1 (px 8)
    borderColor (selected cs)
    backgroundColor Transparent
    textColor (foreground cs)
    cursor Pointer

  elementNormalNormal do
    backgroundColor (background cs)
    textColor (foreground cs)

  elementSelectedNormal do
    backgroundColor (backgroundAlt cs)
    textColor (foreground cs)

  elementIcon do
    backgroundColor Transparent
    textColor Inherit
    size (px 32)
    cursor CursorInherit

  elementText do
    backgroundColor Transparent
    textColor Inherit
    verticalAlign 0.5
    horizontalAlign 0.0
