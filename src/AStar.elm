module AStar exposing (get_shortest_path)
-- Find the shortest path using A* algorithm.

import PriorityQueue exposing (PriorityQueue)
import Set exposing (Set)
import Dict exposing (Dict)

import Block exposing (Block, cube_distance)
import Map exposing (Map, get_neighbours_cube, cube_to_block, offset_to_block)
import General exposing (..)

{-| Give out a list of Offset, which represent the shortest path from the first input offest to the second input offest in the given map -}
get_shortest_path : Map -> Offset -> Offset -> Maybe ( List Offset )
get_shortest_path map begin end =
    let
        cbegin = offset_to_cube begin
        cend = offset_to_cube end
        model = init cbegin cend
    in
        if (offset_to_block map end).ap_cost > 100 then
            Nothing
        else
            case solve map model of
                Nothing -> Nothing
                Just arr -> Just ( List.map cube_to_offset arr )

type alias Model = 
    { begin : Cube
    , end : Cube
    , open_set : PriorityQueue ( Cube, Int )
    , close_set : Set Cube
    , fathers : Dict Cube Cube
    -- The previous node in the shortest path.
    , costs_from_begin : Dict Cube Int
    , costs_to_end : Dict Cube Int
    }

total_cost_priority : PriorityQueue.Priority ( Cube, Int )
total_cost_priority = Tuple.second
-- Cube represents the block and Int represents the total cost of the corresponding block.
    
init : Cube -> Cube -> Model
init begin end = 
    let
        close_set = Set.empty
        fathers = Dict.empty
        costs_from_begin = Dict.empty
            |> Dict.insert begin 0
        costs_to_end = Dict.empty
            |> Dict.insert begin ( cube_distance_from_cube begin end )
        open_set 
            = PriorityQueue.empty total_cost_priority
            |> PriorityQueue.insert ( begin, 0 + cube_distance_from_cube begin end )
    in
        Model begin end open_set close_set fathers costs_from_begin costs_to_end

construct_path : Dict Cube Cube -> Cube -> List Cube
construct_path fathers end =
    case Dict.get end fathers of
        Nothing -> []
        Just prev -> List.append ( construct_path fathers prev ) ( List.singleton end )

update : Map -> Cube -> Cube -> Model -> Model
update map best neighbour model = 
    -- update fathers, costs_to_end, costs_from_begin, open_set based on neighbours and best
    let
        costs_to_end = model.costs_to_end
        costs_from_begin = model.costs_from_begin

        n_costs_to_end = 
            case Dict.get neighbour costs_to_end of
                Nothing -> Dict.insert neighbour n_cost_to_end costs_to_end
                Just _ -> costs_to_end
        n_cost_to_end = 
            case Dict.get neighbour costs_to_end of
                Nothing -> 10000 -- this won't happen
                Just cost -> cost

        n_cost_from_begin = 
            case Dict.get best costs_from_begin of
                Nothing -> 10000 -- this won't happen
                Just a -> a + (cube_to_block map neighbour).ap_cost

        to_update = 
            case Dict.get neighbour costs_from_begin of
                Nothing -> True
                -- no path before
                Just a -> 
                    if a > n_cost_from_begin then
                        True
                        -- better path
                    else
                        False
        n_costs_from_begin = 
            if to_update then
                Dict.insert neighbour n_cost_from_begin costs_from_begin
            else
                costs_from_begin
        n_fathers = 
            if to_update then
                Dict.insert neighbour best model.fathers
            else
                model.fathers

        n_open_set = 
            if to_update then
                PriorityQueue.insert ( neighbour, n_cost_to_end + n_cost_from_begin ) model.open_set
            else
                model.open_set
    in
        { model | fathers = n_fathers, costs_to_end = n_costs_to_end, costs_from_begin = n_costs_from_begin, open_set = n_open_set }
    
-- Find the shortest path using A* algorithm
solve : Map -> Model -> Maybe ( List Cube )
solve map model =
    case PriorityQueue.head model.open_set of
        Nothing ->
            Nothing

        Just ( best, _ ) ->
            if Set.member best model.close_set then
                -- There was a better path for it, so just skip.
                solve map { model | open_set = PriorityQueue.tail model.open_set }

            else if best == model.end then
                -- success!
                Just ( construct_path model.fathers model.end )

            else
                let
                    model_with_best =
                        { model
                            | open_set = PriorityQueue.tail model.open_set
                            , close_set = Set.insert best model.close_set
                        }

                    neighbours = Set.diff ( get_neighbours_cube map best ) model_with_best.close_set

                    model_updated = Set.foldl (update map best) model_with_best neighbours
                    -- update fathers, costs_to_end, costs_from_begin, open_set based on neighbours and best

                in
                    solve map model_updated



