#!/usr/bin/env perl
use strict;
use warnings;
use 5.010;
use utf8;

use Data::Dumper;
use List::Util qw(first);
use Test::More tests => 17;

BEGIN {
	use_ok('Travel::Status::DE::URA');
}
require_ok('Travel::Status::DE::URA');

my ($s, @results);

$s = Travel::Status::DE::URA->new(
	ura_base  => 'file:t/in',
	ura_version => 1,
	datetime  => DateTime->new(
		year   => 2013,
		month  => 12,
		day    => 23,
		hour   => 12,
		minute => 42,
		time_zone => 'Europe/Berlin'
	),
	hide_past => 0,
	calculate_routes => 1,
);

@results = $s->results(stop => 'Kohlscheid Bahnhof');

# results[0]: "Kohlscheid Bahnhof","210717","34","34",1,"Kohlscheid Bahnhof","586"

is(scalar $results[0]->route_post, 5, '->route_post has four elements');

is_deeply([$results[0]->route_pre], [], '->route_pre (empty)');
is(($results[0]->route_post)[0]->time, '12:54:12', '->route_post[0]->time');
is(($results[0]->route_post)[0]->date, '23.12.2013', '->route_post[0]->date');
isa_ok(($results[0]->route_post)[0]->datetime, 'DateTime', '->route_post[0]->datetime isa DateTime');
is(($results[0]->route_post)[0]->datetime->strftime('%Y%m%d%H%M%S'), '20131223125412',
	'->route_post[0]->datetime is correct date');
is(($results[0]->route_post)[0]->name, 'Kämpchen', '->route_post[0]->name');

is(($results[0]->route_post)[1]->time, '12:54:53', '->route_post[1]->time');
is(($results[0]->route_post)[1]->date, '23.12.2013', '->route_post[1]->date');
is(($results[0]->route_post)[1]->name, 'Kircheichstraße', '->route_post[1]->name');

is(($results[0]->route_post)[2]->time, '12:56:13', '->route_post[2]->time');
is(($results[0]->route_post)[2]->date, '23.12.2013', '->route_post[2]->date');
is(($results[0]->route_post)[2]->name, 'Gesundheitsamt', '->route_post[2]->name');

is(($results[0]->route_post)[0]->TO_JSON->{datetime}, ($results[0]->route_post)[0]->datetime, 'TO_JSON.datetime');
is(($results[0]->route_post)[0]->TO_JSON->{name}, ($results[0]->route_post)[0]->name, 'TO_JSON.name');
