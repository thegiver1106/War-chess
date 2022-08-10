module Block exposing (..)

import Array exposing (Array)
import Bitwise
import General exposing (..)
import Html exposing (Attribute)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Decode
import Msg exposing (..)
import Set exposing (Set)
import String exposing (fromFloat, fromInt)
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr
import Svg.Events

{-| Definition of a single block in the map-}
type alias Block =
    { offset : Offset
    , cube : Cube
    , terrain : Terrain
    , ap_cost : Int
    , nation : Nation
    , mouse_over : Bool
    , visible : Visibility -- indicates visibility
    , construction : Maybe Construction
    }

{-| The initialization of block-}
init : Offset -> Terrain -> Nation -> Block
init offset terrain nation =
    let
        cube =
            offset_to_cube offset

        ap_cost =
            terrain_to_ap_cost terrain
    in
    Block offset cube terrain ap_cost nation False OnSight Nothing

{-| Update Changes in a block after certain operation-}
update : Msg -> Block -> Block
update msg block =
    case msg of
        MouseOverBlock offset ->
            if block.offset == offset then
                { block | mouse_over = True }

            else
                { block | mouse_over = False }

        MouseOutBlock offset ->
            if block.offset == offset then
                { block | mouse_over = False }

            else
                block
        
        BlockChangeMsg block_change ->
            if block.mouse_over then
                let
                    n_nation = 
                        case block_change of
                            ChangeNation nat -> nat
                            _ -> block.nation
                    n_terrain = 
                        case block_change of
                            ChangeTerrain ter -> ter
                            _ -> block.terrain 
                in
                    { block | nation = n_nation, terrain = n_terrain }      
            else
                block                     

        _ ->
            block
{-| Update the changes to a block when the player commands an engineer division to construct barricades-}
build_block : Construction -> Offset -> Block -> Block
build_block cons offset block = 
    if block.offset == offset then
        { block | construction = Just cons, ap_cost = block.ap_cost + (cons_to_ap_cost cons) }
    else
        block
{-| Provide a default value for the non-existing blocks-}
error_block : Block
error_block =
    init ( -1, -1 ) General.Plain General.Russia

{-| Provide a calculation method for the distance between to blocks-}
cube_distance : Block -> Block -> Int
cube_distance b1 b2 =
    cube_distance_from_cube b1.cube b2.cube

{-| Draw a hexagon according to its offset-}
get_points_list : ( Float, Float ) -> Float -> List ( Float, Float )
get_points_list pos size =
    let
        ( x, y ) =
            pos

        angles =
            List.map (\t -> toFloat (30 + 60 * t)) (List.range 0 5)

        angle_to_point =
            \t -> ( x + size * cos (degrees t), y + size * sin (degrees t) )
    in
    List.map angle_to_point angles
        |> List.reverse

{-| The view funciton for a single block-}
view : MapSizeArg -> ViewType -> Block -> Svg Msg
view map_size_arg view_type block =
    let
        ( x, y ) =
            offset_to_position map_size_arg block.offset

        block_size =
            map_size_arg.block_size

        ( w, h ) =
            ( block_size * sqrt 3, block_size * 2.0 )

        points_str =
            points_to_string (get_points_list ( x, y ) block_size)
    in
    Svg.polygon
        [ SvgAttr.points points_str
        , onContextMenu (Destination block.offset)
        , Svg.Events.onMouseOver (MouseOverBlock block.offset)
        , Svg.Events.onMouseOut (MouseOutBlock block.offset)
        , SvgAttr.fill
            (if (view_type == General.ViewConstruction) then
                (case block.construction of
                        Nothing -> "red"
                        Just cons -> "url(#" ++ cons_to_string cons ++ ")")
            else if (block.visible == OnSight) then  
                (case view_type of  
                    ViewTerrain -> "url(#" ++ (terrain_to_string block.terrain) ++ ")"
                    ViewBackground -> (nation_to_color block.nation)
                    _ -> "black" ) 
            else 
                (case view_type of  
                    ViewTerrain -> "url(#" ++ (terrain_to_string block.terrain) ++ ")"
                    ViewBackground -> (nation_to_color block.nation)
                    _ -> "black" ))
        , SvgAttr.stroke
            (if block.mouse_over then
                "yellow"

             else
                "white"
            )
        , SvgAttr.strokeWidth
            (if block.mouse_over then
                "6"

             else
                "2"
            )
        , SvgAttr.strokeLinejoin "round"
        , SvgAttr.opacity 
            (if (block.visible == OnSight) then
                (case view_type of
                    ViewTerrain ->
                        "1"
                    ViewConstruction ->
                        "1"
                    ViewBackground ->
                        case block.visible of 
                            OnSight -> "0.5"
                            OffSight -> "1"
                )
            else 
                (case view_type of
                    ViewTerrain ->
                        "0.3"
                    ViewConstruction ->
                        "1"
                    ViewBackground ->
                        case block.visible of 
                            OnSight -> "0.5"
                            OffSight -> "1"
                )
            )
        ]
        []

{-| Determine whether a point can be shown in the current screen-}
position_in_cur_screen : MapSizeArg -> Point -> Bool
position_in_cur_screen map_size_arg point =
    let
        ( x, y ) =
            point

        ( x_min, y_min ) =
            ( 0.0, 0.0 )

        ( x_max, y_max ) =
            map_size_arg.screen_size
    in
    (x >= x_min) && (x <= x_max) && (y >= y_min) && (y <= y_max)

{-| Determine whether the position of a single block is shown in the current screen under the zooming in and zooming out operations-}
block_in_cur_screen : MapSizeArg -> Block -> Bool
block_in_cur_screen map_size_arg block =
    let
        ( x, y ) =
            offset_to_position map_size_arg block.offset

        points =
            get_points_list ( x, y ) map_size_arg.block_size
    in
    List.any (position_in_cur_screen map_size_arg) points

{-| Provide an Html event of onClick with right side of mouse-}
onContextMenu : msg -> Attribute msg
onContextMenu msg =
    preventDefaultOn "contextmenu" (Decode.map alwaysPreventDefault (Decode.succeed msg))

{-| Prevent the default message provided by the browser-}
alwaysPreventDefault : msg -> ( msg, Bool )
alwaysPreventDefault msg =
    ( msg, True )

{-| Turn a block's message into the form of string-}
block_to_string : Block -> String
block_to_string block = 
    let
        terrain_str = terrain_to_string block.terrain
        nation_str = nation_to_string block.nation
        (x, y) = block.offset
        position_str = "(" ++ (fromInt x) ++ "," ++ (fromInt y) ++")"
    in
        position_str ++ " " ++ terrain_str ++ " " ++ nation_str ++ "\n"