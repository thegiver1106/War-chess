module General exposing (..)

import Bitwise
import Html exposing (Html)
import Html.Events exposing (onClick)
import String exposing (fromFloat)
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr


{-| Defination on gamestate to record the game's current progress
-}
type GameState
    = Ending
    | Level Int
    | Help Help_type
    | LevelChoosing
    | Setting
    | Logo_Intro
    | Lose_turn_page Int Int
    | Win_turn_page Int Int
    | Beginning_page
    | GameStateChoosing
    | CreatorChoosing


{-| Defination on events to trigger during each level
-}
type Event
    = Impressment
    | CodeNapoleon
    | RewardSol


{-| Turn events to string
-}
event_to_string : Event -> String
event_to_string event =
    case event of
        Impressment ->
            "Impressment"

        CodeNapoleon ->
            "CodeNapoleon"

        RewardSol ->
            "RewardSol"


{-| Defination on the help page
-}
type Help_type
    = Story
    | Operation
    | Division_info
    | Battle_info
    | Back_to_game


{-| Judge whether the game is paused by player
-}
type TimeState
    = Paused
    | Normal


{-| Position on 2 dimensions by float
-}
type alias Point =
    ( Float, Float )


{-| Position on 2 dimensions by Int
-}
type alias Offset =
    ( Int, Int )


{-| Position on 3 dimensions by Int
-}
type alias Cube =
    ( Int, Int, Int )


{-| Defination on the whole map and record screen size
-}
type alias MapSizeArg =
    { map_size : ( Int, Int )
    , block_size : Float

    -- The length of side of the hexagon
    , position_offset : ( Float, Float )

    -- This "offset" means the display offset caused by player' screen movement.
    -- This "offset" has nothing to do with the type Offset
    , velocity : ( Float, Float )
    , zoom_velocity : Float
    , screen_size : ( Float, Float )
    }


{-| Constructions on engineer divs
-}
type Construction
    = Barricades


{-| Constructions on engineer divs in list
-}
cons_ls : List Construction
cons_ls =
    [ Barricades ]


{-| Turn construction to string
-}
cons_to_string : Construction -> String
cons_to_string cons =
    case cons of
        Barricades ->
            "Barricades"


{-| Defination on parts to view
-}
type ViewType
    = ViewBackground
    | ViewTerrain
    | ViewConstruction


{-| Defination on whether the block can be seen
-}
type Visibility
    = OnSight
    | OffSight


{-| Defination on terrains
-}
type Terrain
    = Base
    | Goal
    | Plain
    | Mountain
    | Forest
    | Water


{-| Defination on different nations
-}
type Nation
    = France
    | Britain
    | Austria
    | Russia
    | Prussia


{-| Attach move points needed to each terrain
-}
terrain_to_ap_cost : Terrain -> Int
terrain_to_ap_cost terrain =
    case terrain of
        Mountain ->
            3

        Forest ->
            2

        Water ->
            10000

        _ ->
            1


{-| Attach different color for different nations
-}
nation_to_color : Nation -> String
nation_to_color nation =
    case nation of
        France ->
            "#000080"

        Britain ->
            "red"

        Austria ->
            "#CD6889"

        Russia ->
            "pruple"

        Prussia ->
            "green"


{-| Turn nation to string
-}
nation_to_string : Nation -> String
nation_to_string nation =
    case nation of
        France ->
            "France"

        Britain ->
            "Britain"

        Austria ->
            "Austria"

        Russia ->
            "Russia"

        Prussia ->
            "Prussia"


{-| Turn terrain to string
-}
terrain_to_string : Terrain -> String
terrain_to_string terrain =
    case terrain of
        Mountain ->
            "Mountain"

        Forest ->
            "Forest"

        Water ->
            "Water"

        Plain ->
            "Plain"

        Base ->
            "Base"

        -- Base
        Goal ->
            "Base"


{-| List on all terrains
-}
terrain_list : List Terrain
terrain_list =
    [ Mountain, Forest, Water, Base, Goal ]


{-| Defination on divisions' classes
-}
type Class
    = Fast
    | Guard
    | Engineer
    | Grenadier


{-| Turn class to string
-}
class_to_string : Class -> String
class_to_string class =
    case class of
        Fast ->
            "Fast"

        Guard ->
            "Guard"

        Engineer ->
            "Engineer"

        Grenadier ->
            "Grenadier"


{-| Obtain position according to the offset
-}
offset_to_position : MapSizeArg -> Offset -> Point
offset_to_position map_size_arg offset =
    let
        block_size =
            map_size_arg.block_size

        ( row, col ) =
            offset

        ( dx, dy ) =
            map_size_arg.position_offset

        x =
            block_size * sqrt 3 * (toFloat col + 0.5 * toFloat (Bitwise.and row 1))

        y =
            block_size * 1.5 * toFloat row

        ( nx, ny ) =
            ( x + dx, y + dy )
    in
    ( nx, ny )


{-| Obtain the whole map size
-}
get_valid_map_size_arg : MapSizeArg -> Maybe MapSizeArg
get_valid_map_size_arg map_size_arg =
    let
        ( x_0, y_0 ) =
            offset_to_position map_size_arg ( 0, 0 )

        ( nrow, ncol ) =
            map_size_arg.map_size

        ( x_n, y_n ) =
            offset_to_position map_size_arg ( nrow - 1, ncol - 1 )

        ( x_min, y_min ) =
            ( 0.0, 0.0 )

        ( x_max, y_max ) =
            map_size_arg.screen_size

        x_revision =
            if (x_0 > x_min) && (x_n < x_max) then
                Nothing

            else if x_0 > x_min then
                Just (x_0 - x_min)

            else if x_n < x_max then
                Just (x_n - x_max)

            else
                Just 0.0

        y_revision =
            if (y_0 > x_min) && (y_n < y_max) then
                Nothing

            else if y_0 > y_min then
                Just (y_0 - y_min)

            else if y_n < y_max then
                Just (y_n - y_max)

            else
                Just 0.0

        ( x_off, y_off ) =
            map_size_arg.position_offset

        rev_off =
            case x_revision of
                Nothing ->
                    Nothing

                Just dx ->
                    case y_revision of
                        Nothing ->
                            Nothing

                        Just dy ->
                            Just ( x_off - dx, y_off - dy )
    in
    case rev_off of
        Nothing ->
            Nothing

        Just ro ->
            Just { map_size_arg | position_offset = ro }



-- This is not a bug.


{-| Turn position from 2 dimensions to 3 dimensions
-}
offset_to_cube : Offset -> Cube
offset_to_cube offset =
    let
        ( row, col ) =
            offset

        x =
            col - (row - Bitwise.and row 1) // 2

        z =
            row

        y =
            -x - z
    in
    ( x, y, z )


{-| Turn position from 3 dimensions to 2 dimensions
-}
cube_to_offset : Cube -> Offset
cube_to_offset cube =
    let
        ( x, y, z ) =
            cube

        col =
            x + (z - Bitwise.and z 1) // 2

        row =
            z
    in
    ( row, col )


{-| Obtain distance in 3 dimension coordinate
-}
cube_distance_from_cube : Cube -> Cube -> Int
cube_distance_from_cube c1 c2 =
    let
        ( x1, y1, z1 ) =
            c1

        ( x2, y2, z2 ) =
            c2
    in
    (abs (x1 - x2) + abs (y1 - y2) + abs (z1 - z2)) // 2


{-| Turn point to string
-}
point_to_string : ( Float, Float ) -> String
point_to_string point =
    let
        ( x, y ) =
            point
    in
    fromFloat x ++ "," ++ fromFloat y


{-| Turn points to string
-}
points_to_string : List ( Float, Float ) -> String
points_to_string ls =
    let
        str_ls =
            List.map point_to_string ls

        ls_with_blank =
            List.intersperse " " str_ls
    in
    List.foldl (++) "" ls_with_blank


{-| View the pattern
-}
get_pattern : String -> Svg msg
get_pattern pic_name =
    Svg.defs
        []
        [ Svg.pattern
            [ SvgAttr.id pic_name
            , SvgAttr.height "1"
            , SvgAttr.width "1"
            , SvgAttr.patternContentUnits "objectBoundingBox"
            ]
            [ Svg.image
                [ SvgAttr.height "1"
                , SvgAttr.width "1"
                , SvgAttr.preserveAspectRatio "none"
                , SvgAttr.xlinkHref ("assets/" ++ pic_name ++ ".png")
                ]
                []
            ]
        ]



{-
   base_camp_player : ( Int, Int )
   base_camp_player =
       ( 5, 2 )


   base_camp_enemy : ( Int, Int )
   base_camp_enemy =
       ( 5, 18 )
-}


{-| Time for logo show
-}
time_logo_sequence : Float
time_logo_sequence =
    3200


{-| Offer sight for player
-}
sight_range : Int
sight_range =
    3


{-| Judge whether the selected position is in reach
-}
in_range :
    Float
    -> Offset
    -> Offset
    -> Bool --distance between offset
in_range range pos1 pos2 =
    let
        ( x1, y1 ) =
            pos1

        ( x2, y2 ) =
            pos2
    in
    sqrt (toFloat (x1 - x2) ^ 2 + toFloat (y1 - y2) ^ 2) <= range


{-| Time for generating a div
-}
class_to_gen_time : Class -> Float
class_to_gen_time class =
    case class of
        _ ->
            10000.0


{-| Time for construction
-}
cons_to_gen_time : Construction -> Float
cons_to_gen_time cons =
    case cons of
        _ ->
            10000.0


{-| Defination on construction's status
-}
type ConstructionState
    = Unoccupied
    | Building ( Construction, Int )
    | Finished Construction


{-| Move points cost on constructions
-}
cons_to_ap_cost : Construction -> Int
cons_to_ap_cost cons =
    case cons of
        Barricades ->
            3


{-| Form a paragraph
-}
paragraph : String -> Html msg
paragraph str =
    if str == "" then
        Html.p
            []
            [ Html.br [] [] ]

    else
        Html.p
            []
            [ Html.text str ]


{-| Time for transition pages
-}
time_transition : Float
time_transition =
    2500


{-| Time for Beginning pages
-}
time_beginning_page : Float
time_beginning_page =
    40000
