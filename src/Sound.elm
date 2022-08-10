module Sound exposing (Sound, update_battle_sounds, view, view_bgm, update)
--Sound, update_battle_sounds, view, view_bgm, update
import Msg exposing (..)
import General exposing (..)
import Html.Attributes as HtmlAttr
import Html exposing (Html, div)
import Div exposing (Div, error_div)
import Battle exposing (Battle)

{-| Definition of Sound-}
type Sound
    = PeopleMove
    | FastMove
    | GunShot
    | Explosion
    | NoSound

sound_to_string : Sound -> String
sound_to_string sound = 
    case sound of 
        PeopleMove -> "PeopleMove"
        FastMove -> "FastMove"
        GunShot -> "GunShot"
        Explosion -> "Explosion"
        _ -> ""

div_to_battle_sound : Div -> Sound
div_to_battle_sound div = 
    case div.class of
        Grenadier -> Explosion
        _ -> GunShot 
    
add_battle_sound : Battle -> List Sound
add_battle_sound battle = 
    let
        sound1 = 
            case battle.player_div of
                Just pd -> (List.map div_to_battle_sound pd)
                Nothing -> [ NoSound ]
        sound2 = 
            case battle.enemy_div of
                Just ed -> (List.map div_to_battle_sound ed)
                Nothing -> [ NoSound ]
    in
        List.filter (\x -> x /= NoSound) (List.concat [ sound1, sound2 ])
        
{-| Update sound for battles, activated only when there is a battle-}
update_battle_sounds : List Sound -> List Battle -> List Sound
update_battle_sounds sounds battles = 
    let
        newly_added_sounds = 
            List.map add_battle_sound battles
                |> List.concat
    in
        List.append sounds newly_added_sounds

view_sound : Sound -> Html Msg
view_sound sound = 
    Html.audio
            [ HtmlAttr.src ("./assets/music/" ++ ( sound_to_string sound )++ ".mp3")
            , HtmlAttr.autoplay True
            , HtmlAttr.loop False
            , HtmlAttr.preload "auto"
            , HtmlAttr.style "desplay" "block"
            , HtmlAttr.style "position" "absolute"
            , HtmlAttr.style "top" "0"
            --, HtmlAttr.controls True
            ]
            []

{-| View the sound and its progress-}
view : List Sound -> Html Msg
view sounds = 
    Html.div
        []
        (List.map view_sound sounds)
        
{-| Update the sounds if there is an operation that will bring by sound effects-}
update : Msg -> List Sound -> Div -> List Sound
update msg sounds div = 
    let
        n_moving_sound = 
            case div.class of
                Fast -> FastMove
                _ -> PeopleMove
    in
    case msg of
        Destination _ ->
            (List.append sounds [ n_moving_sound ])
            |> drop_not_necessary_sounds
        _ -> sounds

drop_not_necessary_sounds : List Sound -> List Sound
drop_not_necessary_sounds sounds = 
    let
        max_num = 10
        length = List.length sounds
    in
        if length > max_num then
            List.drop (length - 1) sounds
        else
            sounds

{-| The background music and its process-}
view_bgm : Html Msg
view_bgm = 
    Html.audio
        [ HtmlAttr.src ("./assets/music/BGM.mp3")
        , HtmlAttr.autoplay True
        , HtmlAttr.loop True
        , HtmlAttr.preload "auto"
        , HtmlAttr.style "desplay" "block"
        , HtmlAttr.style "position" "absolute"
        , HtmlAttr.style "bottom" "0%"
        , HtmlAttr.style "right" "8%"
        , HtmlAttr.controls True
        ]
        []
