module Sight exposing (..)

import Map exposing (..)
import Model exposing (..) 

import Block exposing (Block)
import General exposing (sight_range)

get_visible_pos : Pos -> Array(Array Block) -> Array (Array Block) 
get_visible_pos visible block = 
    if (visible) then  
        {block| visible = OnSight} 
    else 
        {block| visible = OffSight}

