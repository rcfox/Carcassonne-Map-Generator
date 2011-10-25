#!/usr/bin/perl
use 5.012_000;
use strict;
use warnings;
use GD;

sub draw_city
{
	my ($x,$y,$img,$size,$direction,$colour) = @_;
	$x *= $size;
	$y *= $size;
	my $poly = new GD::Polygon();
	my $factor = 4;
	given($direction) {
		when(1) { # left
			$poly->addPt($x,$y);
			$poly->addPt($x+$size/$factor,$y+$size/$factor);
			$poly->addPt($x+$size/$factor,$y+$size*($factor-1)/$factor);
			$poly->addPt($x,$y+$size-1);
		}
		when(2) { # right
			$poly->addPt($x+$size-1,$y);
			$poly->addPt($x+$size*($factor-1)/$factor,$y+$size/$factor);
			$poly->addPt($x+$size*($factor-1)/$factor,$y+$size*($factor-1)/$factor);
			$poly->addPt($x+$size-1,$y+$size-1);
		}
		when(3) { # top
			$poly->addPt($x,$y);
			$poly->addPt($x+$size/$factor,$y+$size/$factor);
			$poly->addPt($x+$size*($factor-1)/$factor,$y+$size/$factor);
			$poly->addPt($x+$size-1,$y);
		}
		when(4) { # bottom
			$poly->addPt($x,$y+$size-1);
			$poly->addPt($x+$size/$factor,$y+$size*($factor-1)/$factor);
			$poly->addPt($x+$size*($factor-1)/$factor,$y+$size*($factor-1)/$factor);
			$poly->addPt($x+$size-1,$y+$size-1);
		}
		when(5) { # center
			$poly->addPt($x+$size/$factor,$y+$size/$factor);
			$poly->addPt($x+$size/$factor,$y+$size*($factor-1)/$factor);
			$poly->addPt($x+$size*($factor-1)/$factor,$y+$size*($factor-1)/$factor);
			$poly->addPt($x+$size*($factor-1)/$factor,$y+$size/$factor);
		}
	}
	$img->filledPolygon($poly,$colour);
}

sub draw_road
{
	my ($x,$y,$img,$size,$direction,$colour) = @_;
	$x *= $size;
	$y *= $size;
	my $factor = 10;
	given($direction) {
		when(1) { # left
			$img->filledRectangle($x,$y+$size/2-$size/$factor,
			                      $x+$size/2,$y+$size/2+$size/$factor,
			                      $colour);
		}
		when(2) { # right
			$img->filledRectangle($x+$size-1,$y+$size/2+$size/$factor,
			                      $x+$size/2,$y+$size/2-$size/$factor,
			                      $colour);
		}
		when(3) { # top
			$img->filledRectangle($x+$size/2-$size/$factor,$y,
			                      $x+$size/2+$size/$factor,$y+$size/2,
			                      $colour);
		}
		when(4) { # bottom
			$img->filledRectangle($x+$size/2-$size/$factor,$y+$size-1,
			                      $x+$size/2+$size/$factor,$y+$size/2,
			                      $colour);
		}
		when(5) { # center
			$img->filledRectangle($x+$size/2-$size/$factor,$y+$size/2-$size/$factor,
			                      $x+$size/2+$size/$factor,$y+$size/2+$size/$factor,
			                      $colour);
		}
	}
}

my $tile_size = 64;

# TODO: Make this non-hardcoded...
my $rows = 7;
my $cols = 7;
my $tileset = new GD::Image($tile_size*$cols,$tile_size*$rows);
my $grass_c = $tileset->colorResolve(0,200,0);
my $road_c = $tileset->colorResolve(200,200,200);
my $city_c = $tileset->colorResolve(150,50,50);

$tileset->filledRectangle(0,0,$tile_size*10,$tile_size*3,$grass_c);

say STDERR "tileset($cols,$rows).";

my $i = 0;
while(<>)
{
	if(/tile\((.+)\)/)
	{
		say STDERR "tile_type($i,$1).";
		my $x = ($i % $cols);
		my $y = int($i/$cols);
		my @types = split /,/,$1;
		my $num_cities = 0;
		for(0..3) {
			++$num_cities if($types[$_] ~~ "city");
			draw_city($x,$y,$tileset,$tile_size,$_+1,$city_c) if($types[$_] ~~ "city");
			draw_road($x,$y,$tileset,$tile_size,$_+1,$road_c) if($types[$_] ~~ "road");
		}
		draw_city($x,$y,$tileset,$tile_size,5,$city_c) if ($num_cities > 2);
		++$i;		
	}
}
--$i;
say STDERR "id(0..$i).";

print $tileset->png;
