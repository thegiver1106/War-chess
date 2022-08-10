module Turn_page exposing (turn_lose_page, turn_win_page, view_beginning_page, view_ending, view_lose_page, view_win_page)

import General exposing (..)
import Html exposing (Html, a, button, div, text)
import Html.Attributes as HtmlAttr exposing (..)
import Html.Events exposing (keyCode, onClick)
import MapGenerator exposing (Msg)
import String exposing (fromFloat)
import Sub_turn_page exposing (..)


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

{-| The page that will appear after the player wins a level-}
turn_win_page : Int -> Int -> GameState
turn_win_page n p =
    if n == 3 then
        if p == 3 then
            Ending

        else
            Win_turn_page n (p + 1)

    else if p == 3 then
        LevelChoosing

    else
        Win_turn_page n (p + 1)

{-| The page that will appear after the player loses a level-}
turn_lose_page : Int -> Int -> GameState
turn_lose_page n p =
    if p == 3 then
        LevelChoosing

    else
        Lose_turn_page n (p + 1)

{-| View the page that will appear after the player wins a level-}
view_win_page : Int -> Int -> ( Float, Float ) -> Float -> Html msg
view_win_page n p ( width, height ) time =
    div
        [ HtmlAttr.style "width" "100%"
        , HtmlAttr.style "height" "100%"
        , HtmlAttr.style "position" "fixed"
        , HtmlAttr.style "left" "0"
        , HtmlAttr.style "top" "0"
        , HtmlAttr.style "background-color" "rgb(44, 51, 51)"
        ]
        [ view_turn_background ( width, height )
        , view_win_images n p ( width, height ) time
        , view_win_turning_text n p ( width, height ) time
        , view_continue ( width, height )
        , view_win_title n p ( width, height )
        ]

{-| View the page that will appear after the player loses a level-}
view_lose_page : Int -> Int -> ( Float, Float ) -> Float -> Html msg
view_lose_page n p ( width, height ) time =
    div
        [ HtmlAttr.style "width" "100%"
        , HtmlAttr.style "height" "100%"
        , HtmlAttr.style "position" "fixed"
        , HtmlAttr.style "left" "0"
        , HtmlAttr.style "top" "0"
        , HtmlAttr.style "background-color" "rgb(44, 51, 51)"
        ]
        [ view_turn_background ( width, height )
        , view_lose_images n p ( width, height ) time
        , view_lose_turning_text n p ( width, height ) time
        , view_continue ( width, height )
        , view_lose_title n p ( width, height )
        ]

{-| View the animation at the beginning of the whole game-}
view_beginning_page : Float -> ( Float, Float ) -> Html msg
view_beginning_page time ( width, height ) =
    if time <= 10000 then
        view_beginning_scene_1 time ( width, height )

    else if time <= 20000 then
        view_beginning_scene_2 time ( width, height )

    else if time <= 30000 then
        view_beginning_scene_3 time ( width, height )

    else if time <= 40000 then
        view_beginning_scene_4 time ( width, height )

    else
        div [] []


view_win_turning_text : Int -> Int -> ( Float, Float ) -> Float -> Html msg
view_win_turning_text n p ( width, height ) time =
    let
        opacity =
            if time <= 100 then
                fromFloat (time / 100)

            else
                "1"
    in
    div
        [ HtmlAttr.style "height" "100%"
        , HtmlAttr.style "width" "100%"
        , HtmlAttr.style "left" (fromFloat (width / 2.5) ++ "px")
        , HtmlAttr.style "top" (fromFloat (height / 1.4) ++ "px")
        , HtmlAttr.style "position" "fixed"
        , HtmlAttr.style "font-family" "Helvetica, Arial, sans-serif"
        , HtmlAttr.style "font-size" "30px"
        , HtmlAttr.style "color" "black"
        , HtmlAttr.style "opacity" opacity
        ]
        (view_win_paragraph n p)


view_lose_turning_text : Int -> Int -> ( Float, Float ) -> Float -> Html msg
view_lose_turning_text n p ( width, height ) time =
    let
        opacity =
            if time <= 100 then
                fromFloat (time / 100)

            else
                "1"
    in
    div
        [ HtmlAttr.style "height" "100%"
        , HtmlAttr.style "width" "100%"
        , HtmlAttr.style "left" (fromFloat (width / 2.4) ++ "px")
        , HtmlAttr.style "top" (fromFloat (height / 1.4) ++ "px")
        , HtmlAttr.style "position" "fixed"
        , HtmlAttr.style "font-family" "Helvetica, Arial, sans-serif"
        , HtmlAttr.style "font-size" "30px"
        , HtmlAttr.style "color" "black"
        , HtmlAttr.style "opacity" opacity
        ]
        (view_lose_paragraph n p)


view_lose_paragraph : Int -> Int -> List (Html msg)
view_lose_paragraph n p =
    if n == 1 then
        if p == 1 then
            [ paragraph "Napoleon:"
            , paragraph "We have no more men "
            , paragraph "to make up for the great loss."
            ]

        else if p == 2 then
            [ paragraph "Massena:"
            , paragraph "We have no choice"
            , paragraph "but to accept the truth"
            ]

        else
            [ paragraph "Massena:"
            , paragraph "That we have completely"
            , paragraph "lost this war"
            ]

    else if n == 2 then
        if p == 1 then
            [ paragraph "Alexander I:"
            , paragraph "The dwarf and his"
            , paragraph "French monkeys are weak"
            ]

        else if p == 2 then
            [ paragraph "Alexander I:"
            , paragraph "They can't withstand"
            , paragraph "a single blow!"
            ]

        else
            [ paragraph "Franz II:"
            , paragraph "Can't wait to parade in Paris!"
            ]

    else if n == 3 then
        if p == 1 then
            [ paragraph "Duke of Wellington:"
            , paragraph "Now the beast "
            , paragraph "from Corsica is in cage."
            ]

        else if p == 2 then
            [ paragraph "Alexander I:"
            , paragraph " Peace and order"
            , paragraph "descend upon Europe again."
            ]

        else
            [ paragraph "Alexander I:"
            , paragraph "God bless Europe!"
            ]

    else
        []


view_win_paragraph : Int -> Int -> List (Html msg)
view_win_paragraph n p =
    if n == 1 then
        if p == 1 then
            [ paragraph "Napoleon:"
            , paragraph "What a wonderful day it will be"
            , paragraph "if I can now hug Desaix to celebrate"
            ]

        else if p == 2 then
            [ paragraph "Napoleon:"
            , paragraph "But victory always pays blood"
            ]

        else
            [ paragraph "Franz II:"
            , paragraph "We have lost the whole Italy."
            , paragraph "It is a sad day for the whole country."
            ]

    else if n == 2 then
        if p == 1 then
            [ paragraph "Napoleon:"
            , paragraph "No on can stop us in the battlefield!"
            ]

        else if p == 2 then
            [ paragraph "Franz II:"
            , paragraph "We have to face the truth: "
            ]

        else
            [ paragraph "Franz II:"
            , paragraph "The Holy Roman Empire will "
            , paragraph "no longer exist."
            ]

    else if n == 3 then
        if p == 1 then
            [ paragraph "Ney:"
            , paragraph "Unbelievable! We made it!"
            ]

        else if p == 2 then
            [ paragraph "Napoleon:"
            , paragraph " The whole Europe now kneels before me! "
            ]

        else
            [ paragraph "Napoleon:"
            , paragraph "God bless France"
            ]

    else
        []


view_continue : ( Float, Float ) -> Html msg
view_continue ( width, height ) =
    div
        [ HtmlAttr.style "left" (fromFloat (width / 1.7) ++ "px")
        , HtmlAttr.style "top" (fromFloat (height / 1.05) ++ "px")
        , HtmlAttr.style "position" "fixed"
        , HtmlAttr.style "font-family" "Helvetica, Arial, sans-serif"
        , HtmlAttr.style "font-size" "22px"
        , HtmlAttr.style "color" "rgb(255,229,180)"
        ]
        [ text "Press Enter to continue" ]


view_turn_background : ( Float, Float ) -> Html msg
view_turn_background ( width, height ) =
    div
        [ HtmlAttr.style "width" "100%"
        , HtmlAttr.style "height" "100%"
        , HtmlAttr.style "position" "fixed"
        , HtmlAttr.style "left" "0"
        , HtmlAttr.style "top" "0"
        ]
        [ Html.img
            [ HtmlAttr.style "left" (fromFloat (width / 5) ++ "px")
            , HtmlAttr.style "top" "0px"
            , HtmlAttr.style "width" (fromFloat (width / 1.7) ++ "px")
            , HtmlAttr.style "height" (fromFloat height ++ "px")
            , HtmlAttr.style "position" "fixed"
            , HtmlAttr.src "assets/Turn_page/Turn_background.png"
            ]
            []
        ]


view_win_title : Int -> Int -> ( Float, Float ) -> Html msg
view_win_title n p ( width, height ) =
    let
        title =
            case n of
                1 ->
                    "News:Napoleon Brings Victory Back! "

                2 ->
                    "News:100 Thousand Russian and Austrian Destroyed in 4 Days"

                _ ->
                    "News:The Emperor Returned to His Faithful Europe!"
    in
    div
        [ HtmlAttr.style "height" "100%"
        , HtmlAttr.style "width" "100%"
        , HtmlAttr.style "left" (fromFloat (width / 4) ++ "px")
        , HtmlAttr.style "top" (fromFloat (height / 25) ++ "px")
        , HtmlAttr.style "position" "fixed"
        , HtmlAttr.style "font-family" "Helvetica, Arial, sans-serif"
        , HtmlAttr.style "font-size" "40px"
        , HtmlAttr.style "color" "black"
        ]
        [ paragraph title
        ]


view_lose_title : Int -> Int -> ( Float, Float ) -> Html msg
view_lose_title n p ( width, height ) =
    let
        title =
            case n of
                1 ->
                    "News: Austrian Army Are Unstoppable. "

                2 ->
                    "News: Shame! We have lost the war!"

                _ ->
                    "News: Napoleon In Exile!"
    in
    div
        [ HtmlAttr.style "height" "100%"
        , HtmlAttr.style "width" "100%"
        , HtmlAttr.style "left" (fromFloat (width / 4) ++ "px")
        , HtmlAttr.style "top" (fromFloat (height / 25) ++ "px")
        , HtmlAttr.style "position" "fixed"
        , HtmlAttr.style "font-family" "Helvetica, Arial, sans-serif"
        , HtmlAttr.style "font-size" "40px"
        , HtmlAttr.style "color" "black"
        ]
        [ paragraph title
        ]

{-| View the ending picture after the player passes all the levels-}
view_ending : Float -> ( Float, Float ) -> Html msg
view_ending time ( width, height ) =
    let
        opacity =
            if time <= 200 then
                fromFloat (time / 200)

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
            [ HtmlAttr.style "left" (fromFloat (width / 10) ++ "px")
            , HtmlAttr.style "top" (fromFloat (height / 7) ++ "px")
            , HtmlAttr.style "width" (fromFloat (width / 3) ++ "px")
            , HtmlAttr.style "height" (fromFloat (height / 1.5) ++ "px")
            , HtmlAttr.style "position" "fixed"
            , HtmlAttr.src "assets/Turn_page/Ending.png"
            , HtmlAttr.style "opacity" opacity
            ]
            []
        , view_text_ending time ( width, height )
        ]


view_text_ending : Float -> ( Float, Float ) -> Html msg
view_text_ending time ( width, height ) =
    let
        opacity =
            if time <= 100 then
                fromFloat (time / 100)

            else
                "1"
    in
    div
        [ HtmlAttr.style "height" "100%"
        , HtmlAttr.style "width" "100%"
        , HtmlAttr.style "left" (fromFloat (width / 1.7) ++ "px")
        , HtmlAttr.style "top" (fromFloat (height / 3.5) ++ "px")
        , HtmlAttr.style "position" "fixed"
        , HtmlAttr.style "font-family" "Helvetica, Arial, sans-serif"
        , HtmlAttr.style "font-size" "80px"
        , HtmlAttr.style "color" "white"
        , HtmlAttr.style "opacity" opacity
        ]
        [ paragraph "Your majesty!"
        , paragraph ""
        , paragraph "The Glory is yours now"
        ]
