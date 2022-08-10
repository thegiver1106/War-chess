module Update exposing (update, press_map)
--update
import AStar exposing (get_shortest_path)
import Array
import Battle exposing (Battle, Battle_state(..), check_battle_valid, div_result_update, error_battle, filter_battle_div_details, init_battle, judge_battle_already_exist, update_battle, update_enemy_div, update_player_div)
import Block exposing (Block, block_in_cur_screen, error_block)
import Browser.Dom exposing (Viewport, getViewport)
import Div exposing (..)
import Enemy exposing (Enemy, update)
import Events
import General exposing (..)
import Html exposing (th)
import Html.Attributes exposing (list)
import Map exposing (Map, offset_to_block)
import Maybe exposing (withDefault)
import Model exposing (Model, Play_state(..))
import Msg exposing (Msg(..))
import Player exposing (Player)
import Report exposing (report_battles, update_report_showing)
import Sound
import Svg.Attributes exposing (..)
import Task
import Turn_page exposing (turn_lose_page, turn_win_page)



--maybe just let Div, Grid/Map be parallel, and import them here?
-- type Fight
--     = No --will just move
--     | Engage
--     | Attack
--     | Defense
-- check_fight :
--     Div
--     -> Div
--     -> Map
--     -> Fight --check whether a fight will happen
-- check_fight div1 div2 map =
--     No
-- move_fight :
--     Fight
--     -> Div
--     -> Div
--     -> Map
--     -> ( Div, Div ) --change the Div's position & hp
-- move_fight fight div1 div2 map =
--     (div1, div2)

{-| Update function for the whole program, dealing with all the messages-}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        map =
            model.map

        nstate =
            change_turns model

        msg_t =
            case model.game_state of
                Level _ ->
                    case msg of
                        Tick elapsed ->
                            Tick (elapsed * 0.1 * model.time_speed)

                        _ ->
                            msg

                _ ->
                    msg

        -- take time speed into consideration
        nmap =
            Map.update msg_t model.map

        nplayer =
            Player.update msg_t model.events map model.player model.enemy.army

        n_events =
            Events.update msg model.events

        nenemy =
            let
                nnenemy =
                    case model.game_state of
                        Level a ->
                            Enemy.make_move model.player model.enemy

                        _ ->
                            model.enemy
            in
            Enemy.update msg_t nnenemy model.player model.player.army

        --a = 1
    in
    if model.game_state == Help Story || model.game_state == Help Division_info || model.game_state == Help Battle_info || model.game_state == Help Operation then
        case msg of
            Helpmsg Back_to_game ->
                case model.time_state of
                    Paused ->
                        ( { model | game_state = Level (model.sub_model.passed_level + 1), time_state = Normal }, Cmd.none )

                    _ ->
                        ( { model | game_state = LevelChoosing }, Cmd.none )

            {- Helpmsg Story ->
               ( { model | game_state = Help (a, Story) }, Cmd.none )
            -}
            Helpmsg Story ->
                ( { model | game_state = Help Story }, Cmd.none )

            Helpmsg Division_info ->
                ( { model | game_state = Help Division_info }, Cmd.none )

            Helpmsg Battle_info ->
                ( { model | game_state = Help Battle_info }, Cmd.none )

            Helpmsg Operation ->
                ( { model | game_state = Help Operation }, Cmd.none )

            _ ->
                ( model, Cmd.none )

    else
        case msg_t of
            Tick elapsed ->
                case model.time_state of
                    Paused ->
                        ( { model | map = nmap }, Cmd.none )

                    -- zoom in and zoom out is still allowed
                    Normal ->
                        if model.game_state == Level 5 then
                            ( model, Cmd.none )

                        else
                            let
                                sub_model =
                                    model.sub_model
                            in
                            ( { model | sub_model = { sub_model | time = sub_model.time + elapsed }, map = nmap, player = nplayer, enemy = nenemy, play_state = nstate, events = n_events }, Cmd.none )
                                |> update_divisions_moving
                                |> check_fight
                                -- initialize battle
                                |> update_divs_battles
                                -- update all divs to certain battle
                                |> filter_battles
                                --filter valid battles according to divs
                                |> execute_battle
                                --fight
                                |> generate_report
                                --generate battle report after battle
                                |> update_report
                                -- update report according to time
                                |> update_model_div
                                -- --update battles' divisions' information to model
                                |> filter_battle_div
                                -- filter div with hp>0, if not, turn to Nothing
                                |> filter_battles
                                --filter valid battles according to divs
                                |> filter_divisions
                                --check change in stage
                                |> next_stage
                                --add finished construction to the map
                                |> add_construction
                                |> update_sight
                                |> check_win_loss

            -- filter division in model with hp>0
            Next_page ->
                --next page in turn pages
                case model.game_state of
                    Win_turn_page n p ->
                        let
                            new_state =
                                turn_win_page n p

                            sub_model =
                                model.sub_model
                        in
                        ( { model | game_state = new_state, sub_model = { sub_model | time = 0 } }, Cmd.none )

                    Lose_turn_page n p ->
                        let
                            new_state =
                                turn_lose_page n p

                            sub_model =
                                model.sub_model
                        in
                        ( { model | game_state = new_state, sub_model = { sub_model | time = 0 } }, Cmd.none )

                    Beginning_page ->
                        ( { model | game_state = GameStateChoosing }, Cmd.none )

                    _ ->
                        ( model, Cmd.none )

            Destination _ ->
                let
                    state =
                        if model.player.division_picked > 0 then
                            Player_move

                        else
                            model.play_state

                    seleceted_div_ls =
                        List.filter (\x -> x.number == model.player.division_picked) model.player.army

                    seleceted_div =
                        case List.head seleceted_div_ls of
                            Nothing ->
                                error_div

                            Just a ->
                                a

                    n_sounds =
                        Sound.update msg model.sounds seleceted_div
                in
                ( { model | player = nplayer, play_state = state, sounds = n_sounds }, Cmd.none )

            Division n ->
                pick_division msg model

            Cancel n ->
                pick_division msg model

            Commander1 ->
                pick_division msg model

            Eventmsg _ ->
                ( { model | events = n_events }, Cmd.none )

            AssignCommander tuple ->
                pick_division (AssignCommander tuple) model

            --({ model | map = nmap }, Cmd.none)
            MouseOverBlock _ ->
                ( { model | map = nmap }, Cmd.none )

            MouseOutBlock _ ->
                ( { model | map = nmap }, Cmd.none )

            MoveScreen _ ->
                ( { model | map = nmap }, Cmd.none )

            Zoom _ ->
                ( { model | map = nmap }, Cmd.none )

            ChangeGameState game_state ->
                case model.game_state of
                    Level n ->
                        case game_state of
                            Help Operation ->
                                ( Model.change_game_state model game_state, Task.perform GetViewport getViewport )

                            _ ->
                                ( Model.change_game_state model game_state, Task.perform GetViewport getViewport )

                    _ ->
                        ( Model.change_game_state model game_state, Task.perform GetViewport getViewport )

            Conscript _ ->
                ( { model | player = nplayer }, Cmd.none )

            ChangePlayingState ->
                let
                    n_time_state =
                        case model.time_state of
                            Paused ->
                                Normal

                            Normal ->
                                Paused
                in
                ( { model | time_state = n_time_state }, Cmd.none )

            Activate _ ->
                ( { model | events = n_events }, Cmd.none )

            GetViewport viewport ->
                ( { model | map = nmap }, Cmd.none )

            ConstructionMsg _ ->
                ( { model | player = nplayer }, Cmd.none )

            BlockChangeMsg _ ->
                if model.game_state == Level 5 then
                    ( { model | map = nmap }, Cmd.none )

                else
                    ( model, Cmd.none )

            OutputMap ->
                if model.game_state == Level 5 then
                    ( model, Map.save_str (Map.map_to_string model.map) )

                else
                    ( model, Cmd.none )

            Win_level_1 ->
                ( { model | game_state = Win_turn_page 1 1 }, Cmd.none )

            Lose_level_2 ->
                ( { model | game_state = Lose_turn_page 1 1 }, Cmd.none )

            TimeSpeedChangeMsg time_speed_change ->
                let
                    time_speed =
                        model.time_speed

                    n_time_speed =
                        case time_speed_change of
                            Msg.Increasement ->
                                Basics.min 5 (time_speed + 1)

                            Msg.Decreasement ->
                                Basics.max 1 (time_speed - 1)

                    n_time_state =
                        if n_time_speed == 0 then
                            Paused

                        else
                            model.time_state
                in
                ( { model | time_speed = n_time_speed, time_state = n_time_state }, Cmd.none )

            _ ->
                ( model, Cmd.none )


update_divisions_moving : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
update_divisions_moving ( model, cmd ) =
    let
        player =
            model.player

        enemy =
            model.enemy

        player_army =
            model.player.army

        enemy_army =
            model.enemy.army

        new_player_army =
            judge_moving player_army

        new_enemy_army =
            judge_moving enemy_army
    in
    ( { model | player = { player | army = new_player_army }, enemy = { enemy | army = new_enemy_army } }, Cmd.none )


judge_moving : List Div -> List Div
judge_moving list =
    List.map (\x -> update_moving_state x) list


update_moving_state : Div -> Div
update_moving_state div =
    let
        judge =
            div.judge
    in
    if ((div.route |> List.reverse |> List.head |> Maybe.withDefault ( -1, -1 )) /= ( -1, -1 )) && ((div.route |> List.reverse |> List.head |> Maybe.withDefault ( -1, -1 )) /= div.offset) then
        { div | judge = { judge | moving = True } }

    else
        { div | judge = { judge | moving = False } }


check_win_loss : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
check_win_loss ( model, cmd ) =
    case model.game_state of
        Level n ->
            let
                enemy_army =
                    model.enemy.army

                player_army =
                    model.player.army

                player_base =
                    model.player.base.offset

                enemy_base =
                    model.enemy.base_camp

                player_at_base =
                    List.filter (\x -> List.member x.offset enemy_base) player_army

                enemy_at_base =
                    List.filter (\x -> x.offset == player_base) enemy_army

                sub_model =
                    model.sub_model
            in
            if List.length player_at_base /= 0 then
                ( { model | game_state = Win_turn_page n 1, sub_model = { sub_model | passed_level = sub_model.passed_level + 1 } }, cmd )

            else if List.length enemy_at_base /= 0 then
                ( { model | game_state = Lose_turn_page n 1 }, cmd )

            else
                ( model, cmd )

        _ ->
            ( model, cmd )


generate_report : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
generate_report ( model, cmd ) =
    case model.battles of
        Nothing ->
            ( model, cmd )

        Just bats ->
            let
                reports =
                    report_battles bats

                --newly generated reports
                new_reports =
                    case model.sub_model.report of
                        Nothing ->
                            reports

                        Just remained_reports ->
                            case reports of
                                Nothing ->
                                    Just remained_reports

                                Just list ->
                                    Just (List.append remained_reports list)

                ( show_report, new_report_without_showing ) =
                    update_report_showing model.sub_model.report_showing new_reports

                sub_model =
                    model.sub_model
            in
            ( { model | sub_model = { sub_model | report = new_report_without_showing, report_showing = show_report } }, cmd )


update_report : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
update_report ( model, cmd ) =
    let
        sub_model =
            model.sub_model
    in
    case model.sub_model.report_showing of
        Nothing ->
            ( model, cmd )

        Just report ->
            if report.show_time <= 8 then
                ( { model | sub_model = { sub_model | report_showing = Just { report | show_time = report.show_time + 0.3 * model.time_speed } } }, cmd )

            else
                case model.sub_model.report of
                    Nothing ->
                        ( { model | sub_model = { sub_model | report_showing = Nothing } }, cmd )

                    Just remained_reports ->
                        let
                            picked_one =
                                List.head remained_reports

                            report_remained =
                                if (List.drop 1 remained_reports |> List.length) == 0 then
                                    Nothing

                                else
                                    Just (List.drop 1 remained_reports)
                        in
                        ( { model | sub_model = { sub_model | report_showing = picked_one, report = report_remained } }, cmd )


update_model_div : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
update_model_div ( model, cmd ) =
    let
        battles =
            model.battles

        player =
            model.player

        enemy =
            model.enemy

        player_army =
            model.player.army

        enemy_army =
            model.enemy.army

        new_player_army =
            div_result_update 1 battles player_army

        new_enemy_army =
            div_result_update 2 battles enemy_army
    in
    ( { model | player = { player | army = new_player_army }, enemy = { enemy | army = new_enemy_army } }, cmd )


filter_divisions : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
filter_divisions ( model, cmd ) =
    let
        new_player_div =
            List.filter (\x -> x.hp > 0) model.player.army

        new_enemy_div =
            List.filter (\x -> x.hp > 0) model.enemy.army

        player =
            model.player

        enemy =
            model.enemy
    in
    ( { model | player = { player | army = new_player_div }, enemy = { enemy | army = new_enemy_div } }, cmd )


filter_battle_div : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
filter_battle_div ( model, cmd ) =
    case model.battles of
        Nothing ->
            ( model, cmd )

        Just battles ->
            let
                new_battles =
                    filter_battle_div_details battles
            in
            ( { model | battles = Just new_battles }, cmd )


filter_battles : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
filter_battles ( model, cmd ) =
    let
        battles_after_filter =
            case model.battles of
                Nothing ->
                    []

                Just battles ->
                    List.filter (\x -> check_battle_valid x == True) battles

        new_battles =
            if List.length battles_after_filter == 0 then
                Nothing

            else
                Just battles_after_filter
    in
    ( { model | battles = new_battles }, cmd )


execute_battle : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
execute_battle ( model, cmd ) =
    let
        battles =
            case model.battles of
                Nothing ->
                    Nothing

                Just bat ->
                    Just (List.map (\x -> update_battle x model.time_speed) bat)
    in
    ( { model | battles = battles }, cmd )


update_divs_battles : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
update_divs_battles ( model, cmd ) =
    let
        player_army =
            model.player.army

        enemy_army =
            model.enemy.army

        old_battles =
            model.battles

        new_battles =
            case old_battles of
                Nothing ->
                    Nothing

                Just old_battle ->
                    Just
                        (old_battle
                            |> List.map (\x -> { x | enemy_div = Nothing })
                            |> List.map (\x -> { x | player_div = Nothing })
                            |> update_player_div player_army
                            |> update_enemy_div enemy_army
                        )
    in
    ( { model | battles = new_battles }, cmd )


check_fight : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
check_fight ( model, cmd ) =
    let
        map =
            press_map model.map.blocks
                |> Array.toList

        player_army =
            model.player.army

        enemy_army =
            model.enemy.army

        positions =
            check_position_fight player_army enemy_army

        positions_after_filter =
            filter_positions positions

        battles =
            add_battles player_army enemy_army positions_after_filter model

        new_battles =
            if List.length battles == 0 then
                Nothing

            else
                Just battles

        --following are for sound effect
        origin_battles =
            case model.battles of
                Nothing ->
                    []

                Just a ->
                    a

        is_in_origin =
            \x -> List.length (List.filter (\t -> t.position == x.position) origin_battles) > 0

        newly_happened_battles =
            List.filter (\x -> is_in_origin x == False) battles

        n_sounds =
            Sound.update_battle_sounds model.sounds newly_happened_battles
    in
    ( { model | battles = new_battles, sounds = n_sounds }, cmd )


add_battles : List Div -> List Div -> List Offset -> Model -> List Battle
add_battles player_army enemy_army positions model =
    if List.length positions == 0 then
        []

    else
        let
            picked_position =
                List.head positions |> Maybe.withDefault ( 0, 0 )

            player_div =
                List.filter (\x -> x.offset == picked_position) player_army

            enemy_div =
                List.filter (\x -> x.offset == picked_position) enemy_army

            remained_positions =
                List.drop 1 positions

            block =
                offset_to_block model.map picked_position

            terrain =
                block.terrain
        in
        List.append [ init_battle picked_position terrain model.sub_model.time ( player_div, enemy_div ) ] (add_battles player_army enemy_army remained_positions model)


filter_positions : List Offset -> List Offset
filter_positions list =
    if List.length list == 1 then
        [ List.head list |> Maybe.withDefault ( 0, 0 ) ]

    else if List.length list == 0 then
        []

    else
        let
            picked_one =
                List.head list |> Maybe.withDefault ( 0, 0 )

            remained_list =
                List.filter (\x -> x /= picked_one) list
        in
        List.append [ picked_one ] (filter_positions remained_list)


check_position_fight : List Div -> List Div -> List Offset
check_position_fight list_player list_enemy =
    if List.length list_player == 0 then
        []

    else
        let
            pick_div =
                List.head list_player |> Maybe.withDefault error_div

            divs =
                List.filter (\x -> x.offset == pick_div.offset) list_enemy

            remained_army =
                List.drop 1 list_player
        in
        if List.length divs == 0 then
            List.append [] (check_position_fight remained_army list_enemy)

        else
            List.append [ pick_div.offset ] (check_position_fight remained_army list_enemy)



-- add_battle : List Block -> Model -> Model
-- add_battle map model =
--     let
--         picked_block =
--             List.head map |> Maybe.withDefault error_block
--         next_map =
--             List.drop 1 map
--         bool =
--             judge_battle_already_exist picked_block.offset model.battles
--     in
--     if bool == False then
--         case List.length map of
--             0 ->
--                 model
--             _ ->
--                 examine_battle model picked_block |> add_battle next_map
--     else
--         add_battle next_map model
-- examine_battle : Model -> Block -> Model
-- examine_battle model block =
--     let
--         player_army =
--             model.player.army
--         enemy_army =
--             model.enemy.army
--         pos =
--             block.offset
--         terrain =
--             block.terrain
--         player_army_within =
--             List.filter (\x -> x.offset == pos) player_army
--         enemy_army_within =
--             List.filter (\x -> x.offset == pos) enemy_army
--     in
--     if (List.length player_army_within /= 0) && (List.length enemy_army_within /= 0) then
--         let
--             new_battle =
--                 init_battle pos terrain model.time ( player_army_within, enemy_army_within )
--         in
--         case model.battles of
--             Nothing ->
--                 { model | battles = Just [ new_battle ] }
--             Just battles ->
--                 { model | battles = Just (List.append battles [ new_battle ]) }
--     else
--         model

{-| Change the map's blocks from Array(Array) into Array-}
press_map : Array.Array (Array.Array Block) -> Array.Array Block
press_map map =
    let
        map_to_list =
            Array.toList map

        first =
            List.head map_to_list

        last =
            Array.fromList (List.drop 1 map_to_list)
    in
    if first == Nothing then
        Array.empty

    else
        Array.append (fk_maybe first) (press_map last)


fk_maybe : Maybe (Array.Array Block) -> Array.Array Block
fk_maybe first =
    case first of
        Nothing ->
            Array.empty

        Just array ->
            array


pick_division : Msg -> Model -> ( Model, Cmd Msg )
pick_division msg model =
    let
        player =
            model.player

        n_army =
            List.map (Div.update msg model.map model.enemy.army) model.player.army

        n =
            case msg of
                Division d ->
                    d

                Commander1 ->
                    model.player.division_picked

                AssignCommander tuple ->
                    model.player.division_picked

                _ ->
                    -1
    in
    ( { model | player = { player | division_picked = n, army = n_army } }, Cmd.none )



-- function that changes turns (round function)


change_turns : Model -> Play_state
change_turns model =
    let
        change =
            if model.play_state == Player_move then
                List.all (\{ route } -> route == []) model.player.army

            else if model.play_state == Enemy_move then
                True

            else
                False
    in
    if change then
        case model.play_state of
            Player_move ->
                Model.Enemy_move

            Enemy_move ->
                Model.StandBy

            _ ->
                Model.Player_move

    else
        model.play_state


next_stage : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
next_stage ( model, cmd ) =
    let
        sub_model = model.sub_model
    in
    
    case model.game_state of
        Logo_Intro ->
            if model.sub_model.time >= time_logo_sequence then
                ( { model | game_state = Beginning_page, sub_model = { sub_model | time = 0 }}, cmd )

            else
                ( model, cmd )

        Beginning_page ->
            if model.sub_model.time >= time_beginning_page then
                ( { model | game_state = LevelChoosing, sub_model = {sub_model | time = 0 }}, cmd )

            else
                ( model, cmd )

        _ ->
            ( model, cmd )



-- transition number 11 (init_menu), 10 (endgame), 12 (init_logo)
{-
   transition_next : (Int, Int) -> Gamestage
   transition_next transition =
       case transition of
           (0, 1) -> Play_level 1
           (1, 2) -> Play_level 2
           (2, 3) -> Play_level 3
           (_, 10) -> Endgame
           _ -> Init_Menu
-}


update_sight :
    ( Model, Cmd Msg )
    -> ( Model, Cmd Msg ) --function that updates sight restriction
update_sight ( model, msg ) =
    let
        player_elem =
            Player.get_player_elem model.player

        ( new_map, new_position ) =
            if check_both_sides_movement model.previous_position model.player.army then
                ( model.map, model.previous_position )

            else
                ( Map.map_update_sight model.map player_elem, List.map (\x -> x.offset) model.player.army )
    in
    ( { model | map = new_map, previous_position = new_position }, msg )


add_construction : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
add_construction ( model, cmd ) =
    let
        cons_state_ls =
            List.map (\x -> x.cons_progress) model.player.army

        finished_ls =
            List.filter
                (\x ->
                    case x.cons_progress of
                        Unoccupied ->
                            False

                        Building _ ->
                            False

                        Finished _ ->
                            True
                )
                model.player.army

        finished_cons_ls =
            List.map
                (\x ->
                    case x.cons_progress of
                        Unoccupied ->
                            Barricades

                        --won't happen
                        Building _ ->
                            Barricades

                        --won't happen
                        Finished cons ->
                            cons
                )
                finished_ls

        finished_offset_ls =
            List.map (\x -> x.offset) finished_ls

        zipped_ls =
            List.map2 Tuple.pair finished_cons_ls finished_offset_ls

        map =
            model.map

        n_map =
            List.foldl Map.build_on_map map zipped_ls

        n_model =
            { model | map = n_map }
    in
    ( n_model, cmd )


check_both_sides_movement : List Offset -> List Div -> Bool
check_both_sides_movement list_offset list_div_player =
    list_offset == List.map (\x -> x.offset) list_div_player
