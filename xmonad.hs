--
-- xmonad example config file.
--
-- A template showing all available configuration hooks,
-- and how to override the defaults in your own xmonad.hs conf file.
--
-- Normally, you'd only override those defaults you care about.
--

import XMonad
import Data.Monoid
import System.Exit

import XMonad.Hooks.DynamicLog
import XMonad.Layout.NoBorders

import qualified Data.Map as M
import qualified XMonad.StackSet as W

-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal      = "/usr/bin/xterm -bg black -fg green -fa hack -fs 11 -ls -sl 65536"

-- Command to launch the bar.
myBar = "killall xmobar; xmobar ~/.xmonad/xmobarrc"

-- Default PrettyPrint. Determines what is being written to the bar.
myPP = xmobarPP { ppCurrent = xmobarColor "#429942" "" . wrap "<" ">" }

-- Key binding to toggle the gap for the bar.
toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)

-- Width of the window border in pixels.
--
myBorderWidth   = 1

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask = mod4Mask

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
myWorkspaces    = ["1","2","3","4","5","6","7","8","9"]

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#555"
myFocusedBorderColor = "#AAA"

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
  ----------------------------------------------------------------------
  -- Custom key bindings
  --

  -- Start a terminal. Terminal to start is specified by myTerminal variable.
  [ ((modm , xK_Return),
     spawn $ XMonad.terminal conf)

  , ((modm .|. shiftMask, xK_Return),
     spawn $ myTerminal)

  -- Launch dmenu via yeganesh.
  -- Use this to launch programs without a key binding.
  , ((modm .|. shiftMask, xK_p),
     spawn "/usr/bin/dmenu_run")
  --   spawn "exe=`dmenu_run | yeganesh` && eval \"exec $exe\"")

  -- Take a screenshot in select mode.
  -- After pressing this key binding, click a window, or draw a rectangle with
  -- the mouse.
  -- , ((modm .|. xK_Print),
  --   spawn "select-screenshot")

  -- Take full screenshot in multi-head mode.
  -- That is, take a screenshot of everything you see.
  , ((modm, xK_Print),
     spawn "gnome-screenshot -f ~/screenshot/screen-shot-`date +'%Y-%m-%dT%H:%M:%S'`.png")

  -- Take screenshot interactive mode.
  , ((modm .|. shiftMask, xK_i),
     spawn "gnome-screenshot -i")

  -- Mute volume.
  , ((0, 0x1008FF12),
     spawn "amixer -q -D pulse set Master toggle")

  -- Decrease volume.
  , ((0, 0x1008FF11),
     spawn "amixer -q -D pulse set Master 10%-")

  -- Increase volume.
  , ((0, 0x1008FF13),
     spawn "amixer -q -D pulse set Master 10%+")

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
     spawn "eject")

  -- calculator
  , ((0, 0x1008FF1D),
     spawn "gnome-calculator")

  --------------------------------------------------------------------
  -- "Standard" xmonad key bindings
  --

  -- Close focused window.
  , ((modm .|. shiftMask, xK_c),
     kill)

  -- Cycle through the available layout algorithms.
  , ((modm, xK_space),
     sendMessage NextLayout)

  -- Reset the layouts on the current workspace to default.
  , ((modm .|. shiftMask, xK_space),
     setLayout $ XMonad.layoutHook conf)

  -- Resize viewed windows to the correct size.
  -- , ((modm, xK_n),
  --   refresh)

  -- Move focus to the next window.
  , ((modm, xK_j),
     windows W.focusDown)

  -- Move focus to the previous window.
  , ((modm, xK_k),
     windows W.focusUp )

  -- Move focus to the master window.
  , ((modm, xK_m),
     windows W.focusMaster )

  -- suspend
  , ((modm .|. shiftMask, xK_s),
     spawn "sudo pm-suspend")

  -- HDMI above
  , ((modm .|. controlMask, xK_Up),
     spawn "xrandr --output HDMI1 --auto --above eDP1")

  -- HDMI left
  , ((modm .|. controlMask, xK_Left),
     spawn "xrandr --output HDMI1 --auto --left-of eDP1")

  -- HDMI right
  , ((modm .|. controlMask, xK_Right),
     spawn "xrandr --output HDMI1 --right-of eDP1")

  -- HDMI off
  , ((modm .|. controlMask, xK_Down),
     spawn "xrandr --output HDMI1 --off")

  -- VGA above
  , ((modm .|. mod1Mask, xK_Up),
     spawn "xrandr --output VGA1 --auto --above eDP1")

  -- VGA left
  , ((modm .|. mod1Mask, xK_Left),
     spawn "xrandr --output VGA1 --auto --left-of eDP1")

  -- VGA right
  , ((modm .|. mod1Mask, xK_Right),
     spawn "xrandr --output VGA1 --auto --right-of eDP1")

  -- VGA off
  , ((modm .|. mod1Mask, xK_Down),
     spawn "xrandr --output VGA1 --off")

  -- external screens on
  , ((modm .|. shiftMask, xK_n),
     spawn "xrandr --output HDMI1 --auto --left-of eDP1; xrandr --output VGA1 --auto --right-of eDP1")

  -- external screens off
  , ((modm .|. shiftMask, xK_f),
     spawn "xrandr --output HDMI1 --off; xrandr --output VGA1 --off")

  -- Swap the focused window and the master window.
  , ((modm, xK_s),
     windows W.swapMaster)

  -- Swap the focused window with the next window.
  , ((modm .|. shiftMask, xK_j),
     windows W.swapDown )

  -- Swap the focused window with the previous window.
  , ((modm .|. shiftMask, xK_k),
     windows W.swapUp )

  -- Shrink the master area.
  , ((modm, xK_h),
     sendMessage Shrink)

  -- Expand the master area.
  , ((modm, xK_l),
     sendMessage Expand)

  -- Push window back into tiling.
  , ((modm, xK_t),
     withFocused $ windows . W.sink)

  -- Increment the number of windows in the master area.
  , ((modm, xK_comma),
     sendMessage (IncMasterN 1))

  -- Decrement the number of windows in the master area.
  , ((modm, xK_period),
     sendMessage (IncMasterN (-1)))

  -- Lock Screen
  , ((modm, xK_z),
      spawn "slock")

  -- Nautilus
  , ((modm, xK_f),
  --    spawn "xfe")
      spawn "thunar")

  -- Control Panel
  , ((modm, xK_c),
      spawn "gnome-control-center; unity-control-center")

  -- Quit xmonad.
  , ((modm .|. shiftMask, xK_q),
     io (exitWith ExitSuccess))

  -- Restart xmonad.
  , ((modm, xK_q),
     restart "xmonad" True)

  -- killer
  , ((modm .|. shiftMask, xK_x),
     spawn "/usr/bin/xkill")
  ]
  ++

  -- mod-[1..9], Switch to workspace N
  -- mod-shift-[1..9], Move client to workspace N
  [((m .|. modm, k), windows $ f i)
      | (i, k) <- zip (XMonad.workspaces conf) [xK_0 .. xK_9]
      , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
  ++

  -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
  -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
  [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
      | (key, sc) <- zip [xK_e, xK_w] [0..]
      , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


------------------------------------------------------------------------
-- Mouse Settings
--
-- Focus rules
-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = False

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
myLayout = tiled ||| Mirror tiled ||| noBorders Full
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
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
--myManageHook = composeAll
--    [ className =? "MPlayer"        --> doFloat
--    , resource  =? "desktop_window" --> doIgnore
--    , resource  =? "kdesktop"       --> doIgnore]

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
myEventHook = mempty

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
myLogHook = return ()

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
myStartupHook = do
                spawn ".xmonad/fehbg"
                spawn "killall stalonetray; stalonetray -c  ~/.xmonad/stalonetrayrc"
                spawn "xautolock -time 10 -locker slock"

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
main = xmonad =<< statusBar myBar myPP toggleStrutsKey defaults

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--
defaults = def {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayout,
        handleEventHook    = myEventHook,
        logHook            = myLogHook,
        startupHook        = myStartupHook
    }
