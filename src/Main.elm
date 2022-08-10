module Main exposing (..)

import Browser
import Browser.Dom exposing (getViewport)
import Task
import Model exposing (Model, initModel)
import Msg exposing (Msg(..))
import Subscriptions exposing (subscriptions)
import Update exposing (update)
import View exposing (view)
import General exposing (..)


init : () -> ( Model, Cmd Msg )
init _ =
    ( initModel, Task.perform GetViewport getViewport )


main : Program () Model Msg
main =
    Browser.element { init = init, update = update, subscriptions = subscriptions, view = view }
