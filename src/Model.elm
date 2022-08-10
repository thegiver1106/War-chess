module Model exposing (..)

-- import Div exposing (Tactic)

import Battle exposing (Battle)
import Div exposing (..)
import Enemy exposing (Enemy)
import Events exposing (Events)
import General exposing (..)
import Map exposing (Map)
import Player exposing (Player)
import Report exposing (Report)
import Sound exposing (Sound)

{-| Definition of Model-}
type alias Model =
    { play_state : Play_state -- this round's situation
    , player : Player -- information about player
    , map : Map
    , enemy : Enemy
    , battles : Maybe (List Battle)
    , time_state : TimeState -- paused or not
    , game_state : GameState
    , events : Events
    , time_speed : Float
    , previous_position : List Offset
    , sounds : List Sound
    , sub_model : Sub_model
    }

{-| Definition of Sub_model-}
type alias Sub_model =
    { report : Maybe (List Report)
    , report_showing : Maybe Report
    , passed_level : Int
    , time : Float
    }

{-| Definition of Play_state-}
type Play_state
    -- player status movement
    = Player_move
    | Enemy_move
    | Report -- after this round
    | StandBy
    | Pause

{-| The initialization of Model -}
initModel : Model
initModel =
    let
        player =
            Player.init 0

        map =
            Map.init 0 ( 20, 30 )

        enemy =
            Enemy.init 0 map player

        sub_model =
            Sub_model Nothing Nothing 0 0
    in
    Model Player_move player map enemy Nothing Normal Logo_Intro Events.init 1.0 [] [] sub_model

{-| The initialization of levels-}
init_level : Int -> Model -> Model
init_level level model =
    let
        map =
            if level == 6 then
                model.map

            else
                Map.init level ( 20, 30 )

        player =
            Player.init level

        enemy =
            Enemy.init level map player

        sub_model =
            Sub_model Nothing Nothing 0 0

        -- init_position = List.map (\x -> x.offset) player.army
    in
    Model Player_move player map enemy Nothing Normal (Level level) Events.init 1.0 [] [] sub_model

{-| Change the game_state of the Model and then turn the game_state from levels to turn page reports-}
change_game_state : Model -> GameState -> Model
change_game_state model n_game_state =
    let
        passed_level =
            model.sub_model.passed_level
    in
    case n_game_state of
        Level n ->
            init_level n model

        {-
           if n == passed_level + 1 then
               --{ model | game_state = n_game_state }
               init_level n model

           else
               model
        -}
        Help Operation ->
            if model.game_state == Level 1 || model.game_state == Level 2 || model.game_state == Level 3 then
                { model | game_state = n_game_state, time_state = Paused }

            else
                { model | game_state = n_game_state }

        _ ->
            { model | game_state = n_game_state }



-- to be finished
