module Prompt exposing (view_commanders, view_div_with_same_pos, view_divisions, view_enemy_divisions, view_info)

import Array
import Block exposing (..)
import Commander exposing (..)
import Div exposing (..)
import Enemy exposing (get_visibility_enemy)
import General exposing (..)
import Html exposing (Html, div, param)
import Html.Attributes as HtmlAttr exposing (..)
import Html.Events exposing (keyCode, onClick)
import Map exposing (..)
import Model exposing (..)
import Msg exposing (..)
import Set
import String exposing (fromFloat, fromInt)
import Svg exposing (..)
import Svg.Attributes as SvgAttr exposing (..)
import Svg.Events
import Update exposing (press_map)
import VirtualDom


check_pos : Div -> Offset -> Bool
check_pos div offset =
    if div.offset == offset then
        True

    else
        False


multi_div_positions :
    List Div
    -> Offset
    -> List Div --get the list of positions that have multiple divisions.
multi_div_positions list offset =
    List.filter (\x -> check_pos x offset) list


check_block : Offset -> List Div -> Bool
check_block offset list =
    if List.length (multi_div_positions list offset) > 1 then
        True

    else
        False


get_block_offset : Block -> Offset
get_block_offset block =
    block.offset


check_all_map :
    Map
    -> Model
    -> List Offset --get the positions of all the blocks that have multiple divisions from one side.
check_all_map map model =
    let
        reduced_map =
            Update.press_map map.blocks

        all_div =
            model.player.army
    in
    Array.filter (\x -> check_block x.offset all_div) reduced_map
        |> Array.toList
        |> List.map get_block_offset


div_with_same_pos : Offset -> List Div -> List Div
div_with_same_pos offset list =
    List.filter (\x -> x.offset == offset) list



-- view part for the piled divisions


{-| Extra view when divs are in same positions
-}
view_div_with_same_pos : Offset -> List Div -> Html Msg
view_div_with_same_pos offset list =
    div_with_same_pos offset list
        |> view_piled_div


view_piled_div : List Div -> Html Msg
view_piled_div list_1 =
    let
        new_list =
            List.indexedMap Tuple.pair list_1
    in
    div
        [ HtmlAttr.style "position" "absolute"
        , HtmlAttr.style "width" "1%"
        , HtmlAttr.style "height" "1%"
        ]
        (List.map (\x -> view_one_piled_div x) new_list)


view_one_piled_div : ( Int, Div ) -> Html Msg
view_one_piled_div ( int, division ) =
    Html.button
        (List.append
            [ Html.Events.onClick (Division division.number)
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
            , HtmlAttr.style "top" (String.fromInt (int * 80) ++ "px")
            , HtmlAttr.style "line-height" "60px"
            , HtmlAttr.style "outline" "none"
            , HtmlAttr.style "position" "absolute"
            , HtmlAttr.style "width" "120px"
            , HtmlAttr.style "border-radius" "10%"
            ]
        )
        [ Html.text ("Division" ++ String.fromInt division.number) ]



-- view part for information prompts up


view_unit_commander : Div -> Svg Msg
view_unit_commander div =
    let
        picture_url =
            "assets/" ++ div.commander.name ++ ".png"
    in
    if div.commander == default_commander then
        Svg.image
            [ SvgAttr.x "0px"
            , SvgAttr.y "0px"
            , SvgAttr.width "0px"
            , SvgAttr.height "0px"
            , SvgAttr.scale "10"
            ]
            []

    else
        Svg.image
            [ SvgAttr.xlinkHref picture_url
            , SvgAttr.x (fromFloat 175.0 ++ "px")
            , SvgAttr.y (fromFloat 10.0 ++ "px")
            , SvgAttr.width (fromFloat 75.0 ++ "px")
            , SvgAttr.height (fromFloat 75.0 ++ "px")
            , SvgAttr.scale "10"
            ]
            []


make_text_table_row : List String -> Html Msg
make_text_table_row lst =
    let
        make_td =
            \x -> Html.td [] [ Html.text x ]
    in
    Html.tr
        []
        (List.map make_td lst)


view_info_text : Div -> Html Msg
view_info_text div =
    Html.div
        [ HtmlAttr.style "top" "0%"
        , HtmlAttr.style "left" "0%"
        , HtmlAttr.style "fill" "blue"
        , HtmlAttr.style "font-size" "12"
        , HtmlAttr.style "font-weight" "700"
        , HtmlAttr.style "position" "absolute"
        , HtmlAttr.style "font-family" "Times New Roman, Arial, sans-serif"
        , HtmlAttr.style "line-height" "70%"
        ]
        [ Html.table
            []
            [ make_text_table_row [ "ID", fromInt div.number ]
            , make_text_table_row [ "Nation", nation_to_string div.nation ]
            , make_text_table_row [ "Class", class_to_string div.class ]
            , make_text_table_row [ "HP", fromInt div.hp ++ "/" ++ fromInt div.initial_hp ]
            , make_text_table_row [ "Attack", " +1800 (from HP)", "+100 (from Terrian)" ]
            ]
        ]


{-| View information on selected divisions
-}
view_info : Div -> List (Svg Msg)
view_info division =
    if division == error_div then
        []

    else
        [ Svg.rect
            [ SvgAttr.x (fromFloat 300.0)
            , SvgAttr.y (fromFloat 0.0)
            , SvgAttr.width (fromFloat 300.0)
            , SvgAttr.height (fromFloat 100.0)
            , SvgAttr.fill "brown"
            , SvgAttr.stroke "black"
            , SvgAttr.strokeWidth "5"
            , Html.Events.onClick Commander1
            ]
            []
        , view_unit_commander division
        , Svg.text_
            [ SvgAttr.x (fromFloat 450.0)
            , SvgAttr.y (fromFloat 40.0)
            , SvgAttr.fill "black"
            , SvgAttr.fontSize (fromFloat 12)
            , SvgAttr.fontWeight "700"
            , SvgAttr.dominantBaseline "middle"
            , SvgAttr.textAnchor "middle"
            , Html.Events.onClick Commander1
            ]
            [ VirtualDom.text (" Division: " ++ fromInt division.number)
            ]
        , Svg.text_
            [ SvgAttr.x (fromFloat 450.0)
            , SvgAttr.y (fromFloat 55.0)
            , SvgAttr.fill "black"
            , SvgAttr.fontSize (fromFloat 12)
            , SvgAttr.fontWeight "700"
            , SvgAttr.dominantBaseline "middle"
            , SvgAttr.textAnchor "middle"
            , Html.Events.onClick Commander1
            ]
            [ VirtualDom.text (" Remaining Soldiers: " ++ fromInt division.hp) ]
        , Svg.text_
            [ SvgAttr.x (fromFloat 450.0)
            , SvgAttr.y (fromFloat 70.0)
            , SvgAttr.fill "black"
            , SvgAttr.fontSize (fromFloat 12)
            , SvgAttr.fontWeight "700"
            , SvgAttr.dominantBaseline "middle"
            , SvgAttr.textAnchor "middle"
            , Html.Events.onClick Commander1
            ]
            [ VirtualDom.text (" Commander: " ++ division.commander.name) ]
        ]


{-| View divisions
-}
view_divisions : MapSizeArg -> List Div -> List Div -> Float -> List (Svg Msg)
view_divisions map_size_arg list_player list_enemy time =
    List.map (\x -> view_unit map_size_arg x list_player list_enemy time) list_player
        |> List.concat


{-| View enemy's divisions
-}
view_enemy_divisions : Map -> MapSizeArg -> List Div -> List Div -> Offset -> Float -> List (Svg Msg)
view_enemy_divisions map map_size_arg list_player list_enemy base_offset time =
    let
        player_position =
            List.map (\x -> x.offset) list_player ++ [ base_offset ]

        player_sight =
            List.concatMap (\x -> Set.toList (get_offsets_within_n_jumps map x General.sight_range)) player_position

        nlist_enemy =
            List.filter (\x -> List.member x.offset player_sight) list_enemy
    in
    List.map (\x -> view_unit map_size_arg x list_player nlist_enemy time) nlist_enemy
        |> List.concat


mod_2_time : Float -> Int
mod_2_time time =
    let
        t =
            200
    in
    if modBy t (Basics.floor time) <= floor (toFloat t / 2.0) then
        1

    else
        2


mod_3_time : Float -> Int
mod_3_time time =
    let
        t =
            300
    in
    if modBy t (Basics.floor time) <= floor (toFloat t / 3.0) then
        1

    else if modBy t (Basics.floor time) <= floor (toFloat t / 3.0 * 2.0) then
        2

    else
        3


view_unit : MapSizeArg -> Div -> List Div -> List Div -> Float -> List (Svg Msg)
view_unit map_size_arg div list_player list_enemy time =
    let
        width =
            map_size_arg.block_size * 1.25

        height =
            width / 23.0 * 29.0

        ( x, y ) =
            offset_to_position map_size_arg div.offset

        ( nx, ny ) =
            if div.judge.is_enemy then
                ( x - width / 2 - width / 6, y - height / 2 - height / 3.5 )

            else
                ( x - width / 2 + width / 6, y - height / 2 - height / 3.5 )

        ( picture_file, animation ) =
            if div.judge.is_enemy then
                judge_view_div_type_enemy div list_player

            else
                judge_view_div_type_player div list_enemy

        picture_url =
            if animation == False then
                "assets/" ++ picture_file ++ ".png"

            else if picture_file == "France_Grenadier_battle" || picture_file == "Russia_Grenadier_battle" || picture_file == "Britain_Grenadier_battle" || picture_file == "Prussia_Grenadier_battle" || picture_file == "Austria_Grenadier_battle" then
                "assets/" ++ picture_file ++ "/" ++ fromInt (mod_3_time time) ++ ".png"

            else
                "assets/" ++ picture_file ++ "/" ++ fromInt (mod_2_time time) ++ ".png"

        msg_left =
            Division div.number

        msg_right =
            Destination div.offset

        icon_url =
            "./assets/" ++ class_to_string div.class ++ "_icon.png"

        bar_height =
            20.0

        bar_width =
            bar_height * 3.5
    in
    show_view_unit nx ny ( picture_url, icon_url ) ( width, height ) msg_left msg_right div ( bar_height, bar_width ) map_size_arg


show_view_unit : Float -> Float -> ( String, String ) -> ( Float, Float ) -> Msg -> Msg -> Div -> ( Float, Float ) -> MapSizeArg -> List (Svg Msg)
show_view_unit nx ny ( picture_url, icon_url ) ( width, height ) msg_left msg_right div ( bar_height, bar_width ) map_size_arg =
    -- division itself
    [ Svg.image
        [ SvgAttr.xlinkHref picture_url
        , SvgAttr.x (fromFloat nx ++ "px")
        , SvgAttr.y (fromFloat ny ++ "px")
        , SvgAttr.width (fromFloat width ++ "px")
        , SvgAttr.height (fromFloat height ++ "px")
        , SvgAttr.scale "10"
        , Html.Events.onClick msg_left
        , Block.onContextMenu msg_right
        , Html.Events.onDoubleClick (Cancel div.number)
        ]
        []

    -- route
    , view_route map_size_arg div
    ]
        ++ show_view_unit_2 nx
            ny
            ( picture_url, icon_url )
            ( width, height )
            msg_left
            msg_right
            div
            ( bar_height, bar_width )
            map_size_arg
        -- icon background
        -- hp text
        ++ [ Svg.text_
                [ SvgAttr.x (fromFloat (nx - 1.5 * bar_height + bar_height + bar_width / 2.0))
                , SvgAttr.y (fromFloat (ny - 1.5 * bar_height + bar_height / 2.0 / 2.0 + 1.0))
                , SvgAttr.fill "black"
                , SvgAttr.fontSize (fromFloat 12)
                , SvgAttr.fontWeight "700"
                , SvgAttr.dominantBaseline "middle"
                , SvgAttr.textAnchor "middle"
                ]
                [ VirtualDom.text (fromInt div.hp) ]

           -- exp bar
           , Svg.rect
                [ SvgAttr.x (fromFloat (nx - 1.5 * bar_height + bar_height))
                , SvgAttr.y (fromFloat (ny - 1.5 * bar_height + 0.5 * bar_height))
                , SvgAttr.width (fromFloat (bar_width * toFloat div.judge.exp / toFloat 100))
                , SvgAttr.height (fromFloat (bar_height / 2.0))
                , SvgAttr.fill "blue"
                ]
                []

           -- hp text
           , Svg.text_
                [ SvgAttr.x (fromFloat (nx - 1.5 * bar_height + bar_height + bar_width / 2.0))
                , SvgAttr.y (fromFloat (ny - 1.5 * bar_height + 0.5 * bar_height + bar_height / 2.0 / 2.0 + 1.0))
                , SvgAttr.fill "black"
                , SvgAttr.fontSize (fromFloat 12)
                , SvgAttr.fontWeight "700"
                , SvgAttr.dominantBaseline "middle"
                , SvgAttr.textAnchor "middle"
                ]
                [ VirtualDom.text (fromInt div.judge.exp) ]
           , Svg.rect
                [ SvgAttr.x (fromFloat (nx - 1.5 * bar_height))
                , SvgAttr.y (fromFloat (ny - 1.5 * bar_height))
                , SvgAttr.width (fromFloat (bar_width + bar_height))
                , SvgAttr.height (fromFloat bar_height)
                , SvgAttr.fill "white"
                , SvgAttr.fillOpacity "0.0"
                , SvgAttr.stroke "yellow"
                , SvgAttr.strokeWidth "3"
                , SvgAttr.strokeOpacity
                    (if div.judge.selected then
                        "1.0"

                     else
                        "0.0"
                    )
                , Html.Events.onClick msg_left
                , Block.onContextMenu msg_right
                , Html.Events.onDoubleClick (Cancel div.number)
                ]
                []
           ]


show_view_unit_2 : Float -> Float -> ( String, String ) -> ( Float, Float ) -> Msg -> Msg -> Div -> ( Float, Float ) -> MapSizeArg -> List (Svg Msg)
show_view_unit_2 nx ny ( picture_url, icon_url ) ( width, height ) msg_left msg_right div ( bar_height, bar_width ) map_size_arg =
    [ Svg.rect
        [ SvgAttr.x (fromFloat (nx - 1.5 * bar_height))
        , SvgAttr.y (fromFloat (ny - 1.5 * bar_height))
        , SvgAttr.width (fromFloat bar_height)
        , SvgAttr.height (fromFloat bar_height)
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "2"
        ]
        []
    , Svg.rect
        [ SvgAttr.x (fromFloat (nx - 1.5 * bar_height))
        , SvgAttr.y (fromFloat (ny - 1.5 * bar_height))
        , SvgAttr.width (fromFloat bar_height)
        , SvgAttr.height (fromFloat bar_height)
        , SvgAttr.fill (nation_to_color div.nation)
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "2"
        , SvgAttr.opacity "0.7"
        ]
        []

    -- icon itself
    , Svg.image
        [ SvgAttr.xlinkHref icon_url
        , SvgAttr.x (fromFloat (nx - 1.5 * bar_height))
        , SvgAttr.y (fromFloat (ny - 1.5 * bar_height))
        , SvgAttr.width (fromFloat bar_height)
        , SvgAttr.height (fromFloat bar_height)
        ]
        []

    -- bar background
    , Svg.rect
        [ SvgAttr.x (fromFloat (nx - 1.5 * bar_height + bar_height))
        , SvgAttr.y (fromFloat (ny - 1.5 * bar_height))
        , SvgAttr.width (fromFloat bar_width)
        , SvgAttr.height (fromFloat bar_height)
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "2"
        ]
        []

    -- hp bar
    , Svg.rect
        [ SvgAttr.x (fromFloat (nx - 1.5 * bar_height + bar_height))
        , SvgAttr.y (fromFloat (ny - 1.5 * bar_height))
        , SvgAttr.width (fromFloat (bar_width * toFloat div.hp / toFloat div.initial_hp))
        , SvgAttr.height (fromFloat (bar_height / 2.0))
        , SvgAttr.fill "red"
        ]
        []
    ]


judge_view_div_type_enemy : Div -> List Div -> ( String, Bool )
judge_view_div_type_enemy div list_player =
    let
        nation =
            case div.nation of
                Austria ->
                    "Austria"

                Russia ->
                    "Russia"

                Prussia ->
                    "Prussia"

                Britain ->
                    "Britain"

                France ->
                    "France"

        div_type =
            case div.class of
                Fast ->
                    "Fast"

                Guard ->
                    "Guard"

                Engineer ->
                    "Engineer"

                Grenadier ->
                    "Grenadier"
    in
    if in_battle_judge div list_player == True then
        ( nation ++ "_" ++ div_type ++ "_Battle", True )

    else if ((div.route |> List.reverse |> List.head |> Maybe.withDefault ( -1, -1 )) /= div.offset) && ((div.route |> List.reverse |> List.head |> Maybe.withDefault ( -1, -1 )) /= ( -1, -1 )) then
        ( nation ++ "_" ++ div_type ++ "_Moving", True )

    else
        ( div_type ++ "_div_" ++ nation, False )


judge_view_div_type_player : Div -> List Div -> ( String, Bool )
judge_view_div_type_player div list_enemy =
    let
        nation =
            "France"

        div_type =
            case div.class of
                Fast ->
                    "Fast"

                Guard ->
                    "Guard"

                Engineer ->
                    "Engineer"

                Grenadier ->
                    "Grenadier"
    in
    if in_battle_judge div list_enemy == True then
        ( nation ++ "_" ++ div_type ++ "_Battle", True )

    else if ((div.route |> List.reverse |> List.head |> Maybe.withDefault ( -1, -1 )) /= div.offset) && ((div.route |> List.reverse |> List.head |> Maybe.withDefault ( -1, -1 )) /= ( -1, -1 )) then
        ( nation ++ "_" ++ div_type ++ "_Moving", True )

    else
        ( div_type ++ "_div_" ++ nation, False )


in_battle_judge : Div -> List Div -> Bool
in_battle_judge div list =
    if (List.filter (\x -> x.offset == div.offset) list |> List.length) /= 0 then
        True

    else
        False



--view commander selection


{-| View commanders' information
-}
view_commanders : Div -> List Commander -> List (Svg Msg)
view_commanders div list =
    let
        new_list =
            List.indexedMap Tuple.pair list
    in
    List.concat (List.map (\x -> view_single_commander div x) new_list)


view_single_commander : Div -> ( Int, Commander ) -> List (Svg Msg)
view_single_commander div ( int, commander ) =
    let
        picture_url =
            "assets/" ++ commander.name ++ ".png"

        nx =
            int * 75 + 250
    in
    [ Svg.image
        [ SvgAttr.xlinkHref picture_url
        , SvgAttr.x (fromInt nx ++ "px")
        , SvgAttr.y (fromFloat 110 ++ "px")
        , SvgAttr.width (fromFloat 75 ++ "px")
        , SvgAttr.height (fromFloat 75 ++ "px")
        , SvgAttr.scale "10"
        , Html.Events.onClick (Msg.AssignCommander ( commander, div.number ))
        ]
        []
    , Svg.text_
        [ SvgAttr.x (fromInt (nx + 35) ++ "px")
        , SvgAttr.y (fromFloat 190.0 ++ "px")
        , SvgAttr.fill "black"
        , SvgAttr.fontSize (fromFloat 8)
        , SvgAttr.fontWeight "700"
        , SvgAttr.dominantBaseline "middle"
        , SvgAttr.textAnchor "middle"
        , Html.Events.onClick Commander1
        ]
        [ VirtualDom.text ("Boost:" ++ Commander.boost_to_string commander.boost) ]
    , Svg.text_
        [ SvgAttr.x (fromInt (nx + 35) ++ "px")
        , SvgAttr.y (fromFloat 200.0 ++ "px")
        , SvgAttr.fill "black"
        , SvgAttr.fontSize (fromFloat 8)
        , SvgAttr.fontWeight "700"
        , SvgAttr.dominantBaseline "middle"
        , SvgAttr.textAnchor "middle"
        , Html.Events.onClick Commander1
        ]
        [ VirtualDom.text ("Ability: " ++ fromInt commander.ability) ]
    ]



-- is_visible : Map -> List Div -> List Div -> List Div
-- is_visible map list_player list_enemy =
--     let
--         list_player_offset = List.map (\x -> x.offset) list_player
--         list_head = List.head list_player_offset |> Maybe.withDefault (-5, -5)
--         nlist_player = List.drop 1 list_player
--     in
--     if List.length list_player == 0 then
--         []
--     else
--         List.filter (\x -> Set.member x.offset (get_offsets_within_n_jumps map list_head 3 )) list_enemy
--         |> is_visible map nlist_player
