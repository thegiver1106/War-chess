module Base exposing (..)
import General exposing (..)
import Msg exposing (..)
import Html exposing (Html, a, button, div, text)
import Html.Attributes as HtmlAttr exposing (..)
import String exposing (fromFloat, fromInt)
import Html.Events exposing (keyCode, onClick)
import Svg exposing (Svg)
import Svg.Events
import Svg.Attributes as SvgAttr
import VirtualDom

{-| Definition of type Base, the target the player have to capture or the important place need the player's defence-}
type alias Base = 
    { offset : Offset
    , orders : List Class
    , order_timer : Float
    , progress : Maybe ( Class, Int )
    }
{-| Create a new base-}
init : Offset -> Base
init offset = 
    Base offset [] 0.0 Nothing
{-| update the generation of divisions-}
update : Msg -> Base -> Base
update msg base = 
    case msg of
        Tick elapsed ->
            let
                updated_timer =
                    if base.orders == [] then
                        0.0
                    else
                        base.order_timer + elapsed

                current_order =
                    List.head base.orders

                time_needed =
                    case current_order of
                        Nothing -> -1
                        Just co ->  class_to_gen_time co


                n_progress =
                    case current_order of
                        Nothing -> Nothing
                        Just co ->
                            Just ( co, Basics.min 100 ( floor ( updated_timer * 100.0 / time_needed ) ) )


                is_finished =
                    case current_order of
                        Nothing -> False
                        Just co ->
                            if updated_timer < time_needed then
                                False
                            else
                                True

                n_timer =
                    if is_finished then
                        0.0
                    else
                        updated_timer

                n_orders =
                    if is_finished then
                        List.drop 1 base.orders
                    else
                        base.orders
            in
            { base | order_timer = n_timer, orders = n_orders, progress = n_progress }
        Conscript class -> 
            { base | orders = List.append base.orders [ class ] }
        _ ->
            base
{-| View the progress of the generation of division happening in the base-}
view : Base -> ( Float, Float ) ->  List (Svg Msg)
view base screen_size = 
    let
        class_list = 
            [ Fast, Guard, Engineer, Grenadier ]
        count_in_orders = 
            \x -> List.length ( List.filter (\y -> y == x) base.orders )
        num_orders_list = 
            List.map count_in_orders class_list
        progress_list = 
            List.map (\x -> 
                case base.progress of
                    Nothing -> -1
                    Just ( cls, prog ) ->
                        if x == cls then
                            prog
                        else
                            -1 )
            class_list
        n_list = 
            List.range 1 ( List.length class_list )
    in
    List.map4 (view_button_for_conscript screen_size) class_list n_list num_orders_list progress_list
        |> List.concat


view_button_for_conscript : ( Float, Float ) -> Class -> Int -> Int -> Int -> List (Svg Msg)
view_button_for_conscript screen_size class n num_orders progress =
    let
        num_orders_str = 
            if num_orders > 0 then
                "[" ++ fromInt num_orders ++ "] "
            else
                ""
        class_str = 
            class_to_string class

        display_progress = 
            if progress < 0 then
                100.0
            else
                toFloat progress
        ( screen_width, screen_height ) = 
            screen_size
        width = 
            screen_width * 0.04
        x = 
            screen_width - width - width / 4.0
        height = 
            width
        txt_height = 
            width * 0.25
        y = 
            screen_width * 0.05 + ( toFloat n ) * ( height + txt_height * 1.25 )

    in
    [Svg.rect
        [ SvgAttr.width (fromFloat width)
        , SvgAttr.height (fromFloat height)

        , SvgAttr.x (fromFloat x)
        , SvgAttr.y (fromFloat y)

        , SvgAttr.rx "10"
        , SvgAttr.fill "#B2DFEE"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "4"
        ]
        []
    , Svg.image
        [ SvgAttr.width (fromFloat width)
        , SvgAttr.height (fromFloat height)
        , SvgAttr.x (fromFloat x)
        , SvgAttr.y (fromFloat y)
        , SvgAttr.rx "10"
        , Svg.Events.onClick ( Conscript class )
        , SvgAttr.xlinkHref ("./assets/" ++ class_str ++"_icon.png")
        ]
        []
    , Svg.rect
        [ SvgAttr.width (fromFloat width)
        , SvgAttr.height (fromFloat ( height * ( 1.0 - display_progress / 100.0 ) ) )
        , SvgAttr.x (fromFloat x)
        , SvgAttr.rx "10"
        , SvgAttr.y (fromFloat y)
        , SvgAttr.fill "grey"
        , SvgAttr.opacity "0.8"
        , Svg.Events.onClick ( Conscript class )
        ]
        []
    , Svg.rect
        [ SvgAttr.width (fromFloat (width / 4.0))
        , SvgAttr.height (fromFloat (height / 4.0))
        , SvgAttr.x (fromFloat (x + width * 3.0 / 4.0))
        , SvgAttr.y (fromFloat y)
        , SvgAttr.stroke "black"
        , SvgAttr.fill "yellow"
        , SvgAttr.strokeWidth "1"
        , SvgAttr.display (if  num_orders > 0 then "block" else "none")
        ]
        []
    ,
    Svg.text_
        [ SvgAttr.x (fromFloat (x + width * 3.0 / 4.0 + width / 4.0 / 2.0 ))
        , SvgAttr.y (fromFloat (y + height / 6.5))
        , SvgAttr.fill "black"
        , SvgAttr.fontSize "15"
        , SvgAttr.dominantBaseline "middle"
        , SvgAttr.textAnchor "middle"
        , SvgAttr.fontWeight "700"
        , SvgAttr.display (if  num_orders > 0 then "block" else "none")
        ]
        [ VirtualDom.text (fromInt num_orders)]
    
    ,
    Svg.text_
        [ SvgAttr.x ( fromFloat ( x + width * 0.5 ) )
        , SvgAttr.y ( fromFloat ( y + height + txt_height * 0.7 ) )
        , SvgAttr.fill "black"
        , SvgAttr.fontSize ( fromFloat txt_height )
        , SvgAttr.fontWeight "700"
        , SvgAttr.dominantBaseline "middle"
        , SvgAttr.textAnchor "middle"
        ]
        [ VirtualDom.text class_str ]
    ]
