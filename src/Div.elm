module Div exposing (Div, init, Judge_div, error_div, update, view_route, check_commander_assigned, check_commander_status)
-- Div, init, error_div, update, view_route, check_commander_assigned, check_commander_status
import AStar exposing (get_shortest_path)
import Bitwise
import Block
import Commander exposing (..)
import Debug exposing (log)
import General exposing (..)
import Html exposing (Html)
import Html.Attributes as HtmlAttr exposing (selected)
import Html.Events exposing (..)
import Map exposing (Map)
import Msg exposing (Msg(..))
import String exposing (fromFloat)
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr
import Svg.Events

{-| Definition of Division-}
type alias Div =
    { hp : Int
    , initial_hp : Int
    , class : Class --this will determine power & move point
    , nation : Nation
    , offset : Offset
    , number : Int
    , route : List Offset
    , move_timer : Float
    , commander : Commander
    , cons_progress : ConstructionState
    , cons_timer : Float
    , judge : Judge_div
    }

{-| Definition of the Judgement of a division-}
type alias Judge_div =
    { moving : Bool
    , selected : Bool
    , to_be_assigned_commander : Bool
    , is_enemy : Bool
    , exp : Int
    }

{-| Initialization of a division-}
init : Class -> Nation -> Offset -> Int -> Div
init class nation offset number =
    let
        hp =
            1000

        initial_hp =
            hp

        is_enemy =
            case nation of
                France ->
                    False

                _ ->
                    True

        exp =
            0

        moving =
            False

        route =
            []

        move_timer =
            0.0

        selected =
            False

        to_be_assigned_commander =
            False

        commander =
            default_commander

        cons_progress =
            Unoccupied

        judge_div =
            Judge_div False False False is_enemy 0

        cons_timer =
            0.0
    in
    Div hp initial_hp class nation offset number route move_timer commander cons_progress cons_timer judge_div

{-| Provide a default value of a division-}
error_div : Div
error_div =
    init Fast France ( -1, -1 ) -1



-- type Tactic
--     = Balanced
--     | Offensive
--     | Defensive


ad_period : Float
ad_period =
    500.0


class_to_speed : Class -> Float
class_to_speed class =
    case class of
        Guard ->
            1.5

        Fast ->
            2.3

        Engineer ->
            0.8

        Grenadier ->
            1.0

{-| Update changes happened to a division, like moving, battle, assigning a commander and so on-}
update : Msg -> Map -> List Div -> Div -> Div
update msg map list_other_side div =
    case msg of
        Tick elapsed ->
            let
                elapsed_moving =
                    elapsed * class_to_speed div.class

                --following are for moving
                updated_timer =
                    if div.route == [] then
                        0

                    else
                        div.move_timer + elapsed_moving

                next_offset =
                    case List.head div.route of
                        Nothing ->
                            div.offset

                        Just h ->
                            if (List.filter (\x -> x.offset == div.offset) list_other_side |> List.length) == 0 then
                                h

                            else
                                div.offset

                next_block =
                    Map.offset_to_block map div.offset

                time_cost =
                    toFloat next_block.ap_cost * ad_period

                able_to_move =
                    if next_offset == div.offset then
                        False

                    else if updated_timer < time_cost then
                        False

                    else
                        True

                n_timer =
                    if able_to_move then
                        0

                    else
                        updated_timer

                n_offset =
                    if able_to_move then
                        next_offset

                    else
                        div.offset

                n_route =
                    if able_to_move then
                        List.drop 1 div.route

                    else
                        div.route

                -- following are for the construction of engineers
                updated_cons_timer =
                    case div.cons_progress of
                        Unoccupied ->
                            0.0

                        Finished _ ->
                            0.0

                        Building _ ->
                            div.cons_timer + elapsed

                time_needed =
                    case div.cons_progress of
                        Unoccupied ->
                            -1

                        Finished _ ->
                            -1

                        Building ( cons, prog ) ->
                            cons_to_gen_time cons

                n_progress =
                    case div.cons_progress of
                        Unoccupied ->
                            Unoccupied

                        Finished _ ->
                            Unoccupied

                        Building ( cons, prog ) ->
                            Building ( cons, Basics.min 100 (floor (updated_cons_timer * 100.0 / time_needed)) )

                is_finished =
                    case div.cons_progress of
                        Unoccupied ->
                            False

                        Finished _ ->
                            False

                        Building _ ->
                            if updated_cons_timer < time_needed then
                                False

                            else
                                True

                n_cons_timer =
                    if is_finished then
                        0.0

                    else
                        updated_cons_timer

                nn_progress =
                    if is_finished then
                        case div.cons_progress of
                            Unoccupied ->
                                Unoccupied

                            -- won't happen
                            Building ( cons, prog ) ->
                                Finished cons

                            Finished _ ->
                                Unoccupied
                        -- won't happen

                    else
                        n_progress

                final_progress =
                    case List.head div.route of
                        Nothing ->
                            nn_progress

                        Just _ ->
                            Unoccupied

                n_exp =
                    if div.judge.exp > 100 then
                        0

                    else
                        div.judge.exp

                judge =
                    div.judge
            in
            { div | move_timer = n_timer, route = n_route, offset = n_offset, cons_progress = final_progress, cons_timer = n_cons_timer, judge = { judge | exp = n_exp } }

        Destination offset ->
            let
                shortest_path =
                    get_shortest_path map div.offset offset

                n_route =
                    case shortest_path of
                        Nothing ->
                            []

                        Just a ->
                            a

                judge =
                    div.judge
            in
            { div | route = n_route, move_timer = 0.0, judge = { judge | to_be_assigned_commander = False } }

        Division n ->
            let
                judge =
                    div.judge
            in
            if div.number == n then
                { div | judge = { judge | selected = True } }

            else
                { div | judge = { judge | selected = False } }

        AssignCommander tuple ->
            let
                ( commander_TBA, n ) =
                    tuple
            in
            if div.number == n then
                assign_commander commander_TBA div

            else
                div

        Commander1 ->
            let
                judge =
                    div.judge
            in
            if judge.selected == True then
                -- if div.selected == True && div.commander == default_commander then
                { div | judge = { judge | to_be_assigned_commander = True } }

            else
                { div | judge = { judge | to_be_assigned_commander = False } }

        ConstructionMsg ( cons, div_number ) ->
            if div.number == div_number then
                { div | cons_progress = Building ( cons, 20 ), cons_timer = 0.0 }

            else
                div

        _ ->
            let
                judge =
                    div.judge
            in
            { div | judge = { judge | to_be_assigned_commander = False } }

{-| View function of the aw division's route to its destination-}
view_route : MapSizeArg -> Div -> Svg Msg
view_route map_size_arg div =
    let
        center_points =
            List.map (offset_to_position map_size_arg) (div.offset :: div.route)

        points_str =
            points_to_string center_points
    in
    if div.judge.is_enemy then
        Svg.rect [] []

    else
        Svg.polyline
            [ SvgAttr.fill "none"
            , SvgAttr.stroke "red"
            , SvgAttr.strokeWidth "6"
            , SvgAttr.points points_str
            , SvgAttr.strokeLinejoin "round"
            ]
            []


assign_commander : Commander -> Div -> Div
assign_commander commander div =
    let
        judge =
            div.judge
    in
    { div | commander = commander, judge = { judge | to_be_assigned_commander = False } }

{-| Check whether a division has been assigned a commander-}
check_commander_assigned : List Div -> List Commander -> List Commander
check_commander_assigned list_div list_commander =
    let
        assigned_commanders =
            List.map (\x -> x.commander) list_div
    in
    List.filter (\x -> Commander.is_not_member x assigned_commanders) list_commander

{-| Check whether all the commanders have been assigned-}
check_commander_status : List Div -> Bool
check_commander_status list =
    let
        bool_list =
            List.filter (\x -> x.judge.to_be_assigned_commander == True) list
    in
    if List.length bool_list == 0 then
        False

    else
        True
