module Help exposing (view_help)

import General exposing (GameState, Help_type(..), paragraph)
import Html exposing (Html, button, div, text)
import Html.Attributes as HtmlAttr exposing (..)
import Html.Events exposing (keyCode, onClick)
import MapGenerator exposing (Msg)
import Msg exposing (Msg(..))
import String exposing (fromFloat)

{-| View function for the help page-}
view_help : Help_type -> Int -> ( Float, Float ) -> Html Msg
view_help help passed_level ( width, height ) =
    div
        [ HtmlAttr.style "width" "100%"
        , HtmlAttr.style "height" "100%"
        , HtmlAttr.style "position" "fixed"
        ]
        [ view_help_background
        , view_button_story ( width, height )
        , view_button_division ( width, height )
        , view_button_operation ( width, height )
        , view_button_battle ( width, height )
        , view_help_text help passed_level ( width, height )

        , view_button_back (width, height)
        --, view_help_back ( width, height )
        ]


view_help_background : Html Msg
view_help_background =
    div
        [ HtmlAttr.style "width" "100%"
        , HtmlAttr.style "height" "100%"
        , HtmlAttr.style "position" "fixed"
        , HtmlAttr.style "background" "black"
        , HtmlAttr.style "opacity" "0.65"
        ]
        []


view_help_back : ( Float, Float ) -> Html Msg
view_help_back ( width, height ) =
    div
        [ HtmlAttr.style "left" (fromFloat (width / 1.7) ++ "px")
        , HtmlAttr.style "top" (fromFloat (height / 8.5) ++ "px")
        , HtmlAttr.style "position" "fixed"
        , HtmlAttr.style "font-family" "Helvetica, Arial, sans-serif"
        , HtmlAttr.style "font-size" "22px"
        , HtmlAttr.style "color" "rgb(255,229,180)"
        ]
        [ text "Press Space to continue" ]


view_help_text : Help_type -> Int -> ( Float, Float ) -> Html Msg
view_help_text help passed_level ( width, height ) =
    case help of
        Story ->
            view_text_story passed_level ( width, height )

        Operation ->
            view_text_operation ( width, height )

        Division_info ->
            view_text_division ( width, height )

        Battle_info ->
            view_text_battle ( width, height )

        _ ->
            div [] []


view_text_battle : ( Float, Float ) -> Html Msg
view_text_battle ( width, height ) =
    div
        [ HtmlAttr.style "height" "100%"
        , HtmlAttr.style "width" "100%"
        , HtmlAttr.style "left" (fromFloat (width / 5.5) ++ "px")
        , HtmlAttr.style "top" (fromFloat (height / 4) ++ "px")
        , HtmlAttr.style "position" "fixed"
        , HtmlAttr.style "font-family" "Helvetica, Arial, sans-serif"
        , HtmlAttr.style "font-size" "20px"
        , HtmlAttr.style "color" "white"
        ]
        [ paragraph "There are three types of battles:"
        , paragraph "Encounter: Two divisions are both moving"
        , paragraph "Offense: Active attack on stationary division"
        , paragraph "Defense: Attacked while stationary"
        , paragraph ""
        , paragraph "The battle result really comes from many factors"
        , paragraph "But certainly the side with more battle power gets more chance to win"
        , paragraph "And the loser will suffer much larger loss"
        , paragraph "There will be battle report for you after each fight"
        ]


view_text_operation : ( Float, Float ) -> Html Msg
view_text_operation ( width, height ) =
    div
        [ HtmlAttr.style "height" "100%"
        , HtmlAttr.style "width" "100%"
        , HtmlAttr.style "left" (fromFloat (width / 5.5) ++ "px")
        , HtmlAttr.style "top" (fromFloat (height / 4) ++ "px")
        , HtmlAttr.style "position" "fixed"
        , HtmlAttr.style "font-family" "Helvetica, Arial, sans-serif"
        , HtmlAttr.style "font-size" "20px"
        , HtmlAttr.style "color" "white"
        ]
        [ paragraph "mouse wheel UP -> Zoom IN"
        , paragraph "mouse wheel DOWN -> Zoom OUT"
        , paragraph ""
        , paragraph "mouse over the UPPER side of the screen -> Scroll UP"
        , paragraph "mouse over the BOTTOM side of the screen -> Scroll DOWN"
        , paragraph "mouse over the LEFT side of the screen -> Scroll LEFT"
        , paragraph "mouse over the RIGHT side of the screen -> Scroll RIGHT"
        , view_mouse_gif ( width, height )
        , view_mouse_intro ( width, height )
        ]


view_mouse_gif : ( Float, Float ) -> Html Msg
view_mouse_gif ( width, height ) =
    div
        [ HtmlAttr.style "height" "100%"
        , HtmlAttr.style "width" "100%"
        , HtmlAttr.style "left" "0px"
        , HtmlAttr.style "top" (fromFloat (height / 2) ++ "px")
        , HtmlAttr.style "position" "absolute"
        ]
        [ Html.img
            [ HtmlAttr.style "left" (fromFloat (width / 3.3) ++ "px")
            , HtmlAttr.style "top" (fromFloat (height / 1.6) ++ "px")
            , HtmlAttr.style "position" "fixed"
            , HtmlAttr.src "assets/left.gif"
            ]
            []
        , Html.img
            [ HtmlAttr.style "left" (fromFloat (width / 2) ++ "px")
            , HtmlAttr.style "top" (fromFloat (height / 1.6) ++ "px")
            , HtmlAttr.style "position" "fixed"
            , HtmlAttr.src "assets/right.gif"
            ]
            []
        ]


view_mouse_intro : ( Float, Float ) -> Html Msg
view_mouse_intro ( width, height ) =
    div
        [ HtmlAttr.style "height" "100%"
        , HtmlAttr.style "width" "100%"
        , HtmlAttr.style "position" "absolute"
        ]
        [ div
            [ HtmlAttr.style "left" (fromFloat (width / 3.7) ++ "px")
            , HtmlAttr.style "top" (fromFloat (height / 1.35) ++ "px")
            , HtmlAttr.style "position" "fixed"
            , HtmlAttr.style "font-family" "Helvetica, Arial, sans-serif"
            , HtmlAttr.style "font-size" "20px"
            , HtmlAttr.style "color" "white"
            ]
            [ paragraph "Left Click -> Pick Division" 
            , paragraph "Left Double Click -> Cancel the selcetion of Division"]
        , div
            [ HtmlAttr.style "left" (fromFloat (width / 2.2) ++ "px")
            , HtmlAttr.style "top" (fromFloat (height / 1.35) ++ "px")
            , HtmlAttr.style "position" "fixed"
            , HtmlAttr.style "font-family" "Helvetica, Arial, sans-serif"
            , HtmlAttr.style "font-size" "20px"
            , HtmlAttr.style "color" "white"
            ]
            [ text "Right Click -> Set Destination" ]
        ]


view_text_division : ( Float, Float ) -> Html Msg
view_text_division ( width, height ) =
    div
        [ HtmlAttr.style "height" "100%"
        , HtmlAttr.style "width" "100%"
        , HtmlAttr.style "left" (fromFloat (width / 5.5) ++ "px")
        , HtmlAttr.style "top" (fromFloat (height / 4) ++ "px")
        , HtmlAttr.style "position" "fixed"
        , HtmlAttr.style "font-family" "Helvetica, Arial, sans-serif"
        , HtmlAttr.style "font-size" "20px"
        , HtmlAttr.style "color" "white"
        ]
        [ paragraph "Aside from number of soldiers, Divisions' fighting power are influenced by terrains, nations and battle type"
        , paragraph "Fast Division: More moving points, weak in Defense, stronger from France"
        , paragraph "Guard Division: Good at defense, weak in Encounter and Offense, good in Mountain, stronger from Britain"
        , paragraph "Engineer Division: Good at Defense and Offense, weak in Mountain, stronger from Austria"
        , paragraph "Grenadier Division: Very good at Offense, weak in Mountain and Forest, stronger from Russia"
        , view_division_photos ( width, height )
        , view_division_labels ( width, height )
        ]


view_division_labels : ( Float, Float ) -> Html Msg
view_division_labels ( width, height ) =
    div
        [ HtmlAttr.style "height" "100%"
        , HtmlAttr.style "width" "100%"
        , HtmlAttr.style "position" "absolute"
        ]
        [ div
            [ HtmlAttr.style "left" (fromFloat (width / 2) ++ "px")
            , HtmlAttr.style "top" (fromFloat (height / 1.4) ++ "px")
            , HtmlAttr.style "position" "fixed"
            , HtmlAttr.style "font-family" "Helvetica, Arial, sans-serif"
            , HtmlAttr.style "font-size" "20px"
            , HtmlAttr.style "color" "white"
            ]
            [ text "Guard" ]
        , div
            [ HtmlAttr.style "left" (fromFloat (width / 2 - 192) ++ "px")
            , HtmlAttr.style "top" (fromFloat (height / 1.4) ++ "px")
            , HtmlAttr.style "position" "fixed"
            , HtmlAttr.style "font-family" "Helvetica, Arial, sans-serif"
            , HtmlAttr.style "font-size" "20px"
            , HtmlAttr.style "color" "white"
            ]
            [ text "Fast" ]
        , div
            [ HtmlAttr.style "left" (fromFloat (width / 2 + 192) ++ "px")
            , HtmlAttr.style "top" (fromFloat (height / 1.4) ++ "px")
            , HtmlAttr.style "position" "fixed"
            , HtmlAttr.style "font-family" "Helvetica, Arial, sans-serif"
            , HtmlAttr.style "font-size" "20px"
            , HtmlAttr.style "color" "white"
            ]
            [ text "Grenadier" ]
        , div
            [ HtmlAttr.style "left" (fromFloat (width / 2 - 384) ++ "px")
            , HtmlAttr.style "top" (fromFloat (height / 1.4) ++ "px")
            , HtmlAttr.style "position" "fixed"
            , HtmlAttr.style "font-family" "Helvetica, Arial, sans-serif"
            , HtmlAttr.style "font-size" "20px"
            , HtmlAttr.style "color" "white"
            ]
            [ text "Engineer" ]
        ]


view_division_photos : ( Float, Float ) -> Html Msg
view_division_photos ( width, height ) =
    div
        [ HtmlAttr.style "height" "100%"
        , HtmlAttr.style "width" "100%"
        , HtmlAttr.style "left" "0px"
        , HtmlAttr.style "top" (fromFloat (height / 2) ++ "px")
        , HtmlAttr.style "position" "absolute"
        ]
        [ Html.img
            [ HtmlAttr.style "left" (fromFloat (width / 2) ++ "px")
            , HtmlAttr.style "top" (fromFloat (height / 1.7) ++ "px")
            , HtmlAttr.style "position" "fixed"
            , HtmlAttr.src "assets/Guard_div_France.png"
            ]
            []
        , Html.img
            [ HtmlAttr.style "left" (fromFloat (width / 2 - 192) ++ "px")
            , HtmlAttr.style "top" (fromFloat (height / 1.7) ++ "px")
            , HtmlAttr.style "position" "fixed"
            , HtmlAttr.src "assets/Fast_div_France.png"
            ]
            []
        , Html.img
            [ HtmlAttr.style "left" (fromFloat (width / 2 + 192) ++ "px")
            , HtmlAttr.style "top" (fromFloat (height / 1.7) ++ "px")
            , HtmlAttr.style "position" "fixed"
            , HtmlAttr.src "assets/Grenadier_div_France.png"
            ]
            []
        , Html.img
            [ HtmlAttr.style "left" (fromFloat (width / 2 - 384) ++ "px")
            , HtmlAttr.style "top" (fromFloat (height / 1.7) ++ "px")
            , HtmlAttr.style "position" "fixed"
            , HtmlAttr.src "assets/Engineer_div_France.png"
            ]
            []
        ]


view_text_story : Int -> ( Float, Float ) -> Html Msg
view_text_story passed_level ( width, height ) =
    case passed_level of
        0 ->
            div
                [ HtmlAttr.style "height" "100%"
                , HtmlAttr.style "width" "100%"
                , HtmlAttr.style "left" (fromFloat (width / 5.5) ++ "px")
                , HtmlAttr.style "top" (fromFloat (height / 4) ++ "px")
                , HtmlAttr.style "position" "fixed"
                , HtmlAttr.style "font-family" "Helvetica, Arial, sans-serif"
                , HtmlAttr.style "font-size" "20px"
                , HtmlAttr.style "color" "white"
                ]
                [ paragraph "After a series of victory in France and Italy led by brilliant French commanders, the First Coalition was broken"
                , paragraph "In order to give Britain, a country that had been at feud with France for hundreds of years, a strong blow"
                , paragraph "French government decided to sent Napolean to launch an expedition to Egypt"
                , paragraph "Despite the victories he acquired as well as the land his army captured"
                , paragraph "Napolean suffered from the lack of supplement as his fleet was defeated by Nelson's fleet"
                , paragraph "As a saying goes, misfortunes never come singly, bad news came. "
                , paragraph "Those countries defeated years ago gathered together again and formed the second Coalition ally and soon launched a well-prepared attacking"
                , paragraph "To make things worse, his colleagues, General Massena and General Moreau, were not able to defend the fierce offence"
                , paragraph "planned and commanded by Suvolov, a famous Russian general, in northern Italy"
                , paragraph "The mainland of France was threatened then"
                , paragraph "Therefore, the government had no choice but called back Napolean to save the severe situation......"
                ]
        1 ->
            div
                [ HtmlAttr.style "height" "100%"
                , HtmlAttr.style "width" "100%"
                , HtmlAttr.style "left" (fromFloat (width / 5.5) ++ "px")
                , HtmlAttr.style "top" (fromFloat (height / 4) ++ "px")
                , HtmlAttr.style "position" "fixed"
                , HtmlAttr.style "font-family" "Helvetica, Arial, sans-serif"
                , HtmlAttr.style "font-size" "20px"
                , HtmlAttr.style "color" "white"
                ]
                [ paragraph "In 1804, Napoleon was crowned emperor of France."
                , paragraph "But in the next year, French and Spain fleets were completelly destroyed by British Royal Navy in Trafalgar."
                , paragraph "The victory of Briain greatlly relit the hope for the Russian and Austrian to defeat Napoleon and his army. "
                , paragraph "They then quickly formed the Third Coalition."
                , paragraph "With their strong desire to defeat and shame Napoleon, kings of Austria and Russia both decided to personally command their expedition."
                , paragraph "To make things worse, Prussia showed great interest in joining the Coalition and was quietly preparing for the war."
                , paragraph "Faced with this tough situation, Napoleon had to launch a fierce attack to destroy the Russian and Austrian coalition forces as soon as possible."
                , paragraph "The two armies encountered each other near a small town called Austeritz unexpectedly."
                , paragraph "Oh, there is one more note about the battle."
                , paragraph "With the three emperors personally commanding their armies, the battle was also known as the Battle of the Three Emperors."
                
                ]
        _ ->
            div
                [ HtmlAttr.style "height" "100%"
                , HtmlAttr.style "width" "100%"
                , HtmlAttr.style "left" (fromFloat (width / 5.5) ++ "px")
                , HtmlAttr.style "top" (fromFloat (height / 4) ++ "px")
                , HtmlAttr.style "position" "fixed"
                , HtmlAttr.style "font-family" "Helvetica, Arial, sans-serif"
                , HtmlAttr.style "font-size" "20px"
                , HtmlAttr.style "color" "white"
                ]
                [ paragraph "Due to the cold winter and lack of supplies, Napoleon and his 600 thousand soldiers suffered their greatest failure in Russia."
                , paragraph "After that failure, the former allies rebelled France again and formed another coalition."
                , paragraph "Napoleon had to declared his abdication and was exiled to Elba in the same year."
                , paragraph "However, he never gave up planning to stage a comeback and rebuild his empire."
                , paragraph "In 1815, he caught the chance and landed in Antibes."
                , paragraph "On his way to Paris, most of the French armies sent to catch him refused to shoot their previous emperor."
                , paragraph "Therefore, Napoleon regained his power in a very short period of time."
                , paragraph "However, Napoleon's return greatly shocked the other countries."
                , paragraph "And they quickly gathered together and formed the Seventh Coalition."
                , paragraph "Napoleon had no choice but to get prepared for the upcoming fight."
                , paragraph "Battle took place near an unknown village called Waterloo."
                ]


view_button_operation : ( Float, Float ) -> Html Msg
view_button_operation ( width, height ) =
    div
        [ HtmlAttr.style "height" "100%"
        , HtmlAttr.style "width" "100%"
        , HtmlAttr.style "left" (fromFloat (width / 2 + 10) ++ "px")
        , HtmlAttr.style "top" (fromFloat (height / 6) ++ "px")
        , HtmlAttr.style "position" "fixed"
        ]
        [ Html.button
            [ Html.Events.onClick (Helpmsg Operation)
            , HtmlAttr.style "background" "rgb(63,78,79)"
            , HtmlAttr.style "color" "White"
            , HtmlAttr.style "cursor" "pointer"
            , HtmlAttr.style "font-family" "Helvetica, Arial, sans-serif"
            , HtmlAttr.style "display" "block"
            , HtmlAttr.style "font-size" "25px"
            , HtmlAttr.style "height" "40px"
            , HtmlAttr.style "width" "160px"
            ]
            [ Html.text "Operation" ]
        ]


view_button_back : ( Float, Float ) -> Html Msg
view_button_back ( width, height ) =
    div
        [ HtmlAttr.style "height" "100%"
        , HtmlAttr.style "width" "100%"
        , HtmlAttr.style "left" (fromFloat (width / 2 + 280) ++ "px")
        , HtmlAttr.style "top" (fromFloat (height / 6 + 600) ++ "px")
        , HtmlAttr.style "position" "fixed"
        ]
        [ Html.button
            [ Html.Events.onClick (Helpmsg Back_to_game)
            , HtmlAttr.style "background" "rgb(63,78,79)"
            , HtmlAttr.style "color" "White"
            , HtmlAttr.style "cursor" "pointer"
            , HtmlAttr.style "font-family" "Helvetica, Arial, sans-serif"
            , HtmlAttr.style "display" "block"
            , HtmlAttr.style "font-size" "25px"
            , HtmlAttr.style "height" "40px"
            , HtmlAttr.style "width" "160px"
            ]
            [ Html.text "Back" ]
        ]


view_button_story : ( Float, Float ) -> Html Msg
view_button_story ( width, height ) =
    div
        [ HtmlAttr.style "height" "100%"
        , HtmlAttr.style "width" "100%"
        , HtmlAttr.style "left" (fromFloat (width / 2 - 550) ++ "px")
        , HtmlAttr.style "top" (fromFloat (height / 6) ++ "px")
        , HtmlAttr.style "position" "fixed"
        ]
        [ Html.button
            [ Html.Events.onClick (Helpmsg Story)
            , HtmlAttr.style "background" "rgb(63,78,79)"
            , HtmlAttr.style "color" "White"
            , HtmlAttr.style "cursor" "pointer"
            , HtmlAttr.style "font-family" "Helvetica, Arial, sans-serif"
            , HtmlAttr.style "display" "block"
            , HtmlAttr.style "font-size" "25px"
            , HtmlAttr.style "height" "40px"
            , HtmlAttr.style "width" "160px"
            ]
            [ Html.text "Story" ]
        ]


view_button_division : ( Float, Float ) -> Html Msg
view_button_division ( width, height ) =
    div
        [ HtmlAttr.style "height" "100%"
        , HtmlAttr.style "width" "100%"
        , HtmlAttr.style "left" (fromFloat (width / 2 - 270) ++ "px")
        , HtmlAttr.style "top" (fromFloat (height / 6) ++ "px")
        , HtmlAttr.style "position" "fixed"
        ]
        [ Html.button
            [ Html.Events.onClick (Helpmsg Division_info)
            , HtmlAttr.style "background" "rgb(63,78,79)"
            , HtmlAttr.style "color" "White"
            , HtmlAttr.style "cursor" "pointer"
            , HtmlAttr.style "font-family" "Helvetica, Arial, sans-serif"
            , HtmlAttr.style "display" "block"
            , HtmlAttr.style "font-size" "25px"
            , HtmlAttr.style "height" "40px"
            , HtmlAttr.style "width" "160px"
            ]
            [ Html.text "Division" ]
        ]


view_button_battle : ( Float, Float ) -> Html Msg
view_button_battle ( width, height ) =
    div
        [ HtmlAttr.style "height" "100%"
        , HtmlAttr.style "width" "100%"
        , HtmlAttr.style "left" (fromFloat (width / 2 + 290) ++ "px")
        , HtmlAttr.style "top" (fromFloat (height / 6) ++ "px")
        , HtmlAttr.style "position" "fixed"
        ]
        [ Html.button
            [ Html.Events.onClick (Helpmsg Battle_info)
            , HtmlAttr.style "background" "rgb(63,78,79)"
            , HtmlAttr.style "color" "White"
            , HtmlAttr.style "cursor" "pointer"
            , HtmlAttr.style "font-family" "Helvetica, Arial, sans-serif"
            , HtmlAttr.style "display" "block"
            , HtmlAttr.style "font-size" "25px"
            , HtmlAttr.style "height" "40px"
            , HtmlAttr.style "width" "160px"
            ]
            [ Html.text "Battle" ]
        ]
