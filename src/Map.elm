module Map exposing (..)

import Array exposing (Array)
import Block exposing (Block, error_block, update)
import General exposing (..)
import Set exposing (Set)
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr
import Msg exposing (..)
import Bitwise
import Block exposing (block_in_cur_screen)
import Level1
import Level2
import Level3
import Level4
import File.Download as Download

save_str : String -> Cmd Msg
save_str markdown =
  Download.string "draft.md" "text/markdown" markdown

type alias Map =
    { blocks : Array (Array Block)
    , map_size_arg : MapSizeArg
    , mouse_over_offset : Offset
    }

row_to_string : Array Block -> String
row_to_string row = 
    let
        lst = Array.map Block.block_to_string row
    in
        Array.foldr (++) "" lst

map_to_string : Map -> String
map_to_string map = 
    let
        lst = Array.map row_to_string map.blocks
    in
        Array.foldr (++) "" lst

init : Int -> ( Int, Int ) -> Map
init level size =
    let
        ( nrow, ncol ) =
            size

        {-arr =
            List.map (\x -> get_row x ncol) (List.range 0 (nrow - 1))
                |> Array.fromList -}
        
        arr = 
            if level == 1 then
                Level1.block_ls
                --Array.fromList [ Array.fromList [] ]
            else if level == 2 then
                Level2.block_ls
            else if level == 3 then
                Level3.block_ls
                --Array.fromList [ Array.fromList [] ]
            else if level == 4 then
                Level4.block_ls
            else if level == 5 then
                init_blocks_blank 20 30
            else
                Array.fromList [ Array.fromList [] ]
            
        block_size = 40.0
        position_offset = ( 0.0, 0.0 )
        velocity = 
            ( 0, 0 )
        zoom_velocity = 0.0
        screen_size = ( 0.0, 0.0 ) -- Wait the screen size to be calculated
    in
    Map arr ( MapSizeArg size block_size position_offset velocity zoom_velocity screen_size) ( -1, -1 )

view : Map -> List (Svg Msg)
view map =
    let
        map_size_arg = 
            map.map_size_arg
        nested_terrian =
            Array.map (view_row map_size_arg ViewTerrain) map.blocks
        nested_background =
            Array.map (view_row map_size_arg ViewBackground) map.blocks
        nested_construction = 
            Array.map (view_row map_size_arg ViewConstruction) map.blocks

        block_ls_terrian =
            Array.foldl Array.append Array.empty nested_terrian
        block_ls_background =
            Array.foldl Array.append Array.empty nested_background
        block_ls_construction =
            Array.foldl Array.append Array.empty nested_construction

        terrain_str_ls = List.map terrain_to_string terrain_list
        cons_str_ls = List.map cons_to_string cons_ls
    in
        List.map get_pattern terrain_str_ls
            |> List.append (List.map get_pattern cons_str_ls)
            |> List.append (Array.toList block_ls_construction)
            |> List.append (Array.toList block_ls_terrian)
            |> List.append (Array.toList block_ls_background)



view_row : MapSizeArg -> ViewType -> Array Block -> Array (Svg Msg)
view_row map_size_arg view_type row =
    let
        visible_row = 
            Array.filter ( block_in_cur_screen map_size_arg ) row
        necessary_row = 
            case view_type of
                ViewBackground -> visible_row
                ViewTerrain -> Array.filter ( \x -> x.terrain /= Plain ) visible_row
                ViewConstruction -> Array.filter 
                    ( \x -> case x.construction of
                        Nothing -> False
                        Just _ -> True ) visible_row
    in
        Array.map ( Block.view map_size_arg view_type ) necessary_row


init_blocks_blank : Int -> Int -> Array (Array Block)
init_blocks_blank nrow ncol =
    let
        t_get_row = \x -> get_row x ncol
    in
        (List.map t_get_row (List.range 0 (nrow-1)))
            |> Array.fromList

get_row : Int -> Int -> Array Block
get_row row ncol =
    List.map (\x -> block_terrain_init ( x, row )) (List.range 0 (ncol - 1))
        |> Array.fromList



block_terrain_init : ( Int, Int ) -> Block
block_terrain_init ( col, row ) =
    Block.init ( row, col ) Plain Russia


offset_to_block : Map -> Offset -> Block
offset_to_block map offset =
    let
        ( r, c ) =
            offset
    in
    case Array.get r map.blocks of
        Just row ->
            case Array.get c row of
                Just a ->
                    a

                Nothing ->
                    error_block

        Nothing ->
            error_block


cube_to_block : Map -> Cube -> Block
cube_to_block map cube =
    cube_to_offset cube
        |> offset_to_block map


cube_add : Cube -> Cube -> Cube
cube_add t1 t2 =
    let
        ( x1, y1, z1 ) =
            t1

        ( x2, y2, z2 ) =
            t2
    in
    ( x1 + x2, y1 + y2, z1 + z2 )


get_map_size : Map -> ( Int, Int )
get_map_size map =
    let
        nrow =
            Array.length map.blocks

        ncol =
            case Array.get 0 map.blocks of
                Nothing ->
                    0

                Just a ->
                    Array.length a
    in
    ( nrow, ncol )


is_valid_cube : Map -> Cube -> Bool
is_valid_cube map cube =
    let
        ( mapr, mapc ) =
            get_map_size map

        ( r, c ) =
            cube_to_offset cube
    in
    (r >= 0) && (r < mapr) && (c >= 0) && (c < mapc)


get_neighbours : Map -> Offset -> Set Offset
get_neighbours map offset = 
    offset_to_cube offset
        |> get_neighbours_cube map
        |> Set.map cube_to_offset


get_neighbours_cube : Map -> Cube -> Set Cube
get_neighbours_cube map cube =
        get_cubes_within_n_jumps map cube 1


get_offsets_within_n_jumps : Map -> Offset -> Int -> Set Offset
get_offsets_within_n_jumps map offset jump =
    let
        cube =
            offset_to_cube offset

    in
        get_cubes_within_n_jumps map cube jump
            |> Set.map cube_to_offset

get_offsets_within_range : Map -> Offset -> Int -> Int -> Set Offset
get_offsets_within_range map offset begin end = 
    let
        big_set = 
            get_offsets_within_n_jumps map offset end
        
        small_set = 
            if begin == 0 then
                Set.empty
            else
                get_offsets_within_n_jumps map offset (begin - 1)
    in
        Set.diff big_set small_set


get_cubes_within_n_jumps : Map -> Cube -> Int -> Set Cube
get_cubes_within_n_jumps map cube jump = 
    let 
        dx_ls = 
            List.range (-jump) jump

        cube_ls_nested = 
            List.map ( get_cube_ls_from_dx cube jump ) dx_ls
        
        cube_ls = 
            List.foldl List.append [] cube_ls_nested
    in
        Set.fromList cube_ls
            |> Set.filter (is_valid_cube map)

get_cube_ls_from_dx : Cube -> Int -> Int -> List Cube
get_cube_ls_from_dx cube jump dx = 
    let
        dy_ls = List.range (max (-jump) (-dx-jump)) (min jump (-dx+jump))
    in
        List.map (\dy -> cube_add cube ( dx, dy, -dx-dy )) dy_ls


update : Msg -> Map -> Map
update msg map = 
    let
        old_map_size_arg
            = map.map_size_arg
        zero_v_map_size_org
            = { old_map_size_arg | velocity = ( 0.0, 0.0 ) }
    in
        case msg of
            MouseOverBlock offset ->
                (
                let 
                    nblocks = 
                        Array.map (\x -> Array.map (Block.update msg) x) map.blocks
                in
                    { map | map_size_arg = zero_v_map_size_org, blocks = nblocks, mouse_over_offset = offset }
                )
            MouseOutBlock offset ->
                (
                let 
                    nblocks = 
                        Array.map (\x -> Array.map (Block.update msg) x) map.blocks
                in
                    { map | map_size_arg = zero_v_map_size_org, blocks = nblocks }
                )
            MoveScreen setting_status ->
                ( 
                let 
                    speed = 20.0
                    n_velocity = 
                        case setting_status of
                            Off -> ( 0.0, 0.0 )
                            On dir -> 
                                ( case dir of
                                    Up -> ( 0.0, speed )
                                    Down -> ( 0.0, -speed )
                                    Left -> ( speed, 0.0 )
                                    Right -> ( -speed, 0.0 )
                                )
                    n_map_size_arg = 
                        { old_map_size_arg | velocity = n_velocity }

                in
                    { map | map_size_arg = n_map_size_arg }
                )
            Zoom zoom_type ->
                ( 
                let
                    d_block_size =
                        case zoom_type of 
                            In -> 1.0
                            Out -> -1.0
                    n_block_size = 
                        old_map_size_arg.block_size + d_block_size
                    n_map_size_arg = 
                        { old_map_size_arg | block_size = n_block_size }
                    mouse_over_offset = 
                        map.mouse_over_offset
                    ( o_x, o_y ) = 
                        offset_to_position old_map_size_arg mouse_over_offset
                    ( n_x, n_y ) = 
                        offset_to_position n_map_size_arg mouse_over_offset
                    ( x_off, y_off ) = 
                        old_map_size_arg.position_offset
                    n_position_offset = 
                        ( x_off + o_x - n_x, y_off + o_y - n_y )
                    nn_map_size_arg = 
                        { n_map_size_arg | position_offset = n_position_offset }

                    final_map_size_arg = 
                            case get_valid_map_size_arg nn_map_size_arg of
                                Nothing -> old_map_size_arg
                                Just t -> t
                in
                    { map | map_size_arg = final_map_size_arg }
                )
            Tick elapsed -> 
                (
                let
                    ( vx, vy ) = 
                        map.map_size_arg.velocity
                    ( x_off, y_off ) = 
                        map.map_size_arg.position_offset
                    n_position_offset = 
                        ( x_off + vx, y_off + vy )
                    n_map_size_arg
                        = { old_map_size_arg | position_offset = n_position_offset }
                    -- process screen moving
                    final_map_size_arg = 
                        if map.map_size_arg.velocity == ( 0.0, 0.0 ) then
                            map.map_size_arg
                        else
                            case get_valid_map_size_arg n_map_size_arg of
                                Nothing -> old_map_size_arg
                                Just t -> t
                in
                    { map | map_size_arg = final_map_size_arg }
                )
            GetViewport viewport ->
                let 
                    width = 
                        viewport.scene.width
                    height = 
                        viewport.scene.height
                    n_map_size_arg = 
                        { old_map_size_arg | screen_size = ( width, height ) }
                in
                    { map | map_size_arg = n_map_size_arg }
            
            BlockChangeMsg block_change ->
                let
                    n_blocks = Array.map (\x -> Array.map (Block.update msg) x) map.blocks
                in
                    { map | blocks = n_blocks }
            _ -> 
                map
    

get_visible_pos : Map -> List Offset -> Array(Array Block) -> Array (Array Block) --function that returns the array with visible blocks 
get_visible_pos map player_elem blocks = 
    Array.map (\x-> Array.map (set_block_visibility map player_elem) x ) blocks 

set_block_visibility : Map -> List Offset -> Block -> Block 
set_block_visibility map player_elem block = 
    let
    {-
        within = \x -> Set.member block.offset (get_offsets_within_n_jumps map x sight_range) 
        ls = List.map within player_elem
        visible = List.any (\x->x) ls -}
        visible = (List.length ( List.filter (\x -> (block_in_range map x block)) player_elem )) > 0

    in
    if (visible) then 
        {block| visible = OnSight }
    else 
        {block| visible = OffSight }

block_in_range : Map -> Offset -> Block -> Bool 
block_in_range map offset block = 
    Set.member block.offset (get_offsets_within_n_jumps map offset sight_range) 


map_update_sight : Map -> List Offset -> Map --function that updates sight
map_update_sight map player_elem = 
    let
        new_blocks = get_visible_pos map player_elem map.blocks 
    in 
    {map| blocks = new_blocks }

blocks_to_list : Array ( Array Block ) -> List Block -- function that transforms the block array to list 
blocks_to_list blocks = 
    Array.map ( \x -> Array.toList x) blocks 
        |> Array.foldr (++) [] 


build_on_map : (Construction, Offset) -> Map -> Map 
build_on_map (cons, offset) map = 
    let
        n_blocks = 
            Array.map (\x -> Array.map (Block.build_block cons offset) x) map.blocks
    in
        { map | blocks = n_blocks }
