module Sub_turn_page exposing (..)

import General exposing (..)
import Html exposing (Html, a, button, div, text)
import Html.Attributes as HtmlAttr exposing (..)
import Html.Events exposing (keyCode, onClick)
import MapGenerator exposing (Msg)
import String exposing (fromFloat)

{-| View the first scene of the beginning part-}
view_beginning_scene_1 : Float -> ( Float, Float ) -> Html msg
view_beginning_scene_1 time ( width, height ) =
    let
        opacity =
            if time <= 2000 then
                fromFloat (time / 2000)

            else
                "1"
    in
    div
        [ HtmlAttr.style "width" "100%"
        , HtmlAttr.style "height" "100%"
        , HtmlAttr.style "position" "fixed"
        , HtmlAttr.style "left" "0"
        , HtmlAttr.style "top" "0"
        , HtmlAttr.style "background-color" "rgb(44, 51, 51)"
        ]
        [ Html.img
            [ HtmlAttr.style "left" (fromFloat (width / 15) ++ "px")
            , HtmlAttr.style "top" (fromFloat (height / 7) ++ "px")
            , HtmlAttr.style "width" (fromFloat (width / 3) ++ "px")
            , HtmlAttr.style "height" (fromFloat (height / 1.5) ++ "px")
            , HtmlAttr.style "position" "fixed"
            , HtmlAttr.src "assets/Turn_page/beginning_1.png"
            , HtmlAttr.style "opacity" opacity
            ]
            []
        , view_text_1 time ( width, height )
        ]

{-| View the second scene of the beginning part-}
view_beginning_scene_2 : Float -> ( Float, Float ) -> Html msg
view_beginning_scene_2 time ( width, height ) =
    let
        opacity =
            if (time - 10000) <= 2000 then
                fromFloat ((time - 10000) / 2000)

            else
                "1"
    in
    div
        [ HtmlAttr.style "width" "100%"
        , HtmlAttr.style "height" "100%"
        , HtmlAttr.style "position" "fixed"
        , HtmlAttr.style "left" "0"
        , HtmlAttr.style "top" "0"
        , HtmlAttr.style "background-color" "rgb(44, 51, 51)"
        ]
        [ Html.img
            [ HtmlAttr.style "left" (fromFloat (width / 15) ++ "px")
            , HtmlAttr.style "top" (fromFloat (height / 7) ++ "px")
            , HtmlAttr.style "width" (fromFloat (width / 3) ++ "px")
            , HtmlAttr.style "height" (fromFloat (height / 1.5) ++ "px")
            , HtmlAttr.style "position" "fixed"
            , HtmlAttr.src "assets/Turn_page/beginning_2.png"
            , HtmlAttr.style "opacity" opacity
            ]
            []
        , view_text_2 time ( width, height )
        , view_skip ( width, height )
        ]

{-| View the thrid scene of the beginning part-}
view_beginning_scene_3 : Float -> ( Float, Float ) -> Html msg
view_beginning_scene_3 time ( width, height ) =
    let
        opacity =
            if (time - 20000) <= 2000 then
                fromFloat ((time - 20000) / 2000)

            else
                "1"
    in
    div
        [ HtmlAttr.style "width" "100%"
        , HtmlAttr.style "height" "100%"
        , HtmlAttr.style "position" "fixed"
        , HtmlAttr.style "left" "0"
        , HtmlAttr.style "top" "0"
        , HtmlAttr.style "background-color" "rgb(44, 51, 51)"
        ]
        [ Html.img
            [ HtmlAttr.style "left" (fromFloat (width / 15) ++ "px")
            , HtmlAttr.style "top" (fromFloat (height / 7) ++ "px")
            , HtmlAttr.style "width" (fromFloat (width / 3) ++ "px")
            , HtmlAttr.style "height" (fromFloat (height / 1.5) ++ "px")
            , HtmlAttr.style "position" "fixed"
            , HtmlAttr.src "assets/Turn_page/beginning_3.png"
            , HtmlAttr.style "opacity" opacity
            ]
            []
        , view_text_3 time ( width, height )
        , view_skip ( width, height )
        ]

{-| View the last scene of the beginning part-}
view_beginning_scene_4 : Float -> ( Float, Float ) -> Html msg
view_beginning_scene_4 time ( width, height ) =
    let
        opacity =
            if (time - 30000) <= 2000 then
                fromFloat ((time - 30000) / 2000)

            else
                "1"
    in
    div
        [ HtmlAttr.style "width" "100%"
        , HtmlAttr.style "height" "100%"
        , HtmlAttr.style "position" "fixed"
        , HtmlAttr.style "left" "0"
        , HtmlAttr.style "top" "0"
        , HtmlAttr.style "background-color" "rgb(44, 51, 51)"
        ]
        [ Html.img
            [ HtmlAttr.style "left" (fromFloat (width / 15) ++ "px")
            , HtmlAttr.style "top" (fromFloat (height / 7) ++ "px")
            , HtmlAttr.style "width" (fromFloat (width / 3) ++ "px")
            , HtmlAttr.style "height" (fromFloat (height / 1.5) ++ "px")
            , HtmlAttr.style "position" "fixed"
            , HtmlAttr.src "assets/beginning.png"
            , HtmlAttr.style "opacity" opacity
            ]
            []
        , view_text_4 time ( width, height )
        , view_skip ( width, height )
        ]

{-| View the story of the first scene of the beginning part-}
view_text_1 : Float -> ( Float, Float ) -> Html msg
view_text_1 time ( width, height ) =
    let
        opacity =
            if time <= 1000 then
                fromFloat (time / 1000)

            else if time >= 90000 then
                fromFloat (1 - (time - 9000) / 1000)

            else
                "1"
    in
    div
        [ HtmlAttr.style "height" "100%"
        , HtmlAttr.style "width" "100%"
        , HtmlAttr.style "left" (fromFloat (width / 2.3) ++ "px")
        , HtmlAttr.style "top" (fromFloat (height / 6) ++ "px")
        , HtmlAttr.style "position" "fixed"
        , HtmlAttr.style "font-family" "Helvetica, Arial, sans-serif"
        , HtmlAttr.style "font-size" "30px"
        , HtmlAttr.style "color" "white"
        , HtmlAttr.style "opacity" opacity
        ]
        [ paragraph "1789.7.14, a day that was doomed to be historic and immortal"
        , paragraph "The day begun with noises of fierce gunfire in Paris"
        , paragraph "After the execution of Louis XVI on the Place de la Concorde "
        , paragraph "All the kings throughout Europe quickly assembled their armies"
        , paragraph "The first Coalition ally formed"
        , paragraph "Countless wars filled the decades with the bloody smell of powder"
        , paragraph "Mixed with the roar of guns"
        ]

{-| View the story of the second scene of the beginning part-}
view_text_2 : Float -> ( Float, Float ) -> Html msg
view_text_2 time ( width, height ) =
    let
        opacity =
            if (time - 10000) <= 1000 then
                fromFloat ((time - 10000) / 1000)

            else if (time - 10000) >= 9000 then
                fromFloat (1 - ((time - 10000) - 9000) / 1000)

            else
                "1"
    in
    div
        [ HtmlAttr.style "height" "100%"
        , HtmlAttr.style "width" "100%"
        , HtmlAttr.style "left" (fromFloat (width / 2.3) ++ "px")
        , HtmlAttr.style "top" (fromFloat (height / 6) ++ "px")
        , HtmlAttr.style "position" "fixed"
        , HtmlAttr.style "font-family" "Helvetica, Arial, sans-serif"
        , HtmlAttr.style "font-size" "30px"
        , HtmlAttr.style "color" "white"
        , HtmlAttr.style "opacity" opacity
        ]
        [ paragraph "1793, Toulon"
        , paragraph "The French army was to liberate the city of Toulon from the British army"
        , paragraph "Right at this time when a brilliant commander was in desperate need"
        , paragraph "Napoleon, a 24-year-old artillery major stood out"
        , paragraph "Faced with the 5 remaining cannons which were in terrible"
        , paragraph "He quickly took actions and won the battle"
        , paragraph "All the invaders were banished from France"
        , paragraph "Napoleon? His legend had just begun"
        ]

{-| View the story of the thrid scene of the beginning part-}
view_text_3 : Float -> ( Float, Float ) -> Html msg
view_text_3 time ( width, height ) =
    let
        opacity =
            if (time - 20000) <= 1000 then
                fromFloat ((time - 20000) / 1000)

            else if (time - 20000) >= 9000 then
                fromFloat (1 - ((time - 20000) - 9000) / 1000)

            else
                "1"
    in
    div
        [ HtmlAttr.style "height" "100%"
        , HtmlAttr.style "width" "100%"
        , HtmlAttr.style "left" (fromFloat (width / 2.3) ++ "px")
        , HtmlAttr.style "top" (fromFloat (height / 6) ++ "px")
        , HtmlAttr.style "position" "fixed"
        , HtmlAttr.style "font-family" "Helvetica, Arial, sans-serif"
        , HtmlAttr.style "font-size" "30px"
        , HtmlAttr.style "color" "white"
        , HtmlAttr.style "opacity" opacity
        ]
        [ paragraph "1798, Egypt"
        , paragraph "After a series of victory, the first Coalition ally was broken."
        , paragraph "Napoleon was sent to launch an expedition to Egypt"
        , paragraph "However, the second Coalition ally was formed during this time"
        , paragraph "and soon launched a well-prepared attacking"
        , paragraph "The mainland of France was threatened after multiple defeats"
        , paragraph "There was no choice but called back Napoleon"
        , paragraph "to save the severe situation......"
        ]

{-| View the story of the last scene of the beginning part-}
view_text_4 : Float -> ( Float, Float ) -> Html msg
view_text_4 time ( width, height ) =
    let
        opacity =
            if (time - 30000) <= 1000 then
                fromFloat ((time - 30000) / 1000)

            else if (time - 30000) >= 9000 then
                fromFloat (1 - ((time - 30000) - 9000) / 1000)

            else
                "1"
    in
    div
        [ HtmlAttr.style "height" "100%"
        , HtmlAttr.style "width" "100%"
        , HtmlAttr.style "left" (fromFloat (width / 2.3) ++ "px")
        , HtmlAttr.style "top" (fromFloat (height / 6) ++ "px")
        , HtmlAttr.style "position" "fixed"
        , HtmlAttr.style "font-family" "Helvetica, Arial, sans-serif"
        , HtmlAttr.style "font-size" "30px"
        , HtmlAttr.style "color" "white"
        , HtmlAttr.style "opacity" opacity
        ]
        [ paragraph "Now, honorable commander"
        , paragraph "there is no way to retreat"
        , paragraph "Behind us is our nation"
        , paragraph "defend our country and fight for the freedom!"
        ]

{-| View reminder for the player to skip the animation if he wishes-}
view_skip : ( Float, Float ) -> Html msg
view_skip ( width, height ) =
    div
        [ HtmlAttr.style "left" (fromFloat (width / 1.2) ++ "px")
        , HtmlAttr.style "top" (fromFloat (height / 1.2) ++ "px")
        , HtmlAttr.style "position" "fixed"
        , HtmlAttr.style "font-family" "Helvetica, Arial, sans-serif"
        , HtmlAttr.style "font-size" "22px"
        , HtmlAttr.style "color" "rgb(255,229,180)"
        ]
        [ text "Press Enter to Skip" ]

{-| view the winning image for each level-}
view_win_images : Int -> Int -> ( Float, Float ) -> Float -> Html msg
view_win_images n p ( width, height ) time =
    let
        url =
            case n of
                1 ->
                    "assets/Turn_page/Turn_1_win.png"

                2 ->
                    "assets/Turn_page/Turn_2_win.png"

                _ ->
                    "assets/Turn_page/Turn_3_win.png"

        url_character =
            case ( n, p ) of
                ( 1, 3 ) ->
                    "assets/Franz_II.png"

                ( 2, 2 ) ->
                    "assets/Franz_II.png"

                ( 2, 3 ) ->
                    "assets/Franz_II.png"

                ( 3, 1 ) ->
                    "assets/Ney.png"

                _ ->
                    "assets/Napoleon.png"

        left_pos =
            case ( n, p ) of
                ( 1, 3 ) ->
                    fromFloat (width / 1.6) ++ "px"

                ( 2, 2 ) ->
                    fromFloat (width / 1.6) ++ "px"

                ( 2, 3 ) ->
                    fromFloat (width / 1.6) ++ "px"

                _ ->
                    fromFloat (width / 2.9) ++ "px"
    in
    div
        [ HtmlAttr.style "width" "100%"
        , HtmlAttr.style "height" "100%"
        , HtmlAttr.style "position" "fixed"
        , HtmlAttr.style "left" "0"
        , HtmlAttr.style "top" "0"
        ]
        [ Html.img
            [ HtmlAttr.style "left" (fromFloat (width / 4) ++ "px")
            , HtmlAttr.style "top" (fromFloat (height / 8) ++ "px")
            , HtmlAttr.style "width" (fromFloat (width / 2.2) ++ "px")
            , HtmlAttr.style "height" (fromFloat (height / 2.2) ++ "px")
            , HtmlAttr.style "position" "fixed"
            , HtmlAttr.src url
            , HtmlAttr.style "opacity" "1"
            ]
            []
        , Html.img
            [ HtmlAttr.style "left" left_pos
            , HtmlAttr.style "top" (fromFloat (height / 1.35) ++ "px")
            , HtmlAttr.style "width" (fromFloat (width / 20) ++ "px")
            , HtmlAttr.style "height" (fromFloat (height / 8) ++ "px")
            , HtmlAttr.style "position" "fixed"
            , HtmlAttr.src url_character
            , HtmlAttr.style "opacity" "1"
            ]
            []
        ]

{-| View the losing image for each level-}
view_lose_images : Int -> Int -> ( Float, Float ) -> Float -> Html msg
view_lose_images n p ( width, height ) time =
    let
        url =
            case n of
                1 ->
                    "assets/Turn_page/Turn_1_lose.png"

                2 ->
                    "assets/Turn_page/Turn_2_lose.png"

                _ ->
                    "assets/Turn_page/Turn_3_lose.png"

        url_character =
            case ( n, p ) of
                ( 1, 2 ) ->
                    "assets/Massena.png"

                ( 1, 3 ) ->
                    "assets/Massena.png"

                ( 2, 1 ) ->
                    "assets/Alexander_I.png"

                ( 2, 2 ) ->
                    "assets/Alexander_I.png"

                ( 2, 3 ) ->
                    "assets/Franz_II.png"

                ( 3, 1 ) ->
                    "assets/Wellington.png"

                ( 3, 2 ) ->
                    "assets/Alexander_I.png"

                ( 3, 3 ) ->
                    "assets/Alexander_I.png"

                _ ->
                    "assets/Napoleon.png"

        left_pos =
            case ( n, p ) of
                ( 1, 3 ) ->
                    fromFloat (width / 1.6) ++ "px"

                ( 2, 2 ) ->
                    fromFloat (width / 1.6) ++ "px"

                ( 2, 3 ) ->
                    fromFloat (width / 1.6) ++ "px"

                _ ->
                    fromFloat (width / 2.9) ++ "px"
    in
    div
        [ HtmlAttr.style "width" "100%"
        , HtmlAttr.style "height" "100%"
        , HtmlAttr.style "position" "fixed"
        , HtmlAttr.style "left" "0"
        , HtmlAttr.style "top" "0"
        ]
        [ Html.img
            [ HtmlAttr.style "left" (fromFloat (width / 4) ++ "px")
            , HtmlAttr.style "top" (fromFloat (height / 8) ++ "px")
            , HtmlAttr.style "width" (fromFloat (width / 2.2) ++ "px")
            , HtmlAttr.style "height" (fromFloat (height / 2.2) ++ "px")
            , HtmlAttr.style "position" "fixed"
            , HtmlAttr.src url
            , HtmlAttr.style "opacity" "1"
            ]
            []
        , Html.img
            [ HtmlAttr.style "left" left_pos
            , HtmlAttr.style "top" (fromFloat (height / 1.35) ++ "px")
            , HtmlAttr.style "width" (fromFloat (width / 20) ++ "px")
            , HtmlAttr.style "height" (fromFloat (height / 8) ++ "px")
            , HtmlAttr.style "position" "fixed"
            , HtmlAttr.src url_character
            , HtmlAttr.style "opacity" "1"
            ]
            []
        ]
