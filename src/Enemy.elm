module Enemy exposing (Enemy, get_visibility_enemy, init, make_move, update)

import AStar exposing (get_shortest_path)
import Block exposing (Block)
import Div exposing (Div)
import DivInit
import General exposing (..)
import Level1
import Level2
import Level3
import Map exposing (Map)
import Msg exposing (Msg(..))
import Player exposing (Player)

{-| Definition of Enemy-}
type alias Enemy =
    { army : List Div
    , base_camp : List Offset
    , player_base : Offset

    --, player_army : List Div
    , mode : Strategy
    , map : Map
    }


type Strategy
    = Defend
      --| Attack
    | Advance


type Target
    = Div
    | Base

{-| The initialization of the enemy in different levels-}
init : Int -> Map -> Player -> Enemy
init level map player =
    let
        base_offset =
            case level of
                1 ->
                    Level1.enemy_base

                2 ->
                    Level2.enemy_base

                3 ->
                    Level3.enemy_base

                _ ->
                    [ ( -1, -1 ) ]
    in
    Enemy (DivInit.enemy_army_init level) base_offset player.base.offset Defend map

{-| Update changes of the enemy in levels, like moving and fighting-}
update : Msg -> Enemy -> Player -> List Div -> Enemy
update msg enemy player list_other_side =
    let
        nmode =
            update_mode enemy player.army
    in
    case msg of
        Tick elapsed ->
            { enemy | army = List.map (Div.update msg enemy.map list_other_side) enemy.army, mode = nmode }

        _ ->
            enemy

{-| Move an enemy division-}
make_move :
    Player
    -> Enemy
    -> Enemy -- enemy makes move
make_move player enemy =
    case enemy.mode of
        Defend ->
            { enemy | army = set_route (defend_pos enemy player.army) enemy player.army }

        Advance ->
            { enemy | army = set_route enemy.player_base enemy player.army }


update_mode : Enemy -> List Div -> Strategy
update_mode enemy player_army =
    if threatening_troops enemy player_army > 0 then
        Defend

    else
        Advance



-- constants


move_points : Int
move_points =
    100


detection_radius : Float
detection_radius =
    4



-- fighting modes & heuristics


defend_pos :
    Enemy
    -> List Div
    -> Offset -- targets by strength and distance from base
defend_pos enemy player_army =
    let
        ordered_list =
            List.sortBy (\x -> defend_heuristics x enemy) player_army |> List.reverse

        target_div =
            case List.head ordered_list of
                Just val ->
                    val

                Nothing ->
                    Div.error_div
    in
    target_div.offset


defend_heuristics : Div -> Enemy -> Float
defend_heuristics x enemy =
    let
        troops_in_pos =
            List.filter (\{ offset } -> x.offset == offset) enemy.army |> List.length |> toFloat

        base_camp_enemy =
            case List.head enemy.base_camp of
                Just a ->
                    a

                Nothing ->
                    ( 0, 0 )
    in
    get_threat_level x.class / (distance base_camp_enemy x.offset * (1 + troops_in_pos))


advance_pos : Enemy -> Offset
advance_pos enemy =
    enemy.player_base



--auxiliary functions


div_positions :
    List Div
    -> List Offset --returns list of division positions
div_positions army =
    List.map (\{ offset } -> offset) army


distance : Offset -> Offset -> Float
distance offset1 offset2 =
    let
        cube1 =
            offset_to_cube offset1

        cube2 =
            offset_to_cube offset2
    in
    toFloat (cube_distance_from_cube cube1 cube2)


get_threat_level : Class -> Float
get_threat_level class =
    case class of
        Fast ->
            2

        Guard ->
            1

        Grenadier ->
            3

        Engineer ->
            2


set_route : Offset -> Enemy -> List Div -> List Div
set_route dest enemy player_army =
    if enemy.army /= [] && dest /= Div.error_div.offset then
        let
            ordered_list =
                List.filter (not_in_battle player_army) enemy.army
                    |> List.sortBy (\{ offset } -> distance dest offset)
                    |> filter_moving_enemy

            -- moving_enemy_number = List.length ordered_list
            -- player_div_number = List.length player_army
            move_div =
                --if (2 * moving_enemy_number <=  player_div_number) then
                case ordered_list |> List.head of
                    Just val ->
                        val

                    Nothing ->
                        Div.error_div

            -- else
            --     Div.error_div
            m_route =
                get_shortest_path enemy.map move_div.offset dest

            ( begin, end ) =
                List.partition (\x -> x == move_div) enemy.army
        in
        case m_route of
            Just val ->
                { move_div | route = List.take move_points val } :: end

            Nothing ->
                enemy.army

    else
        enemy.army



-- update functions


player_div_close_to_enemy_base : Offset -> List Offset -> Bool
player_div_close_to_enemy_base div bases =
    List.length (List.filter (\base -> distance div base <= detection_radius) bases) > 0


threatening_troops :
    Enemy
    -> List Div
    -> Int -- amount of threatening troops
threatening_troops enemy player_army =
    List.filter (\{ offset } -> player_div_close_to_enemy_base offset enemy.base_camp) player_army
        |> List.filter (not_in_battle enemy.army)
        |> List.length


not_in_battle :
    List Div
    -> Div
    -> Bool --checks if division is in battle with enemy divisions
not_in_battle enemy div =
    List.all (\{ offset } -> offset /= div.offset) enemy

{-| Gives out the enemy divisions that can be seen by the player-}
get_visibility_enemy :
    Map
    -> Div
    -> Bool -- sets visibility for enemy divisions
get_visibility_enemy map enemy =
    let
        block =
            Map.blocks_to_list map.blocks
                |> List.filter (\{ offset } -> enemy.offset == offset)
                |> List.head
    in
    case block of
        Just b ->
            if b.visible == OnSight then
                True

            else
                False

        Nothing ->
            False


filter_moving_enemy : List Div -> List Div
filter_moving_enemy enemy_army =
    let
        unmoving_enemy =
            List.filter (\x -> x.judge.moving == False) enemy_army

        moving_enemy =
            List.filter (\x -> x.judge.moving == True) enemy_army
    in
    if List.length enemy_army == 0 then
        [ Div.init Fast Austria ( 28, 2 ) 41 ]

    else if List.length moving_enemy <= 4 then
        if List.length moving_enemy == 4 && List.take 1 enemy_army == List.take 1 moving_enemy then
            unmoving_enemy

        else
            List.take 1 enemy_army ++ List.drop 1 moving_enemy

    else
        []
