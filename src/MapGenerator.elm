module MapGenerator exposing (Msg)

import Array exposing (..)
import Bitwise
import Html exposing (Html, a, button, div, text)
import Html.Attributes as HtmlAttr exposing (..)
import Html.Events exposing (keyCode, onClick)
import String exposing (..)
import Svg exposing (..)
import Svg.Attributes as SvgAttr
import Svg.Events



-- type of msg used in generator

{-| Messages used for the map generator-}
type Msg
    = Tick Float
    | Destination Offset
    | Division Int
    | MouseOverBlock Offset
    | MouseOutBlock Offset
    | Commander Int
    | ChangeMindset Int
    | Block_chosen ( Int, Int )
    | Select_terrain Int
    | Size ( Int, Int )



-- type of Model in generator


type alias Model =
    { map : Map
    , status : Status
    , chosen_block : Offset
    }


type Status
    = Activated
    | Locked


block_size =
    600.0


type alias Map =
    Array (Array Block)


type Terrain
    = Base
    | Goal
    | Plain
    | Mountain
    | Forest
    | Water


type alias Point =
    ( Float, Float )


type alias Offset =
    ( Int, Int )


type alias Cube =
    ( Int, Int, Int )


type Nation
    = France
    | Britain
    | Austria
    | Russia
    | Prussia


type alias Block =
    { offset : Offset
    , cube : Cube
    , terrain : Terrain
    , ap_cost : Int
    , nation : Nation
    , mouse_on : Bool
    }


type ViewType
    = ViewBackground
    | ViewTerrain



--init single block and its components


init_block : Offset -> Block
init_block offset =
    Block offset (offset_to_cube offset) Plain (terrain_to_ap_cost Plain) France False


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



-- init the whole map


init : ( Int, Int ) -> Model
init size =
    let
        ( nrow, ncol ) =
            size

        arr =
            List.map (\x -> get_row x ncol) (List.range 0 (nrow - 1))
                |> Array.fromList
    in
    Model arr Locked ( -1, -1 )



-- from view.elm


get_row : Int -> Int -> Array Block
get_row row ncol =
    List.map (\x -> block_terrain_init ( x, row )) (List.range 0 (ncol - 1))
        |> Array.fromList


block_terrain_init : ( Int, Int ) -> Block
block_terrain_init ( col, row ) =
    init_block ( col, row )



-- view block


view_block : ViewType -> Block -> Svg Msg
view_block view_type block =
    let
        ( x, y ) =
            block_to_position block

        ( w, h ) =
            ( block_size * sqrt 3, block_size * 2.0 )

        points_str =
            points_to_string (get_points_list ( x, y ) block_size)
    in
    Svg.polygon
        [ SvgAttr.points points_str
        , SvgAttr.width "100%"
        , SvgAttr.height "100%"
        , Svg.Events.onClick (Block_chosen block.offset)
        , Svg.Events.onMouseOver (MouseOverBlock block.offset)
        , Svg.Events.onMouseOut (MouseOutBlock block.offset)
        , SvgAttr.fill
            (case view_type of
                ViewTerrain ->
                    "url(#" ++ terrain_to_string block.terrain ++ ")"

                ViewBackground ->
                    nation_to_color block.nation
            )
        , SvgAttr.stroke
            (if block.mouse_on then
                "yellow"

             else
                "white"
            )
        , SvgAttr.strokeWidth
            (if block.mouse_on then
                "60"

             else
                "20"
            )
        , SvgAttr.strokeLinejoin "round"
        , SvgAttr.opacity
            (case view_type of
                ViewTerrain ->
                    "1"

                ViewBackground ->
                    "0.5"
            )
        ]
        []


block_to_position : Block -> ( Float, Float )
block_to_position block =
    offset_to_position block.offset


offset_to_position : Offset -> Point
offset_to_position offset =
    let
        ( row, col ) =
            offset

        x =
            block_size * sqrt 3 * (Basics.toFloat col + 0.5 * Basics.toFloat (Bitwise.and row 1)) - 8 * block_size

        y =
            block_size * 1.5 * Basics.toFloat row
    in
    ( x, y )


get_points_list : ( Float, Float ) -> Float -> List ( Float, Float )
get_points_list pos size =
    let
        ( x, y ) =
            pos

        angles =
            List.map (\t -> Basics.toFloat (30 + 60 * t)) (List.range 0 5)

        angle_to_point =
            \t -> ( x + size * cos (degrees t), y + size * sin (degrees t) )
    in
    List.map angle_to_point angles
        |> List.reverse


point_to_string : ( Float, Float ) -> String
point_to_string point =
    let
        ( x, y ) =
            point
    in
    fromFloat x ++ "," ++ fromFloat y


points_to_string : List ( Float, Float ) -> String
points_to_string ls =
    let
        str_ls =
            List.map point_to_string ls

        ls_with_blank =
            List.intersperse " " str_ls
    in
    List.foldl (++) "" ls_with_blank


nation_to_color : Nation -> String
nation_to_color nation =
    case nation of
        France ->
            "blue"

        Britain ->
            "red"

        Austria ->
            "pink"

        Russia ->
            "pruple"

        Prussia ->
            "green"



-- view map


view_map : Model -> List (Svg Msg)
view_map model =
    let
        nested_terrain =
            Array.map (view_row ViewTerrain) model.map

        nested_background =
            Array.map (view_row ViewBackground) model.map

        block_ls_terrain =
            Array.foldl Array.append Array.empty nested_terrain

        block_ls_background =
            Array.foldl Array.append Array.empty nested_background

        terrain_str_ls =
            List.map terrain_to_string terrain_list
    in
    List.map get_pattern terrain_str_ls
        |> List.append (Array.toList block_ls_terrain)
        |> List.append (Array.toList block_ls_background)


get_pattern : String -> Svg Msg
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


view_row : ViewType -> Array Block -> Array (Svg Msg)
view_row view_type row =
    Array.map (view_block view_type) row


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

        Goal ->
            "temp"


terrain_list : List Terrain
terrain_list =
    [ Mountain, Forest, Water, Base, Goal ]



-- whole view


view : Model -> Html Msg
view model =
    case model.status of
        Locked ->
            div
                [ HtmlAttr.style "width" "100%"
                , HtmlAttr.style "height" "100%"
                , HtmlAttr.style "position" "fixed"
                , HtmlAttr.style "left" "0"
                , HtmlAttr.style "top" "0"
                ]
                [ {- view_divisions model.player.army
                     , turn_map_list model.map |> view_background
                     , view_divisions_button model.player.army
                  -}
                  {- div
                     [ HtmlAttr.style "position" "absolute"
                     , HtmlAttr.style "width" "100%"
                     , HtmlAttr.style "height" "100%"
                     , HtmlAttr.style "left" "0"
                     , HtmlAttr.style "top" "0"
                     ]
                     [
                     ]
                  -}
                  Svg.svg
                    [ SvgAttr.width "100%"
                    , SvgAttr.height "100%"
                    , SvgAttr.viewBox "0 0 10000 10000"
                    ]
                    (List.concat
                        [ view_map model
                        ]
                    )
                ]

        _ ->
            div
                [ HtmlAttr.style "width" "100%"
                , HtmlAttr.style "height" "100%"
                , HtmlAttr.style "position" "fixed"
                , HtmlAttr.style "left" "0"
                , HtmlAttr.style "top" "0"
                ]
                [ button_info 1 80 "Plain"
                , button_info 2 160 "Forest"
                , button_info 3 240 "Mountain"
                , button_info 4 320 "Base"
                , button_info 5 400 "Goal"
                ]


button_info : Int -> Int -> String -> Html Msg
button_info n top text =
    Html.button
        (List.append
            [ Html.Events.onClick (Select_terrain n)
            , HtmlAttr.style "background" "rgb(248,241,228)"
            , HtmlAttr.style "border" "0"
            , HtmlAttr.style "bottom" "50%"
            , HtmlAttr.style "color" "rgb(248,116,116)"
            , HtmlAttr.style "cursor" "pointer"
            , HtmlAttr.style "font-family" "Helvetica, Arial, sans-serif"
            , HtmlAttr.style "display" "block"
            , HtmlAttr.style "font-size" "18px"
            ]
            [ HtmlAttr.style "font-weight" "300"
            , HtmlAttr.style "height" "60px"
            , HtmlAttr.style "left" "2%"
            , HtmlAttr.style "top" (fromInt top ++ "px")
            , HtmlAttr.style "line-height" "60px"
            , HtmlAttr.style "outline" "none"
            , HtmlAttr.style "position" "absolute"
            , HtmlAttr.style "width" "120px"
            , HtmlAttr.style "border-radius" "10%"
            ]
        )
        [ Html.text text ]



-- Update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Block_chosen ( int_1, int_2 ) ->
            ( { model | status = Activated, chosen_block = ( int_1, int_2 ) }, Cmd.none )

        Select_terrain int_3 ->
            case int_3 of
                1 ->
                    ( { model | status = Locked, chosen_block = ( -1, -1 ), map = change_map model.map model.chosen_block Plain }, Cmd.none )

                2 ->
                    ( { model | status = Locked, chosen_block = ( -1, -1 ), map = change_map model.map model.chosen_block Forest }, Cmd.none )

                3 ->
                    ( { model | status = Locked, chosen_block = ( -1, -1 ), map = change_map model.map model.chosen_block Mountain }, Cmd.none )

                4 ->
                    ( { model | status = Locked, chosen_block = ( -1, -1 ), map = change_map model.map model.chosen_block Base }, Cmd.none )

                5 ->
                    ( { model | status = Locked, chosen_block = ( -1, -1 ), map = change_map model.map model.chosen_block Goal }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        _ ->
            ( model, Cmd.none )


change_block : Offset -> Terrain -> Block
change_block offset terrain =
    let
        cube =
            offset_to_cube offset

        ap_cost =
            terrain_to_ap_cost terrain
    in
    Block offset cube terrain ap_cost Russia False


change_map : Map -> Offset -> Terrain -> Map
change_map map offset terrain =
    let
        int_1 =
            Tuple.first offset

        int_2 =
            Tuple.second offset

        col =
            Array.get int_1 map

        row =
            Array.get int_2 (fk_maybe col)

        changed_row =
            Array.set int_2 (change_block offset terrain) (fk_maybe col)

        changed_col =
            Array.set int_1 changed_row map
    in
    changed_col


fk_maybe : Maybe (Array Block) -> Array Block
fk_maybe array_1 =
    case array_1 of
        Nothing ->
            Array.empty

        Just array ->
            array



--subscription
