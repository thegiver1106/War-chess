module Widget exposing (exitgame_button, help_button, screen_moving_bars, time_speed_widgets, view_right_button)

import General exposing (..)
import Html exposing (Html, div)
import Html.Attributes as HtmlAttr exposing (height)
import Html.Events
import Msg exposing (..)
import String exposing (fromFloat, fromInt)
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr
import Svg.Events
import VirtualDom


info_box : String -> Html Msg
info_box str =
    div
        [ HtmlAttr.style "font-family" "Times New Roman, Arial, sans-serif"
        , HtmlAttr.style "top" "0"
        , HtmlAttr.style "left" "0"
        , HtmlAttr.style "width" "100px"
        , HtmlAttr.style "height" "100px"
        , HtmlAttr.style "font-size" "50px"
        , HtmlAttr.style "font-weight" "bold"
        , HtmlAttr.style "display" "block"
        , HtmlAttr.style "position" "absolute"
        , HtmlAttr.style "color" "white"
        ]
        [ Html.text str ]


left_top_helper : Svg Msg
left_top_helper =
    let
        ( x_min, y_min ) =
            ( 0.0, 0.0 )

        side_length =
            100
    in
    {- Svg.rect
       [ SvgAttr.width (fromFloat side_length)
       , SvgAttr.height (fromFloat side_length)
       , SvgAttr.x (fromFloat x_min)
       , SvgAttr.y (fromFloat y_min)
       , SvgAttr.fill "black"
       , SvgAttr.opacity "0.0"
       ]
       []
    -}
    Svg.rect
        [ SvgAttr.width "1000px"
        , SvgAttr.height "900px"
        , SvgAttr.x "0"
        , SvgAttr.y "0"
        , SvgAttr.fill "black"
        , SvgAttr.opacity "1.0"
        ]
        []



{- }
   right_bottom_helper : Svg Msg
   right_bottom_helper =
       let
           ( x_max, y_max ) =
               screen_right_bottom_svg_coor
           side_length =
               100
       in
           Svg.rect
               [ SvgAttr.width (fromFloat side_length)
               , SvgAttr.height (fromFloat side_length)
               , SvgAttr.x (fromFloat (x_max - side_length))
               , SvgAttr.y (fromFloat (y_max - side_length))
               , SvgAttr.fill "black"
               , SvgAttr.opacity "0.0"
               ]
               []
-}


screen_moving_bar : ( Float, Float ) -> MoveStatus -> Svg Msg
screen_moving_bar screen_size dir =
    let
        bar_thickness =
            20.0

        ( x_min, y_min ) =
            ( 0.0, 0.0 )

        ( x_max, y_max ) =
            screen_size

        ( x_size, y_size ) =
            screen_size

        ( width, height ) =
            case dir of
                Up ->
                    ( x_size, bar_thickness )

                Down ->
                    ( x_size, bar_thickness )

                Left ->
                    ( bar_thickness, y_size )

                Right ->
                    ( bar_thickness, y_size )

        ( x, y ) =
            case dir of
                Up ->
                    ( x_min, y_min )

                Down ->
                    ( x_min, y_max - height )

                Left ->
                    ( x_min, y_min )

                Right ->
                    ( x_max - width, y_min )
    in
    Svg.rect
        [ SvgAttr.width (fromFloat width)
        , SvgAttr.height (fromFloat height)
        , SvgAttr.x (fromFloat x)
        , SvgAttr.y (fromFloat y)
        , SvgAttr.fill "green"
        , Svg.Events.onMouseOver (MoveScreen (On dir))
        , Svg.Events.onMouseOut (MoveScreen Off)
        , SvgAttr.opacity "0.0"
        ]
        []


{-| Enable screen moving
-}
screen_moving_bars : ( Float, Float ) -> List (Svg Msg)
screen_moving_bars screen_size =
    List.map (screen_moving_bar screen_size) [ Up, Down, Left, Right ]


pause_button : TimeState -> ( Float, Float ) -> List (Html Msg)
pause_button game_state screen_size =
    let
        file_name =
            case game_state of
                Paused ->
                    "Continue"

                Normal ->
                    "Pause"

        r =
            50.0

        ( s_w, s_h ) =
            screen_size

        cx =
            s_w - r - r / 4.0

        cy =
            r + r / 4.0
    in
    Svg.circle
        [ SvgAttr.cx (fromFloat cx)
        , SvgAttr.cy (fromFloat cy)
        , SvgAttr.r (fromFloat r)
        , Svg.Events.onClick ChangePlayingState
        , SvgAttr.fill ("url(#" ++ file_name ++ ")")
        ]
        []
        :: List.map get_pattern [ "Continue", "Pause" ]


{-| View buttons on the right at the level choosing page
-}
view_right_button : Msg -> Int -> String -> Html Msg
view_right_button msg n info =
    Html.button
        (List.append
            [ Html.Events.onClick msg
            , HtmlAttr.style "background" "rgb(248,241,228)"
            , HtmlAttr.style "border" "0"
            , HtmlAttr.style "bottom" "50%"
            , HtmlAttr.style "color" "#fff"
            , HtmlAttr.style "cursor" "pointer"
            , HtmlAttr.style "font-family" "Times New Roman, Arial, sans-serif"
            , HtmlAttr.style "display" "block"
            , HtmlAttr.style "font-size" "20px"
            ]
            [ HtmlAttr.style "font-weight" "300"
            , HtmlAttr.style "height" "60px"
            , HtmlAttr.style "right" "2%"
            , HtmlAttr.style "background-color" "#34495f"
            , HtmlAttr.style "top" (fromInt (140 + n * 90) ++ "px")
            , HtmlAttr.style "line-height" "60px"
            , HtmlAttr.style "outline" "none"
            , HtmlAttr.style "position" "absolute"
            , HtmlAttr.style "width" "200px"
            , HtmlAttr.style "border-radius" "10%"
            ]
        )
        [ Html.text info ]


{-| Button for existing the game
-}
exitgame_button : ( Float, Float ) -> List (Svg Msg)
exitgame_button screen_size =
    let
        ( s_w, s_h ) =
            screen_size

        ( width, height ) =
            ( s_w * 0.04, s_w * 0.04 )

        txt_height =
            width * 0.25

        x =
            s_w - width - width / 4.0

        y =
            s_w * 0.05 + 6.0 * (height + txt_height * 1.25)
    in
    [ Svg.image
        [ SvgAttr.x (fromFloat x)
        , SvgAttr.y (fromFloat y)
        , SvgAttr.width (fromFloat width)
        , SvgAttr.height (fromFloat height)
        , SvgAttr.rx "10"
        , SvgAttr.ry "5"
        , Svg.Events.onClick (ChangeGameState GameStateChoosing)
        , SvgAttr.xlinkHref "./assets/Exit.png"
        ]
        []
    ]


{-| View help button for help pages
-}
help_button : Int -> ( Float, Float ) -> List (Svg Msg)
help_button lvl screen_size =
    let
        ( s_w, s_h ) =
            screen_size

        ( width, height ) =
            ( s_w * 0.04, s_w * 0.04 )

        txt_height =
            width * 0.25

        x =
            s_w - width - width / 4.0

        y =
            s_w * 0.05 + 5.0 * (height + txt_height * 1.25)
    in
    [ Svg.image
        [ SvgAttr.x (fromFloat x)
        , SvgAttr.y (fromFloat y)
        , SvgAttr.width (fromFloat width)
        , SvgAttr.height (fromFloat height)

        --, Svg.Events.onClick (ChangeGameState (Help (lvl, Story)))
        , Svg.Events.onClick (ChangeGameState (Help Operation))
        , SvgAttr.xlinkHref "./assets/Help.png"
        ]
        []
    ]


view_time_speed_buttons : List (Svg Msg)
view_time_speed_buttons =
    let
        side_length =
            10.0

        bar_length =
            20.0

        to_percent =
            \x -> fromFloat x ++ "%"
    in
    [ Svg.image
        [ SvgAttr.width (to_percent side_length)
        , SvgAttr.height (to_percent side_length)
        , SvgAttr.x (to_percent (100.0 - 2.0 * side_length - bar_length))
        , SvgAttr.y "0%"
        , Svg.Events.onClick (TimeSpeedChangeMsg Decreasement)
        , SvgAttr.xlinkHref "./assets/Decreasement.png"
        ]
        []
    , Svg.image
        [ SvgAttr.width (to_percent side_length)
        , SvgAttr.height (to_percent side_length)
        , SvgAttr.x (to_percent (100.0 - side_length))
        , SvgAttr.y "0%"
        , Svg.Events.onClick (TimeSpeedChangeMsg Increasement)
        , SvgAttr.xlinkHref "./assets/Increasement.png"
        ]
        []
    ]


view_time_speed_bar : Int -> List (Svg Msg)
view_time_speed_bar speed =
    let
        side_length =
            10.0

        bar_length =
            20.0

        unit_length =
            bar_length / 5.0

        unit_height =
            2.0

        to_percent =
            \x -> fromFloat x ++ "%"

        x0 =
            100.0 - side_length - bar_length

        make_rect =
            \n ->
                Svg.rect
                    [ SvgAttr.x (to_percent (x0 + unit_length * toFloat n))
                    , SvgAttr.y (to_percent (side_length - unit_height))
                    , SvgAttr.width (to_percent unit_length)
                    , SvgAttr.height (to_percent unit_height)
                    , SvgAttr.fill
                        (if speed > n then
                            "green"

                         else
                            "white"
                        )
                    , SvgAttr.stroke "black"
                    , SvgAttr.strokeWidth "3"
                    ]
                    []
    in
    List.map make_rect (List.range 0 4)


time_bar : TimeState -> Float -> List (Svg Msg)
time_bar time_state time =
    let
        side_length =
            10.0

        bar_length =
            20.0

        unit_length =
            bar_length / 5.0

        unit_height =
            2.0

        to_percent =
            \x -> fromFloat x ++ "%"
    in
    [ Svg.rect
        [ SvgAttr.x (to_percent (100.0 - side_length - bar_length))
        , SvgAttr.y "0%"
        , SvgAttr.width (to_percent bar_length)
        , SvgAttr.height (to_percent (side_length - unit_height))
        , SvgAttr.fill
            (case time_state of
                Normal ->
                    "green"

                Paused ->
                    "brown"
            )
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "2"
        , Svg.Events.onClick ChangePlayingState
        ]
        []
    , Svg.text_
        [ SvgAttr.x (to_percent (100.0 - side_length - bar_length + bar_length / 2.0))
        , SvgAttr.y (to_percent ((side_length - unit_height) / 2.1))
        , SvgAttr.width (to_percent bar_length)
        , SvgAttr.height (to_percent (side_length - unit_height))
        , SvgAttr.fill "black"
        , SvgAttr.fontWeight "700"
        , SvgAttr.fontSize "30px"
        , SvgAttr.dominantBaseline "middle"
        , SvgAttr.textAnchor "middle"
        , Svg.Events.onClick ChangePlayingState
        ]
        [ VirtualDom.text (time_to_date time)
        ]
    , Svg.text_
        [ SvgAttr.x (to_percent (100.0 - side_length - bar_length + bar_length / 2.0))
        , SvgAttr.y (to_percent ((side_length - unit_height) / 1.2))
        , SvgAttr.width (to_percent (bar_length / 2.0))
        , SvgAttr.height (to_percent ((side_length - unit_height) / 20.0))
        , SvgAttr.fill "black"
        , SvgAttr.fontWeight "500"
        , SvgAttr.fontSize "20px"
        , SvgAttr.dominantBaseline "middle"
        , SvgAttr.textAnchor "middle"
        , Svg.Events.onClick ChangePlayingState
        ]
        [ case time_state of
            Normal ->
                VirtualDom.text "--Click to Pause--"

            Paused ->
                VirtualDom.text "--Paused--"
        ]
    ]


black_background : Svg Msg
black_background =
    Svg.rect
        [ SvgAttr.fill "black"
        , SvgAttr.x "0%"
        , SvgAttr.y "0%"
        , SvgAttr.width "100%"
        , SvgAttr.height "100%"
        ]
        []


{-| View time's passing speed
-}
time_speed_widgets : TimeState -> Float -> Int -> List (Svg Msg)
time_speed_widgets time_state time speed =
    List.concat
        [ view_time_speed_buttons
        , view_time_speed_bar speed
        , time_bar time_state time
        ]


time_to_date : Float -> String
time_to_date time =
    let
        base_y =
            1800

        base_m =
            6

        base_d =
            14

        base_h =
            6

        base_min =
            0

        t1 =
            time / 100.0

        --0.1s in real time == 1 min in game
        t2 =
            t1 / 60.0

        t3 =
            t2 / 24.0

        t4 =
            t3 / 30.0

        t5 =
            t3 / 12.0

        n_min =
            modBy 60 (floor t1)

        n_h =
            modBy 24 (floor t2)

        n_d =
            modBy 30 (floor t3)

        n_m =
            modBy 12 (floor t4)

        n_y =
            floor t5

        m_min =
            base_min + n_min

        ( f_min, d_h ) =
            if m_min > 60 then
                ( m_min - 60, 1 )

            else
                ( m_min, 0 )

        m_h =
            base_h + n_h + d_h

        ( f_h, d_d ) =
            if m_h > 24 then
                ( m_h - 24, 1 )

            else
                ( m_h, 0 )

        m_d =
            base_d + n_d + d_d

        ( f_d, d_m ) =
            if m_d > 30 then
                ( m_d - 30, 1 )

            else
                ( m_d, 0 )

        m_m =
            base_m + n_m + d_m

        ( f_m, d_y ) =
            if m_m > 12 then
                ( m_m - 12, 1 )

            else
                ( m_m, 0 )

        f_y =
            base_y + n_y + d_y
    in
    fromInt f_y
        ++ "."
        ++ (if f_m < 10 then
                "0"

            else
                ""
           )
        ++ fromInt f_m
        ++ "."
        ++ (if f_d < 10 then
                "0"

            else
                ""
           )
        ++ fromInt f_d
        ++ " / "
        ++ (if f_h < 10 || (f_h > 12 && f_h < 22) then
                "0"

            else
                ""
           )
        ++ fromInt
            (if f_h > 12 then
                f_h - 12

             else
                f_h
            )
        ++ ":"
        ++ (if f_min < 10 then
                "0"

            else
                ""
           )
        ++ fromInt f_min
        ++ (if f_h > 12 then
                " p.m."

            else
                " a.m."
           )


gameBGM : GameState -> Html Msg
gameBGM state =
    case state of
        Logo_Intro ->
            Html.audio [] []

        _ ->
            Html.div
                []
                [ Html.audio
                    [ HtmlAttr.src "./assets/music/PeopleMove.mp3"
                    , HtmlAttr.autoplay True

                    --, HtmlAttr.loop True
                    , HtmlAttr.preload "auto"
                    , HtmlAttr.style "desplay" "block"
                    , HtmlAttr.style "position" "absolute"
                    , HtmlAttr.style "top" "0"
                    , HtmlAttr.controls True
                    ]
                    []
                , Html.audio
                    [ HtmlAttr.src "./assets/music/FastMove.mp3"
                    , HtmlAttr.autoplay True

                    --, HtmlAttr.loop True
                    , HtmlAttr.preload "auto"
                    , HtmlAttr.style "desplay" "block"
                    , HtmlAttr.style "position" "absolute"
                    , HtmlAttr.style "top" "0"
                    , HtmlAttr.controls True
                    ]
                    []
                ]
