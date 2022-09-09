{-# OPTIONS_GHC -Wno-name-shadowing #-}
{-# OPTIONS_GHC -Wno-unused-imports #-}
{-# OPTIONS_GHC -Wno-unused-matches #-}

module UI.Strut where

import Data.Maybe
import Foreign
import GI.Gdk (Monitor (Monitor), displayGetMonitors, getMonitorGeometry, getRectangleHeight, getRectangleWidth, getRectangleX, getRectangleY, monitorGetGeometry)
import qualified GI.Gdk as Gdk
import GI.GdkX11
import GI.Gio (listModelGetItem, listModelGetNItems)
import GI.Gtk (Window, nativeGetSurface, windowDisplay)
import Graphics.X11 (Atom, Display (Display), aTOM, cARDINAL, geometry, heightOfScreen, internAtom, moveResizeWindow, moveWindow, screenCount, screenOfDisplay, sync, wM_NAME, widthOfScreen)
import Graphics.X11.Xlib.Extras
import Prelude hiding (get)

data StrutSize = ExactSize Int32 | ScreenRatio Rational deriving (Show)

data StrutPosition

data StrutConfig = StrutConfig
  { strutWidth :: StrutSize,
    strutHeight :: StrutSize,
    strutOffsetX :: Int32,
    strutOffsetY :: Int32,
    strutMonitor :: Maybe Word32
  }
  deriving (Show)

_NET_WM_WINDOW_TYPE :: Atom
_NET_WM_WINDOW_TYPE = 359

_NET_WM_WINDOW_TYPE_DOCK :: Atom
_NET_WM_WINDOW_TYPE_DOCK = 395

_NET_WM_STRUT_PARTIAL :: Atom
_NET_WM_STRUT_PARTIAL = 411

_NET_WM_STRUT :: Atom
_NET_WM_STRUT = 410

setupStrutWindow :: StrutConfig -> Window -> IO ()
setupStrutWindow strutConfig window = do
  surface <- nativeGetSurface window
  (Just x11Surface) <- castTo X11Surface surface
  surfaceXid <- #getXid x11Surface
  (Just gdkDisplay) <- get window #display
  (Just x11Display) <- castTo X11Display gdkDisplay
  xdisplay <- x11DisplayGetXdisplay x11Display
  withManagedPtr xdisplay $ \displayPtr -> do
    let display = Display $ castPtr displayPtr

    (Just monitor) <- getMonitorById (fromMaybe 0 (strutMonitor strutConfig)) gdkDisplay

    geometry <- monitorGetGeometry monitor
    monitorY <- getRectangleY geometry
    monitorX <- getRectangleX geometry
    monitorHeight <- getRectangleHeight geometry
    monitorWidth <- getRectangleWidth geometry

    let height =
          case strutHeight strutConfig of
            ExactSize h -> h
            ScreenRatio r -> floor $ (r * fromIntegral monitorHeight) - (2 * fromIntegral (strutOffsetY strutConfig))
        width =
          case strutWidth strutConfig of
            ExactSize w -> w
            ScreenRatio r -> floor $ r * fromIntegral monitorWidth - (2 * fromIntegral (strutOffsetX strutConfig))
        top = monitorY + height + (2 * strutOffsetY strutConfig)
        yPos = monitorY + strutOffsetY strutConfig
        xPos = monitorX + strutOffsetX strutConfig
        topStartX = xPos - strutOffsetX strutConfig
        topEndX = xPos + width + strutOffsetX strutConfig - 1
        wmStrutProps = [0, 0, fromIntegral top, 0, 0, 0, 0, 0, fromIntegral topStartX, fromIntegral topEndX, 0, 0]

    changeProperty32 display (fromIntegral surfaceXid) _NET_WM_WINDOW_TYPE aTOM propModeReplace [fromIntegral _NET_WM_WINDOW_TYPE_DOCK]
    moveResizeWindow display (fromIntegral surfaceXid) xPos yPos (fromIntegral width) (fromIntegral height)
    changeProperty32 display (fromIntegral surfaceXid) _NET_WM_STRUT_PARTIAL cARDINAL propModeReplace wmStrutProps

    sync display False

getMonitorById :: Word32 -> Gdk.Display -> IO (Maybe Gdk.Monitor)
getMonitorById monitorId =
  Gdk.displayGetMonitors
    >=> getListItem monitorId
    >=> mapM (castTo Gdk.Monitor)
    >=> return . join
  where
    getListItem = flip listModelGetItem
