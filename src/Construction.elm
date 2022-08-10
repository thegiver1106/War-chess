module Construction exposing (view)
import Div exposing (Div)
import General exposing (..)
import Msg exposing (Msg(..))
import Html exposing (div, Html)
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr
import String exposing (fromFloat, fromInt)
import VirtualDom
import Svg.Events



construction_to_desc : Construction -> String
construction_to_desc cons = 
    case cons of
        Barricades -> "Action Point of this block +3"

{-| The view function of the constructed barricades-}
view : Div -> ( Float, Float ) -> List ( Html Msg )
view selected_div screen_size = 
    let
        cons_list = 
            [ Barricades ]
        progress_list = 
            List.map (\x -> 
                case selected_div.cons_progress of
                    Unoccupied -> -1
                    Finished _ -> -1
                    Building ( construction, prog ) ->
                        if x == construction then
                            prog
                        else
                            -1 )
                    
            cons_list
        n_list = 
            List.range 1 ( List.length cons_list )
    in
    if selected_div.class /= Engineer then
        []
    else
        List.map3 (view_button_for_construction screen_size selected_div.number) cons_list n_list progress_list
            |> List.concat


view_button_for_construction : ( Float, Float ) -> Int -> Construction -> Int -> Int -> List ( Html Msg )
view_button_for_construction screen_size div_number cons n progress = 
    let
        ( screen_width, screen_height ) = 
            screen_size
        width = 
            screen_width * 0.04
        x = 
            screen_width - width - width / 4.0 - width - width / 4.0
        height = 
            width
        txt_height = 
            width * 0.25
        y = 
            screen_width * 0.05 + ( toFloat n ) * ( height + txt_height * 1.25 )
        cons_str = 
            cons_to_string cons
        display_progress = 
            if progress < 0 then
                100.0
            else
                toFloat progress

    in
    [Svg.rect
        [ SvgAttr.width (fromFloat width)
        , SvgAttr.height (fromFloat height)

        , SvgAttr.x (fromFloat x)
        , SvgAttr.y (fromFloat y)

        , SvgAttr.rx "10"
        , SvgAttr.fill "orange"
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
        , Svg.Events.onClick ( ConstructionMsg (cons, div_number) )
        , SvgAttr.xlinkHref ("./assets/" ++ cons_str ++".png")
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
        , Svg.Events.onClick ( ConstructionMsg (cons, div_number) )
        ]
        []
    , Svg.text_
        [ SvgAttr.x ( fromFloat ( x + width * 0.5 ) )
        , SvgAttr.y ( fromFloat ( y + height + txt_height * 0.7 ) )
        , SvgAttr.fill "black"
        , SvgAttr.fontSize ( fromFloat txt_height )
        , SvgAttr.fontWeight "700"
        , SvgAttr.dominantBaseline "middle"
        , SvgAttr.textAnchor "middle"
        ]
        [ VirtualDom.text cons_str ]
    ]

