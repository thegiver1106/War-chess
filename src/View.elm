module View exposing (view)
--view, 
import Array
import Base
import Battle exposing (Battle, Battle_state(..), Fight(..), error_battle, init_battle, update_battle, update_enemy_div, update_player_div)
import Bitwise
import Block exposing (..)
import Browser
import Browser.Events exposing (onAnimationFrameDelta, onKeyDown)
import Commander
import Construction
import Div exposing (..)
import Events
import General exposing (..)
import Help exposing (view_help)
import Html exposing (Html, a, button, div, text)
import Html.Attributes as HtmlAttr exposing (..)
import Html.Events exposing (keyCode, onClick)
import Html.Events.Extra.Wheel as Wheel
import Map
import Model exposing (Model)
import Msg exposing (..)
import Prompt exposing (..)
import Report exposing (view_battle_report)
import Sound
import String exposing (fromFloat, fromInt)
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr
import Svg.Events
import Turn_page exposing (view_beginning_page, view_ending, view_lose_page, view_win_page)
import VirtualDom
import Widget exposing (..)



-- many Debug information has been added, you can simply ignore them

{-| View function for the whole program-}
view : Model -> Html Msg
view model =
    case model.game_state of
        GameStateChoosing ->
            view_game_state_choosing model

        LevelChoosing ->
            view_level_choosing model

        CreatorChoosing ->
            view_creator_choosing model

        Level _ ->
            view_level model

        Logo_Intro ->
            view_logo model

        Help help ->
            view_help help model.sub_model.passed_level model.map.map_size_arg.screen_size

        Win_turn_page n p ->
            view_win_page n p model.map.map_size_arg.screen_size model.sub_model.time

        Lose_turn_page n p ->
            view_lose_page n p model.map.map_size_arg.screen_size model.sub_model.time

        Beginning_page ->
            view_beginning_page model.sub_model.time model.map.map_size_arg.screen_size

        Ending ->
            view_ending model.sub_model.time model.map.map_size_arg.screen_size

        _ ->
            view_level_choosing model


view_transition : ( Int, Int ) -> Html Msg
view_transition model =
    div
        [ HtmlAttr.style "width" "100%"
        , HtmlAttr.style "height" "100%"
        , HtmlAttr.style "position" "fixed"
        , HtmlAttr.style "left" "0"
        , HtmlAttr.style "top" "0"
        , HtmlAttr.style "background-color" "black"
        ]
        [ div [ class "jumbotron" ]
            [ Html.h1 [] [ text "Transition" ] ]
        ]


view_logo : Model -> Html Msg
view_logo model =
    let
        radius =
            fromFloat <|
                if model.sub_model.time <= (time_logo_sequence - 1300) then
                    500 + 300 * logBase e model.sub_model.time

                else
                    2500
    in
    div
        [ HtmlAttr.style "width" "100%"
        , HtmlAttr.style "height" "100%"
        , HtmlAttr.style "position" "fixed"
        , HtmlAttr.style "left" "0"
        , HtmlAttr.style "top" "0"
        , HtmlAttr.style "background-color" "black"
        ]
        [ Svg.svg
            [ SvgAttr.width "100%"
            , SvgAttr.height "100%"
            , SvgAttr.viewBox "0 0 10000 10000"
            , Svg.Events.onClick (ChangeGameState Beginning_page)
            ]
            [ Svg.circle
                [ SvgAttr.cy "5000"
                , SvgAttr.cx "5000"
                , SvgAttr.r radius
                , SvgAttr.fill "white"
                ]
                []
            , Svg.image
                [ SvgAttr.xlinkHref "doc/logo.png"
                , SvgAttr.x "1300"
                , SvgAttr.y "1500"
                , SvgAttr.width "7000"
                , SvgAttr.height "7000"
                , SvgAttr.scale "%100"
                ]
                []
            ]
        ]


view_level :
    Model
    -> Html Msg -- view function for level
view_level model =
    let
        selected_list =
            List.filter (\x -> x.number == model.player.division_picked) model.player.army

        seleceted_div =
            case List.head selected_list of
                Nothing ->
                    Div.error_div

                Just div ->
                    div

        screen_size =
            model.map.map_size_arg.screen_size

        width_str =
            fromFloat (Tuple.first screen_size)

        height_str =
            fromFloat (Tuple.second screen_size)

        lvl =
            case model.game_state of
                Level a ->
                    a

                _ ->
                    0

        commander_list =
            case model.game_state of
                Level 1 ->
                    Commander.french_commander 1

                Level 2 ->
                    Commander.french_commander 2

                Level 3 ->
                    Commander.french_commander 3

                _ ->
                    []

        view_unassigned_commanders =
            if Div.check_commander_status model.player.army then
                Prompt.view_commanders seleceted_div (check_commander_assigned model.player.army commander_list)

            else
                []
    in
    div
        [ HtmlAttr.style "width" "100%"
        , HtmlAttr.style "height" "100%"
        , HtmlAttr.style "position" "fixed"
        , HtmlAttr.style "left" "0"
        , HtmlAttr.style "top" "0"
        , HtmlAttr.style "font-family" "Times New Roman"
        , Wheel.onWheel chooseZoom
        ]
        [ view_battle_report model.sub_model.report_showing screen_size
        , Sound.view model.sounds
        , Sound.view_bgm
        , Prompt.view_div_with_same_pos seleceted_div.offset model.player.army
        , Svg.svg
            [ SvgAttr.width (width_str ++ "px")
            , SvgAttr.height (height_str ++ "px")
            ]
            (List.append
                (List.concat
                    [ Map.view model.map
                    , screen_moving_bars screen_size

                    --, Prompt.view_div_with_same_pos seleceted_div.offset model.player.army
                    , Prompt.view_info seleceted_div
                    , view_unassigned_commanders
                    , Base.view model.player.base screen_size
                    , Events.events_button screen_size

                    --, screen_moving_bars
                    --, Prompt.view_divisions model.map.map_size_arg model.player.army
                    --, Prompt.view_enemy_divisions model.map model.map.map_size_arg model.enemy.army
                    , exitgame_button screen_size
                    , help_button lvl screen_size
                    ]
                )
                (List.concat
                    --, Prompt.view_info seleceted_div
                    [ Construction.view seleceted_div screen_size

                    --, Prompt.view_divisions model.map.map_size_arg model.player.army
                    --, Prompt.view_enemy_divisions model.map model.map.map_size_arg model.enemy.army
                    , Prompt.view_divisions model.map.map_size_arg model.player.army model.enemy.army model.sub_model.time
                    , Prompt.view_enemy_divisions model.map model.map.map_size_arg model.player.army model.enemy.army model.player.base.offset model.sub_model.time
                    , view_unassigned_commanders
                    , Prompt.view_info seleceted_div
                    , time_speed_widgets model.time_state model.sub_model.time (floor model.time_speed)
                    , Events.events_page model.events
                    ]
                )
            )

        --, Prompt.view_div_with_same_pos seleceted_div.offset model.player.army
        , Events.events_table model.events.acti_state
        ]


view_game_state_choosing : Model -> Html Msg
view_game_state_choosing model =
    div
        [ HtmlAttr.style "width" "100%"
        , HtmlAttr.style "height" "100%"
        , HtmlAttr.style "position" "fixed"
        , HtmlAttr.style "left" "0"
        , HtmlAttr.style "top" "0"
        ]
        [ beginning_illustration
        , view_right_button (ChangeGameState LevelChoosing) 1 "Campaign Mode"
        , view_right_button (ChangeGameState (Level 4)) 2 "Conqueror Mode"
        , view_right_button (ChangeGameState CreatorChoosing) 3 "Creator Mode"
        , view_right_button (ChangeGameState (Help Story)) 4 "Help"
        , view_right_button (ChangeGameState Setting) 5 "Setting"
        , view_battle_position model
        , view_battle_position_cross model
        ]


view_creator_choosing : Model -> Html Msg
view_creator_choosing model =
    div
        [ HtmlAttr.style "width" "100%"
        , HtmlAttr.style "height" "100%"
        , HtmlAttr.style "position" "fixed"
        , HtmlAttr.style "left" "0"
        , HtmlAttr.style "top" "0"
        ]
        [ beginning_illustration
        , view_right_button (ChangeGameState (Level 5)) 1 "Create"
        , view_right_button (ChangeGameState (Level 6)) 2 "Play"
        , view_right_button (ChangeGameState GameStateChoosing) 3 "Back"
        , view_battle_position model
        , view_battle_position_cross model
        ]


view_level_choosing : Model -> Html Msg
view_level_choosing model =
    div
        [ HtmlAttr.style "width" "100%"
        , HtmlAttr.style "height" "100%"
        , HtmlAttr.style "position" "fixed"
        , HtmlAttr.style "left" "0"
        , HtmlAttr.style "top" "0"
        ]
        [ beginning_illustration
        , view_right_button (ChangeGameState (Level 1)) 1 "Marengo"
        , view_right_button (ChangeGameState (Level 2)) 2 "Austerlitz"
        , view_right_button (ChangeGameState (Level 3)) 3 "Waterloo"
        , view_right_button (ChangeGameState GameStateChoosing) 4 "Back"
        , view_battle_position model
        , view_battle_position_cross model
        ]



-- view_battle_dialogue: Int -> (Float, Float) -> Html Msg
-- view_battle_dialogue passed_level  =
--     let
--         width =
--     in
--     case passed_level of
--         0 ->
--             div
--                 [ HtmlAttr.style "height" "100%"
--                 , HtmlAttr.style "width" "100%"
--                 , HtmlAttr.style "left" (fromFloat (width / 5.5) ++ "px")
--                 , HtmlAttr.style "top" (fromFloat (height / 4) ++ "px")
--                 , HtmlAttr.style "position" "fixed"
--                 , HtmlAttr.style "font-family" "Helvetica, Arial, sans-serif"
--                 , HtmlAttr.style "font-size" "20px"
--                 , HtmlAttr.style "color" "white"
--                 ]
--                 [ paragraph "Napoelon: "
--                 , paragraph "With a series of failure in the northern Italy in the previous year, we almost lost all the Italy."
--                 , paragraph "ALthough Massena launched a counterattack recently and made some progress months ago, the situation there is still terrible."
--                 , paragraph "But, due to the wide disparity in men-power, Massena and his troops are now trapped and surrounded in Geona"
--                 , paragraph "We have to do something to save them. "
--                 , paragraph "Although we have less soldiers compared with the Austrian army right now, our soldiers are experienced."
--                 , paragraph "By the way, our reinforcements are trying their best to help you."
--                 , paragraph "Hold on commander!"
--                 , paragraph "Although it seems we cannot save this battle, there is still enough time for us to win another back."
--                 ]
-- view_beginning : Model -> Html Msg
-- view_beginning model =
--     div
--         [ HtmlAttr.style "width" "100%"
--         , HtmlAttr.style "height" "100%"
--         , HtmlAttr.style "position" "fixed"
--         , HtmlAttr.style "left" "0"
--         , HtmlAttr.style "top" "0"
--         ]
--         [ view_right_button (ChangeGameState LevelChoosing) 1 "Play"
--         , view_right_button (ChangeGameState (Help Story)) 2 "Help"
--         , view_right_button (ChangeGameState Setting) 3 "Setting"
--         , beginning_illustration
--         ]


beginning_illustration : Html Msg
beginning_illustration =
    Html.img
        [ HtmlAttr.src "./assets/Europe_map.png"
        , HtmlAttr.style "width" "75%"
        , HtmlAttr.style "height" "90%"
        , HtmlAttr.style "left" "10%"
        , HtmlAttr.style "top" "5%"
        , HtmlAttr.style "position" "absolute"
        , HtmlAttr.style "display" "block"
        ]
        []


view_battle_position_cross : Model -> Html Msg
view_battle_position_cross model =
    let
        ( width, height ) =
            model.map.map_size_arg.screen_size

        ( nwidth, nheight ) =
            case model.sub_model.passed_level of
                0 ->
                    ( width / 2.45, height / 1.7 )

                -- 2.45; 1.7
                1 ->
                    ( width / 1.96, height / 2.51 )

                --1.96; 2.51
                _ ->
                    ( width / 2.97, height / 3.65 )

        -- 2.97; 3.65
    in
    Html.img
        [ Html.Events.onClick (ChangeGameState (Level (model.sub_model.passed_level + 1)))
        , HtmlAttr.style "left" (fromFloat nwidth ++ "px")
        , HtmlAttr.style "top" (fromFloat nheight ++ "px")
        , HtmlAttr.style "width" (fromFloat 40.0 ++ "px")
        , HtmlAttr.style "height" (fromFloat 37.0 ++ "px")
        , HtmlAttr.style "position" "fixed"
        , HtmlAttr.src "assets/Turn_page/Turn_page_battle.png"
        ]
        []


view_battle_position : Model -> Html Msg
view_battle_position model =
    let
        ( width, height ) =
            model.map.map_size_arg.screen_size
    in
    case model.sub_model.passed_level of
        0 ->
            Html.button
                --2.6; 1.75
                (List.append
                    [ Html.Events.onClick (ChangeGameState (Level 1))
                    , HtmlAttr.style "border" "4"
                    , HtmlAttr.style "border-color" "yellow"
                    , HtmlAttr.style "bottom" "50%"
                    , HtmlAttr.style "background" "transparent"
                    , HtmlAttr.style "color" "rgb(0,0,0)"
                    , HtmlAttr.style "cursor" "pointer"
                    , HtmlAttr.style "font-family" "Helvetica, Arial, sans-serif"
                    , HtmlAttr.style "display" "block"
                    , HtmlAttr.style "font-size" "18px"
                    ]
                    [ HtmlAttr.style "font-weight" "100"
                    , HtmlAttr.style "height" "60px"
                    , HtmlAttr.style "left" (fromFloat (width / 2.6) ++ "px")
                    , HtmlAttr.style "top" (fromFloat (height / 1.75) ++ "px")
                    , HtmlAttr.style "outline" "none"
                    , HtmlAttr.style "position" "absolute"
                    , HtmlAttr.style "width" "120px"
                    ]
                )
                []

        1 ->
            Html.button
                -- 2.05; 2.57
                (List.append
                    [ Html.Events.onClick (ChangeGameState (Level 2))
                    , HtmlAttr.style "border" "4"
                    , HtmlAttr.style "bottom" "50%"
                    , HtmlAttr.style "border-color" "yellow"
                    , HtmlAttr.style "cursor" "pointer"
                    , HtmlAttr.style "font-family" "Helvetica, Arial, sans-serif"
                    , HtmlAttr.style "display" "block"
                    , HtmlAttr.style "background" "transparent"
                    , HtmlAttr.style "font-size" "18px"
                    ]
                    [ HtmlAttr.style "font-weight" "300"
                    , HtmlAttr.style "height" "60px"
                    , HtmlAttr.style "left" (fromFloat (width / 2.05) ++ "px")
                    , HtmlAttr.style "top" (fromFloat (height / 2.57) ++ "px")
                    , HtmlAttr.style "outline" "none"
                    , HtmlAttr.style "position" "absolute"
                    , HtmlAttr.style "width" "120px"
                    , HtmlAttr.style "border-radius" "10%"
                    ]
                )
                []

        2 ->
            Html.button
                -- 3.2; 3.75
                (List.append
                    [ Html.Events.onClick (ChangeGameState (Level 3))
                    , HtmlAttr.style "border" "4"
                    , HtmlAttr.style "bottom" "50%"
                    , HtmlAttr.style "color" "rgb(255, 255, 0)"
                    , HtmlAttr.style "border-color" "yellow"
                    , HtmlAttr.style "cursor" "pointer"
                    , HtmlAttr.style "font-family" "Helvetica, Arial, sans-serif"
                    , HtmlAttr.style "display" "block"
                    , HtmlAttr.style "background" "transparent"
                    , HtmlAttr.style "font-size" "18px"
                    ]
                    [ HtmlAttr.style "font-weight" "300"
                    , HtmlAttr.style "height" "60px"
                    , HtmlAttr.style "left" (fromFloat (width / 3.2) ++ "px")
                    , HtmlAttr.style "top" (fromFloat (height / 3.75) ++ "px")
                    , HtmlAttr.style "outline" "none"
                    , HtmlAttr.style "position" "absolute"
                    , HtmlAttr.style "width" "120px"
                    , HtmlAttr.style "border-radius" "10%"
                    ]
                )
                []

        _ ->
            div [] []



-- view_battle_position_back : Model -> Html Msg
-- view_battle_position_back model =
--     Svg.svg
--         [ SvgAttr.width "10%"
--         , SvgAttr.height "10%"
--         ]
--         [view_battle_hightlight model]
-- view_battle_hightlight : Model -> Svg Msg
-- view_battle_hightlight model =
--     let
--         (width, height) = model.map.map_size_arg.screen_size
--     in
--     case model.passed_level of
--         0 ->
--             Svg.rect
--                 [ SvgAttr.x (fromFloat (width / 2.6))
--                 , SvgAttr.y (fromFloat (height / 1.75))
--                 , SvgAttr.width ("100px")
--                 , SvgAttr.height ("50px")
--                 , SvgAttr.stroke "yellow"
--                 , SvgAttr.strokeWidth "5"
--                 ]
--                 []
--         1 ->
--             Svg.rect
--                 [ SvgAttr.x (fromFloat (width / 2))
--                 , SvgAttr.y (fromFloat (height / 2))
--                 , SvgAttr.width ("100px")
--                 , SvgAttr.height ("50px")
--                 , SvgAttr.stroke "yellow"
--                 , SvgAttr.strokeWidth "5"
--                 ]
--                 []
--         2 ->
--             Svg.rect
--                 [ SvgAttr.x (fromFloat (width / 2.5))
--                 , SvgAttr.y (fromFloat (height / 5))
--                 , SvgAttr.width ("100px")
--                 , SvgAttr.height ("50px")
--                 , SvgAttr.stroke "yellow"
--                 , SvgAttr.strokeWidth "5"
--                 ]
--                 []
--         _ ->
--             Svg.rect
--                 []
--                 []


chooseZoom : Wheel.Event -> Msg
chooseZoom wheelEvent =
    if wheelEvent.deltaY > 0 then
        Zoom Out

    else
        Zoom In
