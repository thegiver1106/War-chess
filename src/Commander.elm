module Commander exposing (Commander, Boost, default_commander, init, boost_to_string, french_commander,is_not_member)
-- Commander, default_commander, init, boost_to_string, french_commander,is_not_member
import Json.Decode exposing (bool)

{-| Definition of Commanders-}
type alias Commander =
    { boost : Boost
    , name : String
    , ability : Int
    , select_status : Bool
    }

{-| Definition of Boost provided by a commander-}
type Boost
    = Health -- + x*1000 hp when battle
    | Strength -- + x*10% damage
    | Speed
    | None

{-| Provide an attribute to create a new commander-}
init : Boost -> String -> Int -> Commander
init boost name ability =
    Commander boost name ability False

{-| Provide a default value of error commanders-}
default_commander : Commander
default_commander =
    Commander None "Haven't been assigned a commander" 0 True
{-| Turn the boost type into string-}
boost_to_string : Boost -> String
boost_to_string boost = 
    case boost of
        Health ->
            "Health"
        Strength ->
            "Strength"
        Speed ->
            "Speed"
        _ ->
            " "

-- French commanders
-- Summary:
-- level 1: 5 in total; 2 * speed(2 + 1) + 2 * strength(3 + 2) + 1 * health(3)
-- level 2: 9 in total; 3 * speed(3 + 2 + 2) + 3 * strength(3 + 3 + 2) + 2 * health(3 + 2 + 2)
-- level 3: 7 in total; 3 * speed(3 + 3 + 2) + 2 * strength(3 + 3) + 2 * health (1 + 1)
-- level 1


marmont : Commander
marmont =
    Commander Speed "Marmont" 1 False


desaix : Commander
desaix =
    Commander Strength "Desaix" 2 False


massena : Commander
massena =
    Commander Health "Massena" 2 False



-- level 2


murat : Commander
murat =
    Commander Strength "Murat" 2 False


lannes : Commander
lannes =
    Commander Health "Lannes" 3 False


bernadotte : Commander
bernadotte =
    Commander Health "Bernadotte" 2 False


bessieres : Commander
bessieres =
    Commander Health "Bessieres" 2 False



-- level 3


grouchy : Commander
grouchy =
    Commander Health "Grouchy" 1 False


ney : Commander
ney =
    Commander Health "Ney" 1 False



-- level 2 && 3


soult : Commander
soult =
    Commander Strength "Soult" 3 False


davout : Commander
davout =
    Commander Speed "Davout" 3 False



-- level 1 && 2 && 3


berthier : Commander
berthier =
    Commander Speed "Berthier" 2 False


napoleon : Commander
napoleon =
    Commander Strength "Napoleon" 3 False

{-| The list of french commanders in all levels-}
french_commander : Int -> List Commander
french_commander int =
    case int of
        1 ->
            [ marmont, desaix, massena, berthier, napoleon ]

        2 ->
            [ murat, lannes, soult, davout, bernadotte, bessieres, berthier, napoleon ]

        3 ->
            [ ney, soult, davout, grouchy, berthier, napoleon ]

        _ ->
            []


get_commander : List Commander -> String -> Commander
get_commander list string =
    let
        filter_result =
            List.filter (\x -> x.name == string) list
    in
    List.head (List.filter (\x -> x.name == string) list)
        |> Maybe.withDefault default_commander



-- anti-france commander
-- Summary:
-- level 1: 3 in total; 1 * speed(1) + 1 * strength(2) + 1 * health(1)
-- level 2: 9 in total; 2 * speed(1 + 2) + 3 * strength(3 + 1 + 2) + 4 * health(3 + 2 + 2 + 1)
-- level 3:
-- level 1:


melas : Commander
melas =
    Commander Strength "Melas" 2 False


ott : Commander
ott =
    Commander Speed "Ott" 1 False


zach : Commander
zach =
    Commander Health "Zach" 1 False



-- level 2:


kutuzov : Commander
kutuzov =
    Commander Health "Kutuzov" 3 False


alexander_I : Commander
alexander_I =
    Commander Health "Alexander I" 2 False


bagration : Commander
bagration =
    Commander Strength "Bagration" 3 False


constantine : Commander
constantine =
    Commander Health "Grand Duke Constantine" 2 False


franz_II : Commander
franz_II =
    Commander Health "Franz II" 1 False


leiberich : Commander
leiberich =
    Commander Speed "Leiberich" 2 False


prince_Liechtenstein : Commander
prince_Liechtenstein =
    Commander Strength "Prince of Liechtenstein" 1 False


miloradovich : Commander
miloradovich =
    Commander Strength "Miloradovich" 2 False


langeron : Commander
langeron =
    Commander Speed "Langeron" 1 False



-- level 3:


wellington : Commander
wellington =
    Commander Health "Duke of Wellington" 3 False


blucher : Commander
blucher =
    Commander Speed "Blücher" 3 False


gneisenau : Commander
gneisenau =
    Commander Strength "Gneisenau" 2 False


paget : Commander
paget =
    Commander Strength "Paget" 2 False


hill : Commander
hill =
    Commander Health "Hill" 2 False


picton : Commander
picton =
    Commander Strength "Picton" 2 False


anti_france_commander : Int -> List Commander
anti_france_commander int =
    case int of
        1 ->
            [ zach, ott, melas ]

        2 ->
            [ kutuzov, bagration, alexander_I, constantine, franz_II, prince_Liechtenstein, miloradovich, langeron, leiberich ]

        3 ->
            [ wellington, gneisenau, blucher, paget, hill, picton ]

        _ ->
            []

{-| Check whether a given commander is still unassigned-}
is_not_member : Commander -> List Commander -> Bool
is_not_member commander list_commander =
    not (List.member commander list_commander)



-- update : Msg -> List Div -> Commander -> (Commander , List Div )
-- update msg army commander =
--     case msg of
--         Tick elapsed ->
--             let
--                 (commanded, rest) = List.partition (\{number}-> number == commander.number_div) army
--                 n_army =
--                     case commanded of
--                         x::xs -> List.sortBy .number <| (boost_div x commander)::rest
--                         [] -> rest
--             in
--             ( commander, n_army )
--         _ -> ( commander, army )
-- boost_div : Div -> Commander -> Div
-- boost_div div commander =
--     case commander.boost of
--         Health ->
--             boost_health div
--         Strength ->
--             boost_strength div
--         Speed -> boost_speed div
-- boost_health : Div -> Div
-- boost_health div =
--     let
--         increase =
--             if div.hp >= 1000 then  -- this health cap may be too low
--                 0
--             else
--                 5
--     in
--     { div | hp = div.hp + increase}
-- boost_strength : Div -> Div --needs to be implemented
-- boost_strength div =
--     div
-- boost_speed : Div -> Div -- needs to be implemented
-- boost_speed div =
--     div
