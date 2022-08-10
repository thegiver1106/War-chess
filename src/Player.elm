module Player exposing (..)

import Base exposing (Base)
import Block exposing (Block)
import Commander exposing (..)
import Div exposing (Div)
import General exposing (..)
import Map exposing (Map)
import Msg exposing (Msg(..))
import Events exposing (Events)
import DivInit
import Level1
import Level2
import Level3
import Level4
{-| Definition of Player-}
type alias Player =
    { army : List Div
    , division_picked : Int
    , base : Base
    , num_all_div : Int
    }

{-| Initialization of Player-}
init : Int -> Player
init level =
    let
        base_offset = 
            case level of
                1 -> Level1.player_base
                2 -> Level2.player_base
                3 -> Level3.player_base
                4 -> Level4.player_base
                _ -> ( -1, -1 )
        army = 
            DivInit.player_army_init level
    in
        Player army -1 (Base.init base_offset) (List.length army)


{-| Update changes in Player like the divisions, the base, the selected division and so on-}
update : Msg -> Events -> Map -> Player -> List Div -> Player
update msg events map player enemy_div =
    case msg of
        Tick elapsed ->
            let
                base_msg = 
                    if List.member Impressment events.events then
                        Tick (elapsed * 2.0)
                    else
                        msg
                n_base =
                    Base.update base_msg player.base

                n_div =
                    case n_base.progress of
                        Nothing ->
                            Nothing

                        Just ( class, rate ) ->
                            if rate == 100 then
                                Just (Div.init class France n_base.offset (player.num_all_div + 1))

                            else
                                Nothing
                n_num_all_div = 
                    case n_div of
                        Nothing -> player.num_all_div
                        Just _ -> player.num_all_div + 1

                n_army =
                    List.map (Div.update msg map enemy_div) player.army

                nn_army =
                    case n_div of
                        Nothing ->
                            n_army

                        Just nd ->
                            List.append n_army [ nd ]
            in
            { player | army = nn_army, base = n_base, num_all_div = n_num_all_div }

        Destination offset ->
            let
                army =
                    player.army

                div_number =
                    player.division_picked

                div =
                    case List.head (List.filter (\x -> x.number == div_number) army) of
                        Just a ->
                            a

                        Nothing ->
                            Div.error_div

                div_new =
                    Div.update msg map enemy_div div

                army_new =
                    List.map
                        (\x ->
                            if x.number == div_number then
                                div_new

                            else
                                x
                        )
                        army
            in
            if div_number == -1 then
                -- Haven't chosen any division yet.
                player

            else
                { player | army = army_new, division_picked = div_number }

        Conscript _ ->
            { player | base = Base.update msg player.base }
        
        ConstructionMsg _ ->
            let
                n_army = 
                    List.map (Div.update msg map enemy_div) player.army
            in
                { player | army = n_army }
        _ ->
            player

get_player_elem : Player -> List Offset --returns all the positions owned by the player  
get_player_elem player = 
    let
        list_pos = List.map (\{offset}-> offset) player.army 
    in 
    player.base.offset :: list_pos 



-- filter_positions_1 : List Offset -> List Offset
-- filter_positions_1 list =
--     if List.length list == 1 then
--         [ List.head list |> Maybe.withDefault ( 0, 0 ) ]

--     else if List.length list == 0 then
--         []

--     else
--         let
--             picked_one =
--                 List.head list |> Maybe.withDefault ( 0, 0 )

--             remained_list =
--                 List.filter (\x -> x /= picked_one) list
--         in
--         List.append [ picked_one ] (filter_positions_1 remained_list)