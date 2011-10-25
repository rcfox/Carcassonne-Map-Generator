# Carcassonne-style Map Generator

<a href="http://i.imgur.com/LBGji.png"><img src="http://i.imgur.com/LBGjis.png" title="Hosted by imgur.com" /></a>

This is a declarative (as opposed to procedural) map generator, using the style of the board game [Carcassonne](http://en.wikipedia.org/wiki/Carcassonne_(board_game)).

This depends on [Clingo](http://potassco.sourceforge.net/#clingo), a tool for Answer Set Programming, and Perl.

There are two aspects to the map generator:

1. Finding an acceptable answer set for the problem.
2. Visualizing the result.

To perform these steps, use the follow command:

    clingo tile_data.ansp rules.ansp | perl visualize.pl > map.png
    
Enjoy!
