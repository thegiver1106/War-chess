module Subscriptions exposing (subscriptions)

import Browser.Dom exposing (getViewport)
import Browser.Events exposing (onAnimationFrameDelta, onKeyDown, onKeyUp, onResize)
import General exposing (..)
import Html exposing (Attribute)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Decode
import Model exposing (..)
import Msg exposing (..)

{-| Subscriptions used-}
subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ onAnimationFrameDelta Tick
        , onKeyDown (Decode.map key_down keyCode)
        , onKeyUp (Decode.map key_up keyCode)

        -- , onclick
        -- , onResize Resize
        -- , onMouseOver
        ]


key_down : Int -> Msg
key_down keycode =
    case keycode of
        90 ->
            -- Z to zoom in
            Zoom In

        88 ->
            -- X to zoom out
            Zoom Out

        32 ->
            Helpmsg Back_to_game

        13 ->
            Next_page

        49 ->
            BlockChangeMsg (ChangeNation France)

        50 ->
            BlockChangeMsg (ChangeNation Prussia)

        51 ->
            BlockChangeMsg (ChangeNation Russia)

        52 ->
            BlockChangeMsg (ChangeNation Britain)

        53 ->
            BlockChangeMsg (ChangeNation Austria)

        54 ->
            OutputMap

        81 ->
            BlockChangeMsg (ChangeTerrain Water)

        87 ->
            BlockChangeMsg (ChangeTerrain Forest)

        69 ->
            BlockChangeMsg (ChangeTerrain Plain)

        82 ->
            BlockChangeMsg (ChangeTerrain Mountain)

        79 ->
            Win_level_1

        80 ->
            Lose_level_2

        _ ->
            KeyNone


key_up : Int -> Msg
key_up keycode =
    case keycode of
        _ ->
            KeyNone
