#!/bin/sh

clingo 0 tileset.ansp | ./tileset.pl > tiles.png 2> tile_data.ansp
