module Msg exposing (..)

import Browser.Dom exposing (Viewport)
import Commander exposing (..)
import File.Download as Download
import General exposing (..)
import Svg.Attributes exposing (direction)

{-| Definition of Msg-}
type Msg
    = Tick Float
    | Destination Offset
    | Division Int -- choose which division
    | MouseOverBlock Offset
    | MouseOutBlock Offset
    | MoveScreen (SettingStatus MoveStatus)
    | Zoom ZoomStatus
    | GetViewport Viewport
    | Conscript Class
    | KeyNone
    | Cancel Int -- to cancel a selection of division
    | Pile Int -- how many divisions are piled up together in one block
    | Commander1
    | AssignCommander ( Commander, Int )
    | ChangeMindset Int
    | ChangePlayingState
    | ChangeGameState GameState
    | Activate ActiType
    | Helpmsg Help_type
    | Eventmsg Event
    | ConstructionMsg ( Construction, Int )
    | TimeSpeedChangeMsg TimeSpeedChange
    | Next_page
    | BlockChangeMsg BlockChange
    | OutputMap
    | Win_level_1
    | Lose_level_2

{-| Definition of BlockChange-}
type BlockChange
    = ChangeNation Nation
    | ChangeTerrain Terrain

{-| Definition of TimeChange-}
type TimeSpeedChange
    = Increasement
    | Decreasement

{-| Definition of ActiType-}
type ActiType
    = ActiEvents
    | ActiBase

{-| Definition of SettingStatus-}
type SettingStatus v
    = On v
    | Off

{-| Definition of ZoomStatus-}
type ZoomStatus
    = In
    | Out

{-| Definition of MoveStatus-}
type MoveStatus
    = Up
    | Down
    | Left
    | Right
