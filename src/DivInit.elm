module DivInit exposing (player_army_init, enemy_army_init)

import Div exposing (Div)
import General exposing (..)


list_1_player : List Div
list_1_player =
    [ Div.init Grenadier France ( 12, 15 ) 1
    , Div.init Fast France ( 18, 2 ) 2
    , Div.init Guard France ( 15, 3 ) 3
    , Div.init Guard France ( 16, 2 ) 4
    , Div.init Engineer France ( 5, 3 ) 5
    , Div.init Grenadier France ( 5, 5 ) 6
    ]


list_2_player : List Div
list_2_player =
    [ Div.init Guard France ( 19, 7 ) 1
    , Div.init Fast France ( 18, 6 ) 2
    , Div.init Grenadier France ( 18, 8 ) 3
    , Div.init Guard France ( 2, 6 ) 4
    , Div.init Grenadier France ( 3, 7 ) 5
    , Div.init Engineer France ( 1, 5 ) 6
    , Div.init Fast France ( 1, 2 ) 7
    , Div.init Guard France ( 10, 5 ) 8
    , Div.init Engineer France ( 2, 7 ) 9
    , Div.init Guard France ( 4, 7 ) 10
    , Div.init Engineer France ( 3, 3 ) 11
    ]


list_3_player : List Div
list_3_player =
    [ Div.init Fast France ( 3, 9 ) 1
    , Div.init Fast France ( 4, 9 ) 2
    , Div.init Grenadier France ( 5, 9 ) 3
    , Div.init Grenadier France ( 4, 8 ) 4
    , Div.init Grenadier France ( 15, 7 ) 5
    , Div.init Engineer France ( 16, 7 ) 6
    , Div.init Fast France ( 15, 6 ) 7
    , Div.init Guard France ( 10, 5 ) 8
    , Div.init Engineer France ( 11, 5 ) 9
    , Div.init Guard France ( 7, 4 ) 10
    , Div.init Guard France ( 8, 3 ) 11
    , Div.init Guard France ( 7, 3 ) 12
    ]


list_4_player : List Div
list_4_player =
    [ Div.init Guard France ( 10, 7 ) 1
    , Div.init Fast France ( 6, 6 ) 2
    , Div.init Grenadier France ( 8, 8 ) 3
    , Div.init Guard France ( 8, 6 ) 4
    , Div.init Grenadier France ( 9, 7 ) 5
    , Div.init Engineer France ( 1, 5 ) 6
    , Div.init Fast France ( 10, 6 ) 7
    , Div.init Guard France ( 10, 5 ) 8
    , Div.init Engineer France ( 9, 8 ) 9
    , Div.init Guard France ( 6, 8 ) 10
    , Div.init Engineer France ( 7, 3 ) 11
    ]


list_1_enemy : List Div
list_1_enemy =
    [ Div.init Guard Austria ( 11, 18 ) 7
    , Div.init Fast Austria ( 12, 17 ) 8
    , Div.init Grenadier Austria ( 12, 19 ) 9
    , Div.init Guard Austria ( 3, 18 ) 10
    , Div.init Fast Austria ( 3, 25 ) 11
    , Div.init Guard Austria ( 5, 26 ) 12
    , Div.init Grenadier Austria ( 10, 22 ) 13
    , Div.init Engineer Austria ( 6, 27 ) 14
    ]


list_2_enemy : List Div
list_2_enemy =
    List.append
        [ Div.init Engineer Austria ( 12, 10 ) 12
        , Div.init Guard Austria ( 11, 11 ) 13
        , Div.init Guard Austria ( 18, 13 ) 14
        , Div.init Fast Austria ( 1, 11 ) 15
        , Div.init Guard Austria ( 15, 27 ) 16
        , Div.init Engineer Austria ( 11, 23 ) 17
        , Div.init Grenadier Austria ( 5, 10 ) 18
        , Div.init Guard Austria ( 3, 10 ) 19
        , Div.init Fast Austria ( 14, 9 ) 20
        ]
        [ Div.init Fast Russia ( 1, 27 ) 21
        , Div.init Fast Russia ( 2, 27 ) 22
        , Div.init Fast Russia ( 3, 27 ) 23
        , Div.init Guard Russia ( 11, 28 ) 24
        , Div.init Grenadier Russia ( 5, 17 ) 25
        , Div.init Grenadier Russia ( 6, 17 ) 26
        , Div.init Engineer Russia ( 2, 15 ) 27
        , Div.init Guard Russia ( 14, 28 ) 28
        ]


list_3_enemy : List Div
list_3_enemy =
    [ Div.init Engineer Prussia ( 17, 10 ) 13
    , Div.init Grenadier Prussia ( 16, 9 ) 14
    , Div.init Guard Prussia ( 16, 23 ) 15
    , Div.init Fast Prussia ( 11, 16 ) 16
    , Div.init Guard Prussia ( 12, 16 ) 17
    , Div.init Fast Prussia ( 12, 17 ) 18
    , Div.init Grenadier Prussia ( 13, 17 ) 19
    ]
        ++ [ Div.init Grenadier Prussia ( 15, 21 ) 20
           , Div.init Guard Prussia ( 15, 22 ) 21
           , Div.init Grenadier Britain ( 3, 13 ) 22
           , Div.init Engineer Britain ( 4, 13 ) 23
           , Div.init Engineer Britain ( 5, 13 ) 24
           , Div.init Grenadier Britain ( 6, 13 ) 25
           , Div.init Grenadier Britain ( 5, 12 ) 26
           , Div.init Grenadier Britain ( 6, 12 ) 27
           ]
        ++ [ Div.init Engineer Britain ( 4, 13 ) 28
           , Div.init Guard Britain ( 9, 14 ) 29
           , Div.init Guard Britain ( 6, 15 ) 30
           , Div.init Guard Britain ( 7, 15 ) 31
           , Div.init Fast Britain ( 7, 21 ) 32
           , Div.init Fast Britain ( 8, 21 ) 33
           ]
        ++ [ Div.init Fast Britain ( 9, 21 ) 34
           , Div.init Guard Britain ( 4, 26 ) 35
           , Div.init Fast Britain ( 1, 24 ) 36
           , Div.init Guard Britain ( 2, 24 ) 37
           , Div.init Grenadier Britain ( 5, 28 ) 38
           , Div.init Grenadier Britain ( 6, 28 ) 39
           , Div.init Guard Britain ( 4, 29 ) 40
           ]


list_4_enemy : List Div
list_4_enemy =
    [ Div.init Engineer Prussia ( 17, 10 ) 13
    , Div.init Grenadier Prussia ( 16, 9 ) 14
    , Div.init Guard Prussia ( 16, 23 ) 15
    , Div.init Fast Prussia ( 11, 16 ) 16
    , Div.init Guard Prussia ( 12, 16 ) 17
    , Div.init Fast Prussia ( 12, 17 ) 18
    , Div.init Guard Prussia ( 15, 22 ) 21
    ]
        ++ [ Div.init Grenadier Britain ( 3, 13 ) 22
           , Div.init Engineer Britain ( 4, 13 ) 23
           , Div.init Engineer Britain ( 5, 13 ) 24
           , Div.init Grenadier Britain ( 6, 13 ) 25
           , Div.init Grenadier Britain ( 5, 12 ) 26
           , Div.init Grenadier Britain ( 6, 12 ) 27
           ]
        ++ [ Div.init Engineer Britain ( 4, 13 ) 28
           , Div.init Guard Britain ( 9, 14 ) 29
           , Div.init Guard Britain ( 6, 15 ) 30
           , Div.init Guard Britain ( 7, 15 ) 31
           , Div.init Fast Britain ( 7, 21 ) 32
           , Div.init Fast Britain ( 8, 21 ) 33
           ]
        ++ [ Div.init Fast Britain ( 9, 21 ) 34
           , Div.init Guard Britain ( 4, 26 ) 35
           , Div.init Fast Britain ( 1, 24 ) 36
           , Div.init Guard Britain ( 2, 24 ) 37
           , Div.init Grenadier Britain ( 5, 28 ) 38
           , Div.init Grenadier Britain ( 6, 28 ) 39
           , Div.init Guard Britain ( 4, 29 ) 40
           ]

{-| The inintial divisions the player has for each level-}
player_army_init : Int -> List Div
player_army_init level =
    if level == 1 then
        list_1_player

    else if level == 2 then
        list_2_player

    else if level == 3 then
        list_3_player

    else if level == 4 then
        list_4_player

    else
        []

{-| The inintial divisions the enemy has for each level-}
enemy_army_init : Int -> List Div
enemy_army_init level =
    if level == 1 then
        list_1_enemy

    else if level == 2 then
        list_2_enemy

    else if level == 3 then
        list_3_enemy

    else if level == 4 then
        list_4_enemy

    else
        []
