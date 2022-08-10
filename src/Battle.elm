module Battle exposing (Battle, Battle_state(..), Fight(..), Side(..), battle_result, check_battle_valid, div_result_update, error_battle, filter_battle_div_details, init_battle, judge_battle_already_exist, update_battle, update_enemy_div, update_player_div)

-- init_battle when two divisions encounter. do update_battle, update_enemy_div, update_player_div every tick
-- update_battle : Battle -> Battle
-- init_battle : Offset -> Terrain -> Float -> ( Div, Div ) -> Battle
-- update_player_div : List Div -> List Battle -> List Battle
-- update_enemy_div : List Div -> List Battle -> List Battle

import Div exposing (Div, error_div)
import General exposing (..)
import Json.Decode exposing (maybe)
import Msg exposing (Msg(..))
import Random

{-| Definition of battle-}
type alias Battle =
    { fight_type_player : Fight --player's division's fight type
    , fight_type_enemy : Fight
    , position : Offset
    , player_div : Maybe (List Div)
    , enemy_div : Maybe (List Div)
    , terrain : Terrain
    , time_battle : Int -- this time is for the inteval between battles, 0 when the battle is initialized
    , time_seed : Int -- this time is for the Random seed, its initial value is from Model.time
    , seed : Random.Seed
    , battle_state : Battle_state --to judge whether the battle is finished
    , report_battle : Bool
    , winner : Side
    }

{-| Definition of both sides participating in the battle-}
type Side
    = Player
    | Enemy
    | Unknown

{-| Definition of different type of battles-}
type Fight
    = Offense
    | Defense
    | Encounter
    | Balanced --never happpen

{-| Judgement of whether a battle has finished-}
type Battle_state
    = Valid
    | Stop

{-| Give a default value of battle that is not happening-}
error_battle =
    Battle Balanced Balanced ( 0, 0 ) Nothing Nothing Plain 0 0 (Random.initialSeed 0) Stop False Unknown

{-| Judge whether the player's divisions will fight a battle-}
update_player_div : List Div -> List Battle -> List Battle
update_player_div army battles =
    if List.length army == 0 then
        battles

    else
        let
            new_battle =
                List.head army
                    |> Maybe.withDefault error_div
                    |> update_div battles 1
        in
        update_player_div (List.drop 1 army) new_battle

{-| Judge whether the enemy's divisions will fight a battle-}
update_enemy_div : List Div -> List Battle -> List Battle
update_enemy_div army battles =
    if List.length army == 0 then
        battles

    else
        let
            new_battle =
                List.head army
                    |> Maybe.withDefault error_div
                    |> update_div battles 2
        in
        update_enemy_div (List.drop 1 army) new_battle

update_div : List Battle -> Int -> Div -> List Battle
update_div battles n div =
    battles
        -- |> List.map (\x -> { x | player_div = Nothing })
        -- |> List.map (\x -> { x | enemy_div = Nothing })
        |> List.map (\x -> update_battle_div div n x)



-- reset all divisions and then add distribute them to battles according to their positions


update_battle_div : Div -> Int -> Battle -> Battle
update_battle_div div n battle =
    if div.offset == battle.position && n == 1 then
        case battle.player_div of
            Nothing ->
                { battle | player_div = Just [ div ] }

            Just army ->
                { battle | player_div = Just (List.append army [ div ]) }

    else if div.offset == battle.position && n == 2 then
        case battle.enemy_div of
            Nothing ->
                { battle | enemy_div = Just [ div ] }

            Just army ->
                { battle | enemy_div = Just (List.append army [ div ]) }

    else
        battle



-- the fight type is determined by the first encounter

{-| The initialization of a new battle, including the type of the battle, the divisions it involves, and the damage the first battle causes to both sides' divisions-}
init_battle : Offset -> Terrain -> Float -> ( List Div, List Div ) -> Battle
init_battle pos terrain time ( div_player, div_enemy ) =
    let
        player_first =
            List.head div_player |> Maybe.withDefault error_div

        enemy_first =
            List.head div_enemy |> Maybe.withDefault error_div
    in
    Battle (judge_fight_type player_first enemy_first) (judge_fight_type enemy_first player_first) pos (Just div_player) (Just div_enemy) terrain 0 (floor time) (Random.initialSeed 10) Valid False Unknown

{-| Calculate the damages of a happening battle causes to both sides' divisions, and update the battle details like the battle type, the involving divisions and so on-}
update_battle : Battle -> Float -> Battle
update_battle battle time =
    battle
        |> update_seed
        |> update_fight time
        -- battle when time is up
        |> update_battle_time
        |> update_battle_state



-- judge whether the battle continues


update_seed : Battle -> Battle
update_seed battle =
    let
        seed_new =
            Random.initialSeed battle.time_seed
    in
    { battle | seed = seed_new }


update_battle_state : Battle -> Battle
update_battle_state battle =
    if (battle.player_div == Nothing) || (battle.enemy_div == Nothing) then
        { battle | battle_state = Stop }

    else
        battle


update_fight : Float -> Battle -> Battle
update_fight time_speed battle =
    case modBy (floor (1800 / time_speed)) battle.time_battle of
        0 ->
            { battle | report_battle = True } |> time_for_battle

        -- 80 ->
        --     { battle | report_battle = False, winner = Unknown }
        --leave time for report (TBD) then reset
        _ ->
            { battle | report_battle = False, winner = Unknown }


time_for_battle : Battle -> Battle
time_for_battle battle =
    case ( battle.player_div, battle.enemy_div ) of
        ( Just list_player, Just list_enemy ) ->
            let
                ( new_player_div, new_enemy_div, winner ) =
                    battle_result list_player list_enemy battle.terrain battle.fight_type_player battle.fight_type_enemy battle.seed
            in
            { battle | player_div = new_player_div, enemy_div = new_enemy_div, winner = show_winner winner }

        _ ->
            battle


show_winner : Int -> Side
show_winner int =
    case int of
        1 ->
            Player

        2 ->
            Enemy

        _ ->
            Unknown

{-| Calculate th battle result, including the damages, the winner of the battle, and the divisions' states after the battle-}
battle_result : List Div -> List Div -> Terrain -> Fight -> Fight -> Random.Seed -> ( Maybe (List Div), Maybe (List Div), Int )
battle_result list_player list_enemy terrain fight_type_player fight_type_enemy seed =
    let
        player_weight =
            List.map (\x -> calculate_power x fight_type_player terrain) list_player |> List.foldl (+) 0

        enemy_weight =
            List.map (\x -> calculate_power x fight_type_enemy terrain) list_enemy |> List.foldl (+) 0

        winner =
            win_judge player_weight enemy_weight seed
    in
    case winner of
        1 ->
            if player_weight > 3.0 * enemy_weight then
                ( Just (suffer_loss_winner player_weight enemy_weight list_player), Just (List.map (\x -> turn_hp_0 x) list_enemy), winner )

            else
                ( Just (suffer_loss_winner player_weight enemy_weight list_player), suffer_loss_loser enemy_weight player_weight list_enemy, winner )

        2 ->
            if 3.0 * player_weight < enemy_weight then
                ( Just (List.map (\x -> turn_hp_0 x) list_player), Just (suffer_loss_winner enemy_weight player_weight list_enemy), winner )

            else
                ( suffer_loss_loser player_weight enemy_weight list_player, Just (suffer_loss_winner enemy_weight player_weight list_enemy), winner )

        _ ->
            ( Nothing, Nothing, 0 )


turn_hp_0 : Div -> Div
turn_hp_0 div =
    { div | hp = 0 }



--never happen


suffer_loss_loser : Float -> Float -> List Div -> Maybe (List Div)
suffer_loss_loser loser_weight winner_weight list =
    let
        list_after_suffer =
            List.map (\x -> loser_lost x loser_weight winner_weight) list

        --list_after_filter =
        --  List.filter (\x -> x.hp > 0) list_after_suffer
    in
    case List.length list_after_suffer of
        0 ->
            Nothing

        _ ->
            Just list_after_suffer


loser_lost : Div -> Float -> Float -> Div
loser_lost div lw ww =
    let
        hp =
            toFloat div.hp - abs (ww - lw) * 5

        n_exp =
            div.judge.exp - 2

        judge =
            div.judge

        --TBD
    in
    { div | hp = floor hp, judge = { judge | exp = n_exp } }


suffer_loss_winner : Float -> Float -> List Div -> List Div
suffer_loss_winner winner_weight loser_weight list =
    if winner_weight >= loser_weight then
        List.map (\x -> winner_loss_1 x winner_weight loser_weight) list

    else
        List.map (\x -> winner_loss_2 x winner_weight loser_weight) list


winner_loss_1 : Div -> Float -> Float -> Div
winner_loss_1 div ww lw =
    let
        hp =
            toFloat div.hp * (ww - lw * 0.2) / ww

        n_exp =
            div.judge.exp + 5

        judge =
            div.judge

        --TBD
    in
    { div | hp = floor hp, judge = { judge | exp = n_exp } }


winner_loss_2 : Div -> Float -> Float -> Div
winner_loss_2 div ww lw =
    let
        hp =
            toFloat div.hp * (lw - ww * 0.25) / lw

        n_exp =
            div.judge.exp + 20

        judge =
            div.judge
    in
    { div | hp = floor hp, judge = { judge | exp = n_exp } }


update_battle_time : Battle -> Battle
update_battle_time battle =
    { battle | time_battle = battle.time_battle + 1, time_seed = battle.time_seed + 1 }


judge_fight_type : Div -> Div -> Fight
judge_fight_type div_1 div_2 =
    let
        tuple =
            ( div_1.judge.moving, div_2.judge.moving )
    in
    case tuple of
        ( True, True ) ->
            Encounter

        ( True, False ) ->
            Offense

        ( False, True ) ->
            Defense

        ( False, False ) ->
            Balanced



--if gap is too large, no need for Random number


win_judge : Float -> Float -> Random.Seed -> Int
win_judge w1 w2 seed =
    if w1 > 3 * w2 then
        1

    else if w2 > 3 * w1 then
        2

    else
        let
            tuple =
                Random.step (Random.weighted ( w1, 1 ) [ ( w2, 2 ) ]) seed
        in
        Tuple.first tuple


calculate_terrain_class : Float -> ( Terrain, Class ) -> Float
calculate_terrain_class hp ( terrain, class ) =
    case ( terrain, class ) of
        ( Mountain, Grenadier ) ->
            0

        ( Mountain, Engineer ) ->
            0

        ( Mountain, Guard ) ->
            5 * hp / 1000

        ( Forest, Grenadier ) ->
            0

        _ ->
            hp / 1000


calculate_nation_class : Float -> ( Nation, Class ) -> Float
calculate_nation_class hp ( nation, class ) =
    case ( nation, class ) of
        ( France, Fast ) ->
            3 * hp / 1000

        ( Britain, Guard ) ->
            3 * hp / 1000

        ( Austria, Engineer ) ->
            3 * hp / 1000

        ( Russia, Grenadier ) ->
            3 * hp / 1000

        _ ->
            hp / 1000


calculate_fight_class : Float -> ( Fight, Class ) -> Float
calculate_fight_class hp ( fight_type, class ) =
    case ( fight_type, class ) of
        ( Defense, Fast ) ->
            0

        ( Defense, Guard ) ->
            6 * hp / 1000

        ( Encounter, Guard ) ->
            0

        ( Offense, Guard ) ->
            0

        ( Defense, Engineer ) ->
            6 * hp / 1000

        ( Offense, Engineer ) ->
            6 * hp / 1000

        ( Offense, Grenadier ) ->
            9 * hp / 1000

        _ ->
            hp / 1000



--calculate battle power for each division in the field


calculate_power : Div -> Fight -> Terrain -> Float
calculate_power div fight_type terrain =
    let
        hp =
            toFloat div.hp

        hp_weight =
            hp / 100

        terrain_class =
            calculate_terrain_class hp ( terrain, div.class )

        nation_class =
            calculate_nation_class hp ( div.nation, div.class )

        fight_class =
            calculate_fight_class hp ( fight_type, div.class )
    in
    hp_weight + terrain_class + nation_class + nation_class + fight_class

{-| Judge whether a battle has already been fighting-}
judge_battle_already_exist : Offset -> Maybe (List Battle) -> Bool
judge_battle_already_exist pos battles =
    case battles of
        Nothing ->
            False

        Just battle ->
            if List.length battle == 0 then
                False

            else
                let
                    picked_battle =
                        List.head battle |> Maybe.withDefault error_battle

                    remained_battles =
                        List.drop 1 battle
                in
                if picked_battle.position == pos then
                    True

                else
                    judge_battle_already_exist pos (Just remained_battles)

{-| Determine whether the battle is still fighting-}
check_battle_valid : Battle -> Bool
check_battle_valid battle =
    let
        enemy =
            battle.enemy_div

        player =
            battle.player_div
    in
    if enemy == Nothing || player == Nothing then
        False

    else
        True

{-| Give out the divisions' situations after a round of battles-}
div_result_update : Int -> Maybe (List Battle) -> List Div -> List Div
div_result_update n battles list =
    case battles of
        Nothing ->
            list

        Just battle ->
            update_div_details n battle list


update_div_details : Int -> List Battle -> List Div -> List Div
update_div_details n battles list =
    case List.length battles of
        0 ->
            list

        _ ->
            let
                picked_battle =
                    List.head battles |> Maybe.withDefault error_battle

                remained_battles =
                    List.drop 1 battles
            in
            update_div_details_2 n picked_battle list |> update_div_details n remained_battles


update_div_details_2 : Int -> Battle -> List Div -> List Div
update_div_details_2 n bat list =
    let
        army_length =
            if n == 1 then
                case bat.player_div of
                    Nothing ->
                        10000

                    -- impossible
                    Just army ->
                        List.length army

            else
                case bat.enemy_div of
                    Nothing ->
                        10000

                    -- impossible
                    Just army ->
                        List.length army
    in
    if army_length == 0 then
        list

    else
        let
            the_army =
                if n == 1 then
                    case bat.player_div of
                        Nothing ->
                            []

                        Just army ->
                            army

                else
                    case bat.enemy_div of
                        Nothing ->
                            []

                        Just army ->
                            army

            picked_div =
                List.head the_army |> Maybe.withDefault error_div

            remained_div =
                List.drop 1 the_army

            new_bat =
                if n == 1 then
                    { bat | player_div = Just remained_div }

                else
                    { bat | enemy_div = Just remained_div }
        in
        List.map (\x -> update_div_details_3 x picked_div) list |> update_div_details_2 n new_bat


update_div_details_3 : Div -> Div -> Div
update_div_details_3 model_div battle_div =
    let
        judge =
            battle_div.judge
    in
    if model_div.number == battle_div.number then
        { model_div | hp = battle_div.hp, judge = { judge | exp = battle_div.judge.exp } }

    else
        model_div


update_battle_div_details_2 : Battle -> Battle
update_battle_div_details_2 battle =
    let
        new_player_army =
            case battle.player_div of
                Nothing ->
                    Nothing

                Just player_army ->
                    let
                        valid_length =
                            List.filter (\x -> x.hp > 0) player_army |> List.length
                    in
                    if valid_length == 0 then
                        Nothing

                    else
                        Just (List.filter (\x -> x.hp > 0) player_army)

        new_enemy_army =
            case battle.enemy_div of
                Nothing ->
                    Nothing

                Just enemy_army ->
                    let
                        valid_length =
                            List.filter (\x -> x.hp > 0) enemy_army |> List.length
                    in
                    if valid_length == 0 then
                        Nothing

                    else
                        Just (List.filter (\x -> x.hp > 0) enemy_army)
    in
    { battle | player_div = new_player_army, enemy_div = new_enemy_army }

{-| filter those battles that have been ended-}
filter_battle_div_details : List Battle -> List Battle
filter_battle_div_details battles =
    List.map (\x -> update_battle_div_details_2 x) battles
