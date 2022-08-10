module Level2 exposing (..)
import Block exposing (Block)
import Array exposing (Array)
import General exposing (..)

player_base : Offset
player_base = ( 3, 1 )

enemy_base : List Offset
enemy_base = [(11, 11)]


block_ls : Array ( Array Block )
block_ls =
    Array.fromList
    [Array.fromList
    [Block.init (0, 0) Plain France
    , Block.init (0, 1) Plain France
    , Block.init (0, 2) Plain France
    , Block.init (0, 3) Plain France
    , Block.init (0, 4) Plain France
    , Block.init (0, 5) Plain France
    , Block.init (0, 6) Plain France
    , Block.init (0, 7) Plain France
    , Block.init (0, 8) Plain France
    , Block.init (0, 9) Plain France
    , Block.init (0, 10) Plain Austria
    , Block.init (0, 11) Plain Austria
    , Block.init (0, 12) Plain Austria
    , Block.init (0, 13) Forest Austria
    , Block.init (0, 14) Forest Austria
    , Block.init (0, 15) Forest Russia
    , Block.init (0, 16) Forest Russia
    , Block.init (0, 17) Plain Russia
    , Block.init (0, 18) Plain Russia
    , Block.init (0, 19) Plain Austria
    , Block.init (0, 20) Plain Austria
    , Block.init (0, 21) Plain Austria
    , Block.init (0, 22) Plain Austria
    , Block.init (0, 23) Plain Austria
    , Block.init (0, 24) Plain Austria
    , Block.init (0, 25) Plain Austria
    , Block.init (0, 26) Plain Austria
    , Block.init (0, 27) Plain Austria
    , Block.init (0, 28) Plain Russia
    , Block.init (0, 29) Plain Russia
    ]
    , Array.fromList
    [Block.init (1, 0) Plain France
    , Block.init (1, 1) Plain France
    , Block.init (1, 2) Plain France
    , Block.init (1, 3) Plain France
    , Block.init (1, 4) Plain France
    , Block.init (1, 5) Plain France
    , Block.init (1, 6) Plain France
    , Block.init (1, 7) Plain France
    , Block.init (1, 8) Plain France
    , Block.init (1, 9) Plain France
    , Block.init (1, 10) Plain Austria
    , Block.init (1, 11) Plain Austria
    , Block.init (1, 12) Forest Austria
    , Block.init (1, 13) Forest Austria
    , Block.init (1, 14) Forest Austria
    , Block.init (1, 15) Forest Russia
    , Block.init (1, 16) Forest Russia
    , Block.init (1, 17) Plain Russia
    , Block.init (1, 18) Plain Russia
    , Block.init (1, 19) Plain Austria
    , Block.init (1, 20) Plain Austria
    , Block.init (1, 21) Plain Austria
    , Block.init (1, 22) Plain Austria
    , Block.init (1, 23) Plain Austria
    , Block.init (1, 24) Plain Austria
    , Block.init (1, 25) Plain Austria
    , Block.init (1, 26) Plain Austria
    , Block.init (1, 27) Plain Austria
    , Block.init (1, 28) Plain Russia
    , Block.init (1, 29) Plain Russia
    ]
    , Array.fromList
    [Block.init (2, 0) Plain France
    , Block.init (2, 1) Plain France
    , Block.init (2, 2) Plain France
    , Block.init (2, 3) Plain France
    , Block.init (2, 4) Plain France
    , Block.init (2, 5) Plain France
    , Block.init (2, 6) Plain France
    , Block.init (2, 7) Plain France
    , Block.init (2, 8) Plain France
    , Block.init (2, 9) Plain France
    , Block.init (2, 10) Plain Austria
    , Block.init (2, 11) Plain Austria
    , Block.init (2, 12) Forest Austria
    , Block.init (2, 13) Mountain Austria
    , Block.init (2, 14) Mountain Austria
    , Block.init (2, 15) Forest Russia
    , Block.init (2, 16) Forest Russia
    , Block.init (2, 17) Plain Russia
    , Block.init (2, 18) Plain Russia
    , Block.init (2, 19) Plain Austria
    , Block.init (2, 20) Forest Austria
    , Block.init (2, 21) Plain Austria
    , Block.init (2, 22) Plain Austria
    , Block.init (2, 23) Plain Austria
    , Block.init (2, 24) Plain Austria
    , Block.init (2, 25) Plain Austria
    , Block.init (2, 26) Plain Austria
    , Block.init (2, 27) Plain Austria
    , Block.init (2, 28) Plain Russia
    , Block.init (2, 29) Plain Russia
    ]
    , Array.fromList
    [Block.init (3, 0) Plain France
    , Block.init (3, 1) Base France
    , Block.init (3, 2) Plain France
    , Block.init (3, 3) Plain France
    , Block.init (3, 4) Plain France
    , Block.init (3, 5) Plain France
    , Block.init (3, 6) Plain France
    , Block.init (3, 7) Plain France
    , Block.init (3, 8) Plain France
    , Block.init (3, 9) Plain France
    , Block.init (3, 10) Forest Austria
    , Block.init (3, 11) Forest Austria
    , Block.init (3, 12) Mountain Austria
    , Block.init (3, 13) Mountain Austria
    , Block.init (3, 14) Mountain Austria
    , Block.init (3, 15) Mountain Russia
    , Block.init (3, 16) Forest Russia
    , Block.init (3, 17) Forest Russia
    , Block.init (3, 18) Plain Russia
    , Block.init (3, 19) Plain Austria
    , Block.init (3, 20) Forest Austria
    , Block.init (3, 21) Forest Austria
    , Block.init (3, 22) Plain Austria
    , Block.init (3, 23) Plain Austria
    , Block.init (3, 24) Plain Austria
    , Block.init (3, 25) Plain Austria
    , Block.init (3, 26) Plain Austria
    , Block.init (3, 27) Plain Austria
    , Block.init (3, 28) Plain Russia
    , Block.init (3, 29) Plain Russia
    ]
    , Array.fromList
    [Block.init (4, 0) Plain France
    , Block.init (4, 1) Plain France
    , Block.init (4, 2) Plain France
    , Block.init (4, 3) Plain France
    , Block.init (4, 4) Plain France
    , Block.init (4, 5) Plain France
    , Block.init (4, 6) Plain France
    , Block.init (4, 7) Plain France
    , Block.init (4, 8) Plain France
    , Block.init (4, 9) Plain France
    , Block.init (4, 10) Forest Austria
    , Block.init (4, 11) Forest Austria
    , Block.init (4, 12) Mountain Austria
    , Block.init (4, 13) Mountain Austria
    , Block.init (4, 14) Mountain Austria
    , Block.init (4, 15) Mountain Russia
    , Block.init (4, 16) Forest Russia
    , Block.init (4, 17) Forest Russia
    , Block.init (4, 18) Plain Russia
    , Block.init (4, 19) Plain Austria
    , Block.init (4, 20) Forest Austria
    , Block.init (4, 21) Forest Austria
    , Block.init (4, 22) Plain Austria
    , Block.init (4, 23) Plain Austria
    , Block.init (4, 24) Plain Austria
    , Block.init (4, 25) Plain Austria
    , Block.init (4, 26) Plain Austria
    , Block.init (4, 27) Plain Austria
    , Block.init (4, 28) Plain Russia
    , Block.init (4, 29) Plain Russia
    ]
    , Array.fromList
    [Block.init (5, 0) Plain France
    , Block.init (5, 1) Plain France
    , Block.init (5, 2) Plain France
    , Block.init (5, 3) Plain France
    , Block.init (5, 4) Plain France
    , Block.init (5, 5) Plain France
    , Block.init (5, 6) Plain France
    , Block.init (5, 7) Plain France
    , Block.init (5, 8) Plain France
    , Block.init (5, 9) Plain France
    , Block.init (5, 10) Forest Austria
    , Block.init (5, 11) Mountain Austria
    , Block.init (5, 12) Mountain Austria
    , Block.init (5, 13) Mountain Austria
    , Block.init (5, 14) Mountain Austria
    , Block.init (5, 15) Mountain Russia
    , Block.init (5, 16) Forest Russia
    , Block.init (5, 17) Forest Russia
    , Block.init (5, 18) Plain Russia
    , Block.init (5, 19) Plain Austria
    , Block.init (5, 20) Forest Austria
    , Block.init (5, 21) Forest Austria
    , Block.init (5, 22) Plain Austria
    , Block.init (5, 23) Plain Austria
    , Block.init (5, 24) Plain Austria
    , Block.init (5, 25) Plain Austria
    , Block.init (5, 26) Plain Austria
    , Block.init (5, 27) Plain Austria
    , Block.init (5, 28) Plain Russia
    , Block.init (5, 29) Plain Russia
    ]
    , Array.fromList
    [Block.init (6, 0) Plain France
    , Block.init (6, 1) Plain France
    , Block.init (6, 2) Plain France
    , Block.init (6, 3) Plain France
    , Block.init (6, 4) Plain France
    , Block.init (6, 5) Plain France
    , Block.init (6, 6) Plain France
    , Block.init (6, 7) Plain France
    , Block.init (6, 8) Plain France
    , Block.init (6, 9) Plain France
    , Block.init (6, 10) Forest Austria
    , Block.init (6, 11) Mountain Austria
    , Block.init (6, 12) Mountain Austria
    , Block.init (6, 13) Mountain Austria
    , Block.init (6, 14) Mountain Austria
    , Block.init (6, 15) Forest Russia
    , Block.init (6, 16) Forest Russia
    , Block.init (6, 17) Forest Russia
    , Block.init (6, 18) Plain Russia
    , Block.init (6, 19) Plain Austria
    , Block.init (6, 20) Forest Austria
    , Block.init (6, 21) Forest Austria
    , Block.init (6, 22) Forest Austria
    , Block.init (6, 23) Forest Austria
    , Block.init (6, 24) Plain Austria
    , Block.init (6, 25) Plain Austria
    , Block.init (6, 26) Plain Austria
    , Block.init (6, 27) Plain Austria
    , Block.init (6, 28) Plain Russia
    , Block.init (6, 29) Plain Russia
    ]
    , Array.fromList
    [Block.init (7, 0) Plain France
    , Block.init (7, 1) Plain France
    , Block.init (7, 2) Plain France
    , Block.init (7, 3) Plain France
    , Block.init (7, 4) Plain France
    , Block.init (7, 5) Plain France
    , Block.init (7, 6) Plain France
    , Block.init (7, 7) Plain France
    , Block.init (7, 8) Plain France
    , Block.init (7, 9) Plain France
    , Block.init (7, 10) Forest Austria
    , Block.init (7, 11) Mountain Austria
    , Block.init (7, 12) Mountain Austria
    , Block.init (7, 13) Mountain Austria
    , Block.init (7, 14) Mountain Austria
    , Block.init (7, 15) Forest Russia
    , Block.init (7, 16) Forest Russia
    , Block.init (7, 17) Forest Russia
    , Block.init (7, 18) Plain Russia
    , Block.init (7, 19) Plain Austria
    , Block.init (7, 20) Forest Austria
    , Block.init (7, 21) Forest Austria
    , Block.init (7, 22) Forest Austria
    , Block.init (7, 23) Forest Austria
    , Block.init (7, 24) Plain Austria
    , Block.init (7, 25) Plain Austria
    , Block.init (7, 26) Plain Austria
    , Block.init (7, 27) Plain Austria
    , Block.init (7, 28) Plain Russia
    , Block.init (7, 29) Plain Russia
    ]
    , Array.fromList
    [Block.init (8, 0) Plain France
    , Block.init (8, 1) Plain France
    , Block.init (8, 2) Plain France
    , Block.init (8, 3) Plain France
    , Block.init (8, 4) Plain France
    , Block.init (8, 5) Plain France
    , Block.init (8, 6) Plain France
    , Block.init (8, 7) Plain France
    , Block.init (8, 8) Plain France
    , Block.init (8, 9) Plain France
    , Block.init (8, 10) Forest Austria
    , Block.init (8, 11) Mountain Austria
    , Block.init (8, 12) Mountain Austria
    , Block.init (8, 13) Mountain Austria
    , Block.init (8, 14) Plain Austria
    , Block.init (8, 15) Plain Russia
    , Block.init (8, 16) Plain Russia
    , Block.init (8, 17) Forest Russia
    , Block.init (8, 18) Plain Russia
    , Block.init (8, 19) Plain Austria
    , Block.init (8, 20) Forest Austria
    , Block.init (8, 21) Forest Austria
    , Block.init (8, 22) Forest Austria
    , Block.init (8, 23) Forest Austria
    , Block.init (8, 24) Plain Austria
    , Block.init (8, 25) Plain Austria
    , Block.init (8, 26) Plain Austria
    , Block.init (8, 27) Plain Austria
    , Block.init (8, 28) Plain Russia
    , Block.init (8, 29) Plain Russia
    ]
    , Array.fromList
    [Block.init (9, 0) Plain France
    , Block.init (9, 1) Plain France
    , Block.init (9, 2) Plain France
    , Block.init (9, 3) Plain France
    , Block.init (9, 4) Plain France
    , Block.init (9, 5) Plain France
    , Block.init (9, 6) Plain France
    , Block.init (9, 7) Forest France
    , Block.init (9, 8) Forest France
    , Block.init (9, 9) Forest France
    , Block.init (9, 10) Forest Austria
    , Block.init (9, 11) Mountain Austria
    , Block.init (9, 12) Mountain Austria
    , Block.init (9, 13) Mountain Austria
    , Block.init (9, 14) Plain Austria
    , Block.init (9, 15) Plain Russia
    , Block.init (9, 16) Plain Russia
    , Block.init (9, 17) Forest Russia
    , Block.init (9, 18) Plain Russia
    , Block.init (9, 19) Plain Austria
    , Block.init (9, 20) Forest Austria
    , Block.init (9, 21) Forest Austria
    , Block.init (9, 22) Forest Austria
    , Block.init (9, 23) Forest Austria
    , Block.init (9, 24) Plain Austria
    , Block.init (9, 25) Plain Austria
    , Block.init (9, 26) Plain Austria
    , Block.init (9, 27) Plain Austria
    , Block.init (9, 28) Plain Russia
    , Block.init (9, 29) Plain Russia
    ]
    , Array.fromList
    [Block.init (10, 0) Plain France
    , Block.init (10, 1) Plain France
    , Block.init (10, 2) Plain France
    , Block.init (10, 3) Plain France
    , Block.init (10, 4) Plain France
    , Block.init (10, 5) Plain France
    , Block.init (10, 6) Plain France
    , Block.init (10, 7) Forest France
    , Block.init (10, 8) Forest France
    , Block.init (10, 9) Forest France
    , Block.init (10, 10) Forest Austria
    , Block.init (10, 11) Mountain Austria
    , Block.init (10, 12) Mountain Austria
    , Block.init (10, 13) Mountain Austria
    , Block.init (10, 14) Plain Austria
    , Block.init (10, 15) Plain Russia
    , Block.init (10, 16) Plain Russia
    , Block.init (10, 17) Plain Russia
    , Block.init (10, 18) Plain Russia
    , Block.init (10, 19) Plain Austria
    , Block.init (10, 20) Forest Austria
    , Block.init (10, 21) Forest Austria
    , Block.init (10, 22) Forest Austria
    , Block.init (10, 23) Forest Austria
    , Block.init (10, 24) Plain Austria
    , Block.init (10, 25) Plain Austria
    , Block.init (10, 26) Plain Austria
    , Block.init (10, 27) Plain Austria
    , Block.init (10, 28) Plain Russia
    , Block.init (10, 29) Plain Russia
    ]
    , Array.fromList
    [Block.init (11, 0) Plain France
    , Block.init (11, 1) Plain France
    , Block.init (11, 2) Plain France
    , Block.init (11, 3) Plain France
    , Block.init (11, 4) Plain France
    , Block.init (11, 5) Plain France
    , Block.init (11, 6) Plain France
    , Block.init (11, 7) Forest France
    , Block.init (11, 8) Forest France
    , Block.init (11, 9) Forest France
    , Block.init (11, 10) Mountain Austria
    , Block.init (11, 11) Goal Austria
    , Block.init (11, 12) Mountain Austria
    , Block.init (11, 13) Mountain Austria
    , Block.init (11, 14) Plain Austria
    , Block.init (11, 15) Plain Austria
    , Block.init (11, 16) Plain Austria
    , Block.init (11, 17) Plain Austria
    , Block.init (11, 18) Plain Austria
    , Block.init (11, 19) Plain Austria
    , Block.init (11, 20) Forest Austria
    , Block.init (11, 21) Forest Austria
    , Block.init (11, 22) Forest Austria
    , Block.init (11, 23) Forest Austria
    , Block.init (11, 24) Plain Austria
    , Block.init (11, 25) Plain Austria
    , Block.init (11, 26) Plain Austria
    , Block.init (11, 27) Plain Austria
    , Block.init (11, 28) Plain Russia
    , Block.init (11, 29) Plain Russia
    ]
    , Array.fromList
    [Block.init (12, 0) Plain France
    , Block.init (12, 1) Plain France
    , Block.init (12, 2) Plain France
    , Block.init (12, 3) Plain France
    , Block.init (12, 4) Plain France
    , Block.init (12, 5) Plain France
    , Block.init (12, 6) Plain France
    , Block.init (12, 7) Forest France
    , Block.init (12, 8) Forest France
    , Block.init (12, 9) Forest Austria
    , Block.init (12, 10) Mountain Austria
    , Block.init (12, 11) Mountain Austria
    , Block.init (12, 12) Mountain Austria
    , Block.init (12, 13) Mountain Austria
    , Block.init (12, 14) Plain Austria
    , Block.init (12, 15) Plain Austria
    , Block.init (12, 16) Plain Austria
    , Block.init (12, 17) Plain Austria
    , Block.init (12, 18) Plain Austria
    , Block.init (12, 19) Plain Austria
    , Block.init (12, 20) Forest Austria
    , Block.init (12, 21) Forest Austria
    , Block.init (12, 22) Plain Austria
    , Block.init (12, 23) Forest Austria
    , Block.init (12, 24) Plain Austria
    , Block.init (12, 25) Plain Austria
    , Block.init (12, 26) Plain Austria
    , Block.init (12, 27) Plain Austria
    , Block.init (12, 28) Plain Russia
    , Block.init (12, 29) Plain Russia
    ]
    , Array.fromList
    [Block.init (13, 0) Plain France
    , Block.init (13, 1) Plain France
    , Block.init (13, 2) Plain France
    , Block.init (13, 3) Plain France
    , Block.init (13, 4) Plain France
    , Block.init (13, 5) Plain France
    , Block.init (13, 6) Plain France
    , Block.init (13, 7) Forest France
    , Block.init (13, 8) Forest France
    , Block.init (13, 9) Forest Austria
    , Block.init (13, 10) Mountain Austria
    , Block.init (13, 11) Mountain Austria
    , Block.init (13, 12) Mountain Austria
    , Block.init (13, 13) Plain Austria
    , Block.init (13, 14) Plain Austria
    , Block.init (13, 15) Plain Austria
    , Block.init (13, 16) Plain Austria
    , Block.init (13, 17) Plain Austria
    , Block.init (13, 18) Plain Austria
    , Block.init (13, 19) Plain Austria
    , Block.init (13, 20) Forest Austria
    , Block.init (13, 21) Plain Austria
    , Block.init (13, 22) Plain Austria
    , Block.init (13, 23) Plain Austria
    , Block.init (13, 24) Plain Austria
    , Block.init (13, 25) Plain Austria
    , Block.init (13, 26) Plain Austria
    , Block.init (13, 27) Plain Austria
    , Block.init (13, 28) Plain Russia
    , Block.init (13, 29) Plain Russia
    ]
    , Array.fromList
    [Block.init (14, 0) Plain France
    , Block.init (14, 1) Plain France
    , Block.init (14, 2) Plain France
    , Block.init (14, 3) Plain France
    , Block.init (14, 4) Plain France
    , Block.init (14, 5) Plain France
    , Block.init (14, 6) Plain France
    , Block.init (14, 7) Plain France
    , Block.init (14, 8) Plain France
    , Block.init (14, 9) Mountain Austria
    , Block.init (14, 10) Mountain Austria
    , Block.init (14, 11) Mountain Austria
    , Block.init (14, 12) Mountain Austria
    , Block.init (14, 13) Plain Austria
    , Block.init (14, 14) Plain Austria
    , Block.init (14, 15) Plain Austria
    , Block.init (14, 16) Plain Austria
    , Block.init (14, 17) Plain Austria
    , Block.init (14, 18) Plain Austria
    , Block.init (14, 19) Plain Austria
    , Block.init (14, 20) Forest Austria
    , Block.init (14, 21) Plain Austria
    , Block.init (14, 22) Plain Austria
    , Block.init (14, 23) Plain Austria
    , Block.init (14, 24) Plain Austria
    , Block.init (14, 25) Plain Austria
    , Block.init (14, 26) Plain Austria
    , Block.init (14, 27) Plain Austria
    , Block.init (14, 28) Plain Russia
    , Block.init (14, 29) Plain Russia
    ]
    , Array.fromList
    [Block.init (15, 0) Plain France
    , Block.init (15, 1) Plain France
    , Block.init (15, 2) Plain France
    , Block.init (15, 3) Plain France
    , Block.init (15, 4) Plain France
    , Block.init (15, 5) Plain France
    , Block.init (15, 6) Plain France
    , Block.init (15, 7) Plain France
    , Block.init (15, 8) Plain France
    , Block.init (15, 9) Mountain Austria
    , Block.init (15, 10) Mountain Austria
    , Block.init (15, 11) Plain Austria
    , Block.init (15, 12) Plain Austria
    , Block.init (15, 13) Plain Austria
    , Block.init (15, 14) Plain Austria
    , Block.init (15, 15) Plain Austria
    , Block.init (15, 16) Plain Austria
    , Block.init (15, 17) Plain Austria
    , Block.init (15, 18) Plain Austria
    , Block.init (15, 19) Plain Austria
    , Block.init (15, 20) Forest Austria
    , Block.init (15, 21) Plain Austria
    , Block.init (15, 22) Plain Austria
    , Block.init (15, 23) Plain Austria
    , Block.init (15, 24) Plain Russia
    , Block.init (15, 25) Plain Russia
    , Block.init (15, 26) Plain Russia
    , Block.init (15, 27) Goal Russia
    , Block.init (15, 28) Plain Russia
    , Block.init (15, 29) Plain Russia
    ]
    , Array.fromList
    [Block.init (16, 0) Plain France
    , Block.init (16, 1) Plain France
    , Block.init (16, 2) Plain France
    , Block.init (16, 3) Plain France
    , Block.init (16, 4) Plain France
    , Block.init (16, 5) Plain France
    , Block.init (16, 6) Plain France
    , Block.init (16, 7) Plain France
    , Block.init (16, 8) Plain France
    , Block.init (16, 9) Plain Austria
    , Block.init (16, 10) Mountain Austria
    , Block.init (16, 11) Plain Austria
    , Block.init (16, 12) Plain Austria
    , Block.init (16, 13) Plain Austria
    , Block.init (16, 14) Plain Austria
    , Block.init (16, 15) Plain Austria
    , Block.init (16, 16) Plain Austria
    , Block.init (16, 17) Plain Austria
    , Block.init (16, 18) Plain Austria
    , Block.init (16, 19) Plain Austria
    , Block.init (16, 20) Plain Austria
    , Block.init (16, 21) Plain Austria
    , Block.init (16, 22) Plain Austria
    , Block.init (16, 23) Plain Austria
    , Block.init (16, 24) Plain Russia
    , Block.init (16, 25) Plain Russia
    , Block.init (16, 26) Plain Russia
    , Block.init (16, 27) Plain Russia
    , Block.init (16, 28) Plain Russia
    , Block.init (16, 29) Plain Russia
    ]
    , Array.fromList
    [Block.init (17, 0) Plain France
    , Block.init (17, 1) Plain France
    , Block.init (17, 2) Plain France
    , Block.init (17, 3) Plain France
    , Block.init (17, 4) Plain France
    , Block.init (17, 5) Plain France
    , Block.init (17, 6) Plain France
    , Block.init (17, 7) Plain France
    , Block.init (17, 8) Plain France
    , Block.init (17, 9) Plain Austria
    , Block.init (17, 10) Mountain Austria
    , Block.init (17, 11) Plain Austria
    , Block.init (17, 12) Plain Austria
    , Block.init (17, 13) Plain Austria
    , Block.init (17, 14) Plain Austria
    , Block.init (17, 15) Plain Austria
    , Block.init (17, 16) Plain Austria
    , Block.init (17, 17) Plain Austria
    , Block.init (17, 18) Plain Austria
    , Block.init (17, 19) Plain Austria
    , Block.init (17, 20) Plain Austria
    , Block.init (17, 21) Plain Austria
    , Block.init (17, 22) Plain Austria
    , Block.init (17, 23) Plain Austria
    , Block.init (17, 24) Plain Russia
    , Block.init (17, 25) Plain Russia
    , Block.init (17, 26) Plain Russia
    , Block.init (17, 27) Plain Russia
    , Block.init (17, 28) Plain Russia
    , Block.init (17, 29) Plain Russia
    ]
    , Array.fromList
    [Block.init (18, 0) Plain France
    , Block.init (18, 1) Plain France
    , Block.init (18, 2) Plain France
    , Block.init (18, 3) Plain France
    , Block.init (18, 4) Plain France
    , Block.init (18, 5) Plain France
    , Block.init (18, 6) Plain France
    , Block.init (18, 7) Plain France
    , Block.init (18, 8) Plain France
    , Block.init (18, 9) Plain Austria
    , Block.init (18, 10) Plain Austria
    , Block.init (18, 11) Plain Austria
    , Block.init (18, 12) Plain Austria
    , Block.init (18, 13) Plain Austria
    , Block.init (18, 14) Plain Austria
    , Block.init (18, 15) Plain Austria
    , Block.init (18, 16) Plain Austria
    , Block.init (18, 17) Plain Austria
    , Block.init (18, 18) Plain Austria
    , Block.init (18, 19) Plain Austria
    , Block.init (18, 20) Plain Austria
    , Block.init (18, 21) Plain Austria
    , Block.init (18, 22) Plain Austria
    , Block.init (18, 23) Plain Austria
    , Block.init (18, 24) Plain Russia
    , Block.init (18, 25) Plain Russia
    , Block.init (18, 26) Plain Russia
    , Block.init (18, 27) Plain Russia
    , Block.init (18, 28) Plain Russia
    , Block.init (18, 29) Plain Russia
    ]
    , Array.fromList
    [Block.init (19, 0) Plain France
    , Block.init (19, 1) Plain France
    , Block.init (19, 2) Plain France
    , Block.init (19, 3) Plain France
    , Block.init (19, 4) Plain France
    , Block.init (19, 5) Plain France
    , Block.init (19, 6) Plain France
    , Block.init (19, 7) Plain France
    , Block.init (19, 8) Plain France
    , Block.init (19, 9) Plain Austria
    , Block.init (19, 10) Plain Austria
    , Block.init (19, 11) Plain Austria
    , Block.init (19, 12) Plain Austria
    , Block.init (19, 13) Plain Austria
    , Block.init (19, 14) Plain Austria
    , Block.init (19, 15) Plain Austria
    , Block.init (19, 16) Plain Austria
    , Block.init (19, 17) Plain Austria
    , Block.init (19, 18) Plain Austria
    , Block.init (19, 19) Plain Austria
    , Block.init (19, 20) Plain Austria
    , Block.init (19, 21) Plain Austria
    , Block.init (19, 22) Plain Austria
    , Block.init (19, 23) Plain Austria
    , Block.init (19, 24) Plain Russia
    , Block.init (19, 25) Plain Russia
    , Block.init (19, 26) Plain Russia
    , Block.init (19, 27) Plain Russia
    , Block.init (19, 28) Plain Russia
    , Block.init (19, 29) Plain Russia
    ]
    
    ]