#!/usr/bin/perl
use strict;
use warnings;
use GD;

sub get_tile
{
	my $size = shift;
	my $cols = shift;
	my $id = shift;
	my $x = ($id % $cols) * $size;
	my $y = int($id/$cols) * $size;
	return ($x,$y);
}

my $tile_size;
my $tileset_rows;
my $tileset_cols;

my $image_size = 0;
my $highest_dim = 0;
my @map;

<>;
my @lines = split(/ /,<>);
for(@lines)
{
	if(/tileset\((\d+),(\d+)\)/)
	{
		$tileset_cols = $1;
		$tileset_rows = $2;
	}
	if(/dimension\((\d+)\)/)
	{
		my $n = $1;
		$highest_dim = $n if($n > $highest_dim);
	}
	if(/tile\((\d+),(\d+),(\d+)\)/)
	{
		my $x = $1;
		my $y = $2;
		my $tile = $3;
		$map[$x][$y] = $tile;
	}
}

my $tileset = new GD::Image('tiles.png');
$tile_size = $tileset->width/$tileset_cols;
my $img = new GD::Image($tile_size*$highest_dim,$tile_size*$highest_dim);

for(my $y = 0; $y < $highest_dim; ++$y)
{
	for(my $x = 0; $x < $highest_dim; ++$x)
	{
		my ($sx,$sy) = get_tile($tile_size,$tileset_cols,$map[$y][$x]);
		$img->copy($tileset,$x*$tile_size,$y*$tile_size,
		           $sx,$sy,$tile_size,$tile_size);
	}
}
		
print $img->png;
