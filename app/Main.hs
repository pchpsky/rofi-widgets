{-# LANGUAGE ExistentialQuantification #-}

module Main where

-- import qualified Data.Text
import Element
import Element.Entry
import Element.Inputbar
import Element.Listview
import Element.Mainbox
import Element.Prompt
import Element.Window
import Property
import Shelly
import Widget
import Prelude hiding (cycle, lines)

main :: IO ()
main = do
  shelly runLauncher

runLauncher :: Sh ()
runLauncher = do
  setStdin $ toThemeStr launcher
  run_
    "rofi"
    ["-no-lazy-grab", "-show", "drun", "-modi", "drun", "-theme", "/dev/stdin"]

bgc :: Color
bgc = rgba 0x24 0x29 0x36 0xcd

bgcAlt :: Color
bgcAlt = rgba 0 0 0 0

bgcSelected :: Color
bgcSelected = rgba 0x1f 0x24 0x30 0x55

foreground :: Color
foreground = rgba 0xcc 0xca 0xc2 0xff

launcher :: Widget
launcher =
  widget
    # ( globals
          & borderColor (rgba 0x3f 0x9c 0xe8 0xaa)
      )
    # ( window
          & transparencyReal
          & backgroundColor bgc
          & border1 (px 3)
          & borderColor bgcSelected
          & borderRadius1 (px 5)
          & width (px 540)
          & height (px 620)
      )
    # ( mainbox
          & backgroundColor bgcAlt
          & children ["inputbar", "listview"]
          & spacing (px 15)
          & padding1 (px 15)
      )
    # ( inputbar
          & children ["prompt", "entry"]
          & backgroundColor bgcAlt
          & textColor foreground
          & expand False
          & border1 (px 1)
          & borderRadius1 (px 5)
          & padding2 (px 10) (px 15)
      )
    # ( prompt
          & enabled True
          & textColor foreground
          & backgroundColor bgcAlt
      )
    # ( entry
          & backgroundColor bgcAlt
          & textColor foreground
          & placeholderColor foreground
          & expand True
          & horizontalAlign 0
          & blink True
      )
    # ( listview
          & backgroundColor bgcAlt
          & columns 2
          & lines 10
          & spacing (px 0)
          & layout Vertical
          & fixedColumns True
          & fixedHeight True
          & cycle True
      )
    # ( element
          & backgroundColor bgcAlt
          & textColor foreground
          & orientation Horizontal
          & borderRadius1 (px 0)
          & padding1 (px 8)
          & spacing (px 10)
          & height (px 30)
      )
    # ( elementIcon
          & backgroundColor bgcAlt
          & textColor foreground
          & horizontalAlign 0.5
          & verticalAlign 0.5
          & size (px 25)
          & border1 (px 0)
      )
    # ( elementText
          & backgroundColor bgcAlt
          & textColor foreground
          & expand True
          & verticalAlign 0.5
      )
    # ( elementSelected
          & backgroundColor bgcSelected
          & textColor foreground
          & border1 (px 1)
          & borderRadius1 (px 5)
          & borderColor (rgba 0x3f 0x9c 0xe8 0xaa)
      )
    & font "RobotoMono Nerd Font 11"
    & showIcons True
    & displayDrun "Search :: "
    & drunDisplayFormat "{name}"
    & disableHistory False
    & sidebarMode False
