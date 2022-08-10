module Events exposing (Events, init, events_button, events_page, events_table, update)
--Events, init, events_button, events_page, events_table, update
import General exposing (..)
import Html exposing (Html, div)
import Html.Attributes as HtmlAttr exposing (height)
import Html.Events
import Msg exposing (..)
import String exposing (fromFloat, fromInt)
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr
import Svg.Events
import VirtualDom


type ActiState
    = On
    | Off

{-| Definition of Events-}
type alias Events =
    { events : List Event
    , acti_state : ActiState
    , money : Float
    }

{-| Initialization of an events-}
init : Events
init =
    Events [] Off 50.0


event_to_money : Event -> Float
event_to_money event =
    case event of
        Impressment ->
            10.0

        CodeNapoleon ->
            20.0

        RewardSol ->
            30.0

{-| View the button for activatin the events page-}
events_button : ( Float, Float ) -> List (Svg Msg)
events_button screen_size =
    let
        ( s_w, s_h ) =
            screen_size

        ( width, height ) =
            ( s_w * 0.04, s_w * 0.04 )

        txt_height =
            width * 0.25

        x =
            s_w - width - width / 4.0

        y =
            s_w * 0.05 + 7.0 * (height + txt_height * 1.25)
    in
    [ Svg.image
        [ SvgAttr.width (fromFloat width)
        , SvgAttr.height (fromFloat height)
        , SvgAttr.x (fromFloat x)
        , SvgAttr.y (fromFloat y)
        , SvgAttr.rx "10"
        , Svg.Events.onClick (Activate ActiEvents)
        , SvgAttr.xlinkHref "./assets/Events_icon.png"
        ]
        []
    , Svg.text_
        [ SvgAttr.x (fromFloat (x + width * 0.5))
        , SvgAttr.y (fromFloat (y + height + txt_height * 0.3))
        , SvgAttr.fill "black"
        , SvgAttr.fontSize (fromFloat txt_height)
        , SvgAttr.fontWeight "700"
        , SvgAttr.dominantBaseline "middle"
        , SvgAttr.textAnchor "middle"
        ]
        [ VirtualDom.text "Events" ]
    ]

{-| View the page of events selection-}
events_page : Events -> List (Svg Msg)
events_page events =
    let
        display =
            case events.acti_state of
                On ->
                    "block"

                Off ->
                    "none"

        width =
            70.0

        height =
            70.0

        right =
            width + (100.0 - width) * 0.5

        bottom =
            height + (100.0 - height) * 0.5
    in
    [ Svg.rect
        [ SvgAttr.width (fromFloat width ++ "%")
        , SvgAttr.height (fromFloat height ++ "%")
        , SvgAttr.x (fromFloat ((100 - width) * 0.5) ++ "%")
        , SvgAttr.y (fromFloat ((100 - height) * 0.5) ++ "%")
        , SvgAttr.rx "10"
        , SvgAttr.fill "brown"
        , SvgAttr.display display
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "10px"
        ]
        []
    , Svg.image
        [ SvgAttr.width "5%"
        , SvgAttr.height "5%"
        , SvgAttr.x (fromFloat ((100 - width) * 0.5 + width) ++ "%")
        , SvgAttr.y (fromFloat ((100 - height) * 0.5) ++ "%")
        , SvgAttr.rx "10"
        , Svg.Events.onClick (Activate ActiEvents)
        , SvgAttr.xlinkHref "./assets/close.png"
        , SvgAttr.display display
        ]
        []
    , Svg.image
        [ SvgAttr.width "10%"
        , SvgAttr.height "10%"
        , SvgAttr.x (fromFloat (right * 0.9 - 14.0) ++ "%")
        , SvgAttr.y (fromFloat (bottom * 0.9 - 7.0) ++ "%")
        , SvgAttr.rx "10"
        , Svg.Events.onClick (Activate ActiEvents)
        , SvgAttr.xlinkHref "./assets/coins.png"
        , SvgAttr.display display
        ]
        []
    , Svg.text_
        [ SvgAttr.x (fromFloat (right * 0.9) ++ "%")
        , SvgAttr.y (fromFloat (bottom * 0.9) ++ "%")
        , SvgAttr.fill "black"
        , SvgAttr.fontSize (fromFloat 40)
        , SvgAttr.fontWeight "700"
        , SvgAttr.dominantBaseline "middle"
        , SvgAttr.textAnchor "middle"
        , Html.Events.onClick Commander1
        , SvgAttr.display display
        ]
        [ VirtualDom.text ("Money: " ++ fromInt (floor events.money)) ]
    ]


gen_button : Event -> Html Msg
gen_button event =
    Html.button
        [ Html.Events.onClick (Eventmsg event)
        ]
        [ Html.text "Trigger" ]


gen_img : Event -> Html Msg
gen_img event =
    Html.img
        [ HtmlAttr.src ("./assets/" ++ event_to_string event ++ ".png")

        --, HtmlAttr.style "width" "35%"
        --, HtmlAttr.style "height" "90%"
        --, HtmlAttr.style "left" "10%"
        --, HtmlAttr.style "top" "5%"
        --, HtmlAttr.style "position" "absolute"
        --, HtmlAttr.style "display" "block"
        ]
        []

{-| Provide the events table for the player-}
events_table : ActiState -> Html Msg
events_table acti_state =
    let
        width =
            70.0

        height =
            70.0

        display =
            case acti_state of
                On ->
                    "block"

                Off ->
                    "none"

        name_ls =
            [ "Intensive Conscript"
            , "Code Napoleon"
            , "Award the Military"
            ]

        desc_ls =
            [ "Force citizens and peasants to join the army. Conscript Speed↑ HP↓"
            , "Reward industry. Income↑"
            , "Reward soldiers. Attack↑ HP↑ Speed↑"
            ]

        event_ls =
            [ Impressment, CodeNapoleon, RewardSol ]

        button_ls =
            List.map gen_button event_ls

        img_ls =
            List.map gen_img event_ls

        price_ls =
            [ 10.0, 20.0, 30.0 ]
    in
    Html.div
        [ HtmlAttr.style "position" "absolute"
        , HtmlAttr.style "top" (fromFloat ((100.0 - height) * 0.5 + 2) ++ "%")
        , HtmlAttr.style "left" (fromFloat ((100 - width) * 0.5 + 2) ++ "%")
        , HtmlAttr.style "width" (fromFloat width ++ "%")
        , HtmlAttr.style "height" (fromFloat width ++ "%")
        , HtmlAttr.style "display" display
        ]
        [ Html.table
            []
            (Html.tr
                []
                [ Html.th [] [ Html.text "" ]
                , Html.th [] [ Html.text "Name" ]
                , Html.th [] [ Html.text "Description" ]
                , Html.th [] [ Html.text "Price" ]
                , Html.th [] [ Html.text "Button" ]
                ]
                :: List.map5 table_row_gen img_ls name_ls desc_ls button_ls price_ls
            )
        ]


table_row_gen : Html Msg -> String -> String -> Html Msg -> Float -> Html Msg
table_row_gen image name desc button price =
    Html.tr
        []
        [ Html.td
            [ HtmlAttr.style "width" "0%" ]
            [ image ]
        , Html.td
            [ HtmlAttr.align "center"
            , HtmlAttr.style "width" "5%"
            ]
            [ Html.text name ]
        , Html.td
            [ HtmlAttr.style "width" "10%" ]
            [ Html.text desc ]
        , Html.td
            [ HtmlAttr.style "width" "5%"
            , HtmlAttr.align "center"
            ]
            [ Html.text (fromFloat price ++ "₣") ]
        , Html.td
            [ HtmlAttr.style "width" "5%"
            , HtmlAttr.align "center"
            ]
            [ button ]
        ]

{-| Update the events and their effects-}
update : Msg -> Events -> Events
update msg events =
    let
        reversed_acti_state =
            case events.acti_state of
                On ->
                    Off

                Off ->
                    On
    in
    case msg of
        Activate acti_type ->
            case acti_type of
                ActiEvents ->
                    { events | acti_state = reversed_acti_state }

                _ ->
                    events

        Tick elapsed ->
            let
                d_money =
                    if List.member CodeNapoleon events.events then
                        elapsed / 3000.0 * 1.5

                    else
                        elapsed / 3000.0

                n_money =
                    events.money + d_money
            in
            { events | money = n_money }

        Eventmsg event ->
            let
                n_money =
                    if events.money >= event_to_money event then
                        events.money - event_to_money event

                    else
                        events.money

                n_events =
                    if events.money >= event_to_money event then
                        event :: events.events

                    else
                        events.events
            in
            { events | events = n_events, money = n_money }

        _ ->
            events
