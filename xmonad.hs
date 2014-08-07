-- An example, simple ~/.xmonad/xmonad.hs file.
-- It overrides a few basic settings, reusing all the other defaults.
--

import XMonad
import System.IO
import System.Exit
import XMonad.Layout.NoBorders
import XMonad.Layout.Spiral
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import qualified Data.Map as M
import qualified XMonad.StackSet as W

------------------------------------------------------------------------
-- Terminal
-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
-- myTerminal = "/usr/bin/xterm -bg black -fg white -ls -sl 65536"

myTerminal = "/usr/bin/gnome-terminal"
myTerminal_big = "/usr/bin/gnome-terminal -zoom 3"


-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
myWorkspaces    = ["1","2","3","4","5","6","7","8","9", "0"]




-- Define default layouts used on most workspaces
-- defaultLayouts = tiled ||| ThreeColMid 1 (3/100) (1/3) ||| Full
defaultLayouts = tiled ||| Mirror tiled ||| Full
    where
        -- default tiling algorithm partitions the screen into two panes
        tiled   = Tall nmaster delta ratio

        -- The default number of windows in the master pane
        nmaster = 1

        -- Default proportion of screen occupied by master pane
        ratio   = 1/2

        -- Percent of screen to increment by when resizing panes
        delta   = 3/100





------------------------------------------------------------------------
-- Colors and borders
-- Currently based on the ir_black theme.
--
-- myNormalBorderColor = "#7c7c7c"
-- myFocusedBorderColor = "#ffb6b0"
myNormalBorderColor = "#222222"
myFocusedBorderColor = "#cccccc"

-- Colors for text and backgrounds of each tab when in "Tabbed" layout.
tabConfig = defaultTheme {
    activeBorderColor = "#7C7C7C",
    activeTextColor = "#CEFFAC",
    activeColor = "#000000",
    inactiveBorderColor = "#7C7C7C",
    inactiveTextColor = "#EEEEEE",
    inactiveColor = "#000000"
}

-- Color of current window title in xmobar.
-- xmobarTitleColor = "#FFB6B0"

-- Color of current workspace in xmobar.
-- xmobarCurrentWorkspaceColor = "#CEFFAC"

-- Width of the window border in pixels.
myBorderWidth = 1


------------------------------------------------------------------------
-- Key bindings
--
-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt"). You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask = mod1Mask
 
myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
  ----------------------------------------------------------------------
  -- Custom key bindings
  --

  -- Start a terminal. Terminal to start is specified by myTerminal variable.
  [ ((modMask , xK_Return),
     spawn $ XMonad.terminal conf)

  , ((modMask .|. shiftMask, xK_Return),
     spawn $ myTerminal_big)

  -- Launch dmenu via yeganesh.
  -- Use this to launch programs without a key binding.
  , ((modMask .|. shiftMask, xK_p),
     spawn "/usr/bin/dmenu_run")
  --   spawn "exe=`dmenu_run | yeganesh` && eval \"exec $exe\"")

  -- Take a screenshot in select mode.
  -- After pressing this key binding, click a window, or draw a rectangle with
  -- the mouse.
  -- , ((modMask .|. shiftMask, xK_p),
  --   spawn "select-screenshot")

  -- Take full screenshot in multi-head mode.
  -- That is, take a screenshot of everything you see.
  , ((modMask .|. controlMask .|. shiftMask, xK_p),
     spawn "screenshot")

  -- Mute volume.
  , ((0, 0x1008FF12),
     spawn "amixer -q set Master toggle")

  -- Decrease volume.
  , ((0, 0x1008FF11),
     spawn "amixer -q set Master 10%-")

  -- Increase volume.
  , ((0, 0x1008FF13),
     spawn "amixer -q set Master 10%+")

  -- Audio previous.
  , ((0, 0x1008FF16),
     spawn "")

  -- Play/pause.
  , ((0, 0x1008FF14),
     spawn "")

  -- Audio next.
  , ((0, 0x1008FF17),
     spawn "")

  -- Eject CD tray.
  , ((0, 0x1008FF2C),
     spawn "eject -T")

  --------------------------------------------------------------------
  -- "Standard" xmonad key bindings
  --

  -- Close focused window.
  , ((modMask .|. shiftMask, xK_c),
     kill)

  -- Cycle through the available layout algorithms.
  , ((modMask, xK_space),
     sendMessage NextLayout)

  -- Reset the layouts on the current workspace to default.
  , ((modMask .|. shiftMask, xK_space),
     setLayout $ XMonad.layoutHook conf)

  -- Resize viewed windows to the correct size.
  -- , ((modMask, xK_n),
  --   refresh)

  -- Move focus to the next window.
  , ((modMask, xK_j),
     windows W.focusDown)

  -- Move focus to the previous window.
  , ((modMask, xK_k),
     windows W.focusUp )

  -- Move focus to the master window.
  , ((modMask, xK_m),
     windows W.focusMaster )

  -- suspend
  , ((modMask .|. shiftMask, xK_s),
     spawn "/usr/bin/sudo /bin/suspend.sh")

  -- external screens on
  , ((modMask .|. shiftMask, xK_n),
     spawn "xrandr --output HDMI1 --auto; xrandr --output HDMI1 --left-of eDP1; xrandr --output VGA1 --auto; xrandr --output VGA1 --right-of eDP1")

  -- external screens off
  , ((modMask .|. shiftMask, xK_f),
     spawn "xrandr --output HDMI1 --off; xrandr --output VGA1 --off")

  -- Swap the focused window and the master window.
  -- , ((modMask, xK_s),
  --    windows W.swapMaster)

  -- Swap the focused window with the next window.
  , ((modMask .|. shiftMask, xK_j),
     windows W.swapDown )

  -- Swap the focused window with the previous window.
  , ((modMask .|. shiftMask, xK_k),
     windows W.swapUp )

  -- Shrink the master area.
  , ((modMask, xK_h),
     sendMessage Shrink)

  -- Expand the master area.
  , ((modMask, xK_l),
     sendMessage Expand)

  -- Push window back into tiling.
  , ((modMask, xK_t),
     withFocused $ windows . W.sink)

  -- Increment the number of windows in the master area.
  , ((modMask, xK_comma),
     sendMessage (IncMasterN 1))

  -- Decrement the number of windows in the master area.
  , ((modMask, xK_period),
     sendMessage (IncMasterN (-1)))

  -- Toggle the status bar gap.
  -- TODO: update this binding with avoidStruts, ((modMask, xK_b),

  -- Quit xmonad.
  , ((modMask .|. shiftMask, xK_q),
     io (exitWith ExitSuccess))

  -- Restart xmonad.
  , ((modMask, xK_q),
     restart "xmonad" True)

  -- rhythmbox
  , ((modMask, xK_n),
     spawn "/usr/bin/rhythmbox-client --next")
  , ((modMask, xK_p),
     spawn "/usr/bin/rhythmbox-client --previous")
  , ((modMask, xK_s),
     spawn "/usr/bin/rhythmbox-client --play-pause")

  -- killer
  , ((modMask .|. shiftMask, xK_x),
     spawn "/usr/bin/xkill")
  ]
  ++
 
  -- mod-[1..9], Switch to workspace N
  -- mod-shift-[1..9], Move client to workspace N
  [((m .|. modMask, k), windows $ f i)
      | (i, k) <- zip (XMonad.workspaces conf) [xK_0 .. xK_9]
      , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
  ++

  -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
  -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
  [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
      | (key, sc) <- zip [xK_e, xK_w] [0..]
      , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
 
------------------------------------------------------------------------
-- Mouse bindings
--
-- Focus rules
-- True if your focus should follow your mouse cursor.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = False

myClickJustFocuses :: Bool
myClickJustFocuses = False
 
myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $
  [
    ((modMask, button1),
      (\w -> focus w >> mouseMoveWindow w)) 
    , ((modMask, button3),
      (\w -> focus w >> mouseResizeWindow w))
 
  ]


------------------------------------------------------------------------
---- Startup hook
---- Perform an arbitrary action each time xmonad starts or is restarted
---- with mod-q. Used by, e.g., XMonad.Layout.PerWorkspace to initialize
---- per-workspace layout choices.
----
---- By default, do nothing.
---- myStartupHook = myStartup
---- 
---- startup :: X ()
---- startup = do
----           spawn ""

startup :: X ()
startup = do
          spawn "./.fehbg"

------------------------------------------------------------------------
-- Run xmonad with all the defaults we set up.
--
-- main = do
--  xmproc <- spawnPipe "/usr/bin/xmobar ~/.xmonad/xmobar.hs"
--  xmonad $ defaults {
--      logHook = dynamicLogWithPP $ xmobarPP {
--            ppOutput = hPutStrLn xmproc
--          , ppTitle = xmobarColor xmobarTitleColor "" . shorten 100
--          , ppCurrent = xmobarColor xmobarCurrentWorkspaceColor ""
--          , ppSep = " "}
--      , startupHook = setWMName "LG3D"
--  }

main = xmonad defaults 

defaults = defaultConfig {
    -- simple stuff
    terminal = myTerminal,
    focusFollowsMouse = myFocusFollowsMouse,
    clickJustFocuses = myClickJustFocuses,
    borderWidth = myBorderWidth,
    modMask = myModMask,
    workspaces = myWorkspaces,
    normalBorderColor = myNormalBorderColor,
    focusedBorderColor = myFocusedBorderColor,
    layoutHook = defaultLayouts,
 
    -- key bindings
    keys = myKeys,
    mouseBindings = myMouseBindings
}
