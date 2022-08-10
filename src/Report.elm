module Report exposing (Report, report_battles, update_report_showing, view_battle_report)

import Battle exposing (Battle, Side(..), error_battle)
import Div exposing (Div, error_div)
import General exposing (..)
import Html exposing (Html, button, div, text)
import Html.Attributes as HtmlAttr exposing (..)
import Html.Events exposing (keyCode, onClick)
import Json.Decode exposing (maybe)
import Msg exposing (Msg(..))
import String exposing (fromFloat, fromInt)

{-| Definition of Report-}
type alias Report =
    { player_army : List Div
    , enemy_army : List Div
    , time : Int
    , winner : Side
    , pos : Offset
    , show_time : Float --time for player to read the report
    }

{-| Initialization of report-}
init_report : Maybe (List Div) -> Maybe (List Div) -> Side -> Offset -> Int -> Report
init_report player_army enemy_army winner pos time =
    let
        player_div =
            case player_army of
                Nothing ->
                    [ error_div ]

                --impossible
                Just army ->
                    army

        enemy_div =
            case enemy_army of
                Nothing ->
                    [ error_div ]

                --impossible
                Just army ->
                    army
    in
    Report player_div enemy_div time winner pos 0


generate_battle_to_report : List Battle -> List Report
generate_battle_to_report list =
    let
        picked_one =
            List.head list |> Maybe.withDefault error_battle

        remain_list =
            List.drop 1 list
    in
    if List.length list == 1 then
        [ init_report picked_one.player_div picked_one.enemy_div picked_one.winner picked_one.position picked_one.time_seed ]

    else
        init_report picked_one.player_div picked_one.enemy_div picked_one.winner picked_one.position picked_one.time_seed :: generate_battle_to_report remain_list

{-| Generate a battle report for each battle-}
report_battles : List Battle -> Maybe (List Report)
report_battles battles =
    let
        battle_just_happen =
            List.filter (\x -> x.report_battle == True) battles
    in
    if List.length battle_just_happen == 0 then
        Nothing

    else
        let
            report =
                generate_battle_to_report battle_just_happen

            -- generate report for battles just happened
        in
        Just report

{-| Show a report if there are multiple ones-}
update_report_showing : Maybe Report -> Maybe (List Report) -> ( Maybe Report, Maybe (List Report) )
update_report_showing report_showing reports =
    case report_showing of
        Just one_report ->
            ( Just one_report, reports )

        Nothing ->
            case reports of
                Nothing ->
                    ( Nothing, Nothing )

                Just exist_reports ->
                    let
                        report_to_show =
                            List.head exist_reports

                        new_reports =
                            if (List.drop 1 exist_reports |> List.length) == 0 then
                                Nothing

                            else
                                Just (List.drop 1 exist_reports)
                    in
                    ( report_to_show, new_reports )

{-| View a battle report-}
view_battle_report : Maybe Report -> ( Float, Float ) -> Html Msg
view_battle_report report ( width, height ) =
    case report of
        Nothing ->
            div [] []

        Just a_report ->
            div []
                [ view_report_background ( width, height )
                , view_each_report a_report ( width, height )
                ]


view_report_background : ( Float, Float ) -> Html Msg
view_report_background ( width, height ) =
    div
        [ HtmlAttr.style "width" "310px"
        , HtmlAttr.style "height" "180px"
        , HtmlAttr.style "position" "fixed"
        , HtmlAttr.style "left" "0"
        , HtmlAttr.style "top" (fromFloat (height - 200) ++ "px")
        ]
        [ Html.img
            [ HtmlAttr.src "assets/report_background.png"
            , HtmlAttr.style "width" "100%"
            , HtmlAttr.style "height" "100%"
            ]
            []
        ]


view_each_report : Report -> ( Float, Float ) -> Html Msg
view_each_report report ( width, height ) =
    let
        pos =
            "Battle Position: (" ++ fromInt (Tuple.first report.pos) ++ "," ++ fromInt (Tuple.second report.pos) ++ ")"

        result =
            case report.winner of
                Player ->
                    "We win this battle!"

                Enemy ->
                    "We lose in the battle!"

                _ ->
                    ""

        time =
            "Battle Time: " ++ fromInt (report.time // 1000) ++ " S"
    in
    div
        [ HtmlAttr.style "width" "300px"
        , HtmlAttr.style "height" "160px"
        , HtmlAttr.style "position" "fixed"
        , HtmlAttr.style "left" "0"
        , HtmlAttr.style "top" (fromFloat (height - 200) ++ "px")
        ]
        [ div
            [ HtmlAttr.style "font-family" "Lucida Calligraphy"
            , HtmlAttr.style "display" "block"
            , HtmlAttr.style "font-size" "27px"
            , HtmlAttr.style "font-weight" "300"
            , HtmlAttr.style "color" "rgb(44,54,57)"
            ]
            [ text "Latest battle report:" ]
        , div
            [ HtmlAttr.style "font-family" "Lucida Calligraphy"
            , HtmlAttr.style "display" "block"
            , HtmlAttr.style "font-size" "22px"
            , HtmlAttr.style "color" "rgb(44,54,57)"
            ]
            [ text result ]
        , div
            [ HtmlAttr.style "font-family" "Lucida Calligraphy"
            , HtmlAttr.style "display" "block"
            , HtmlAttr.style "font-size" "22px"
            , HtmlAttr.style "color" "rgb(44,54,57)"
            ]
            [ text pos ]
        , div
            [ HtmlAttr.style "font-family" "Lucida Calligraphy"
            , HtmlAttr.style "display" "block"
            , HtmlAttr.style "font-size" "22px"
            , HtmlAttr.style "color" "rgb(44,54,57)"
            ]
            [ text time ]
        , div [] (List.map (\x -> view_player_div x) report.player_army)
        , div [] (List.map (\x -> view_enemy_div x) report.enemy_army)
        ]


view_player_div : Div -> Html Msg
view_player_div division =
    let
        number =
            fromInt division.number

        hp =
            fromInt division.hp

        txt =
            if division.hp <= 0 then
                "Your division " ++ number ++ " is destroyed"

            else
                "Your division " ++ number ++ " remain " ++ hp
    in
    div
        [ HtmlAttr.style "font-family" "Lucida Calligraphy"
        , HtmlAttr.style "display" "block"
        , HtmlAttr.style "font-size" "18px"
        , HtmlAttr.style "color" "rgb(44,54,57)"
        ]
        [ text txt ]


view_enemy_div : Div -> Html Msg
view_enemy_div division =
    let
        hp =
            fromInt division.hp

        txt =
            if division.hp <= 0 then
                "Enemy is destroyed!"

            else
                "The enemy remains " ++ hp
    in
    div
        [ HtmlAttr.style "font-family" "Lucida Calligraphy"
        , HtmlAttr.style "display" "block"
        , HtmlAttr.style "font-size" "18px"
        , HtmlAttr.style "color" "rgb(44,54,57)"
        ]
        [ text txt ]
