-- default configuration for Fedora

import System.Posix.Env (getEnv)
import Data.Maybe (maybe)

import XMonad hiding ((|||))
import XMonad.Core
import XMonad.Config.Desktop
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.SetWMName
import XMonad.Actions.CycleWS
import XMonad.Actions.CycleRecentWS
import XMonad.Layout.LayoutCombinators ((|||))
import XMonad.Layout.SimpleDecoration
import XMonad.Layout.ShowWName
import XMonad.Layout.ThreeColumns
import XMonad.Layout.Grid
import XMonad.Layout.Circle
import XMonad.Layout.DecorationMadness
import XMonad.Layout.IM
import XMonad.Layout.LayoutCombinators (JumpToLayout (..), (|||))
import XMonad.Layout.Named
import XMonad.Layout.NoBorders
import XMonad.Layout.Reflect
import XMonad.Actions.GridSelect
import XMonad.Util.Run
import qualified Data.Map as M


myBorderWidth = 2
myBorderColor = "blue"
myTerminal = "gnome-terminal"
myModMask = mod4Mask

myManageHook = composeAll
               [ className =? "Gimp"      --> doFloat
               , className =? "Vncviewer" --> doFloat
               ]

basic :: Tall a
basic = Tall nmaster delta ratio
  where
    -- The default number of windows in the master pane
    nmaster = 1
    -- Percent of screen to increment by when resizing panes
    delta   = 3/100
    -- Default proportion of screen occupied by master pane
    ratio   = 1/2

myLayout = smartBorders $ standardLayouts
  where
    standardLayouts = tall ||| full ||| circle ||| three
    tall   = named "tall"   $ avoidStruts basic
    wide   = named "wide"   $ avoidStruts $ Mirror basic
    circle = named "circle" $ avoidStruts circleSimpleDefaultResizable
    full   = named "full"   $ noBorders Full
    three  = named "three"  $ avoidStruts $ ThreeCol 1 (3/100) (1/2)

myWorkspaces=["1:dev","2:dev","3:shell","4:jira-bamboo","5:web","6","7","8:irc-web","9-mail"]

myBar = "xmobar"

main = do
  xmproc <- spawnPipe "`which xmobar` /home/riptom/.xmobarrc"
  session <- getEnv "DESKTOP_SESSION"
  xmonad =<< xmobar defaultConfig {
    manageHook = manageDocks <+> myManageHook <+> manageHook defaultConfig
    , terminal = myTerminal
    , borderWidth = myBorderWidth
    , layoutHook = myLayout
    , workspaces = myWorkspaces
    , logHook = dynamicLogWithPP xmobarPP {
      ppOutput = hPutStrLn xmproc
      , ppTitle = xmobarColor "green" "" . shorten 50
      }
    , modMask = mod4Mask
    , keys = \c -> myKeys c `M.union` keys defaultConfig c
    , startupHook = setWMName "LG3D"
    }

--desktop _ = desktopConfig


-- a basic CycleWS setup

myKeys x = M.fromList $ [
  ((myModMask,xK_g), goToSelected defaultGSConfig)
  ,((myModMask .|. shiftMask,xK_z), spawn "xscreensaver-command -lock")
   ,((controlMask,xK_Print), spawn "sleep 0.2; scrot -s")
    ,((0,xK_Print),spawn ("scrot"))
  ,((myModMask,xK_Tab), cycleRecentWS [xK_Alt_L] xK_Tab xK_grave)
 ]
