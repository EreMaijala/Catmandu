#!/usr/bin/env perl

use utf8;
use strict;
use warnings;
use Test::More;
use Test::Exception;

my $pkg;

BEGIN {
    $pkg = 'Catmandu::Fix::import';
    use_ok $pkg;
}

my $json = '[{"new": 1}]';

is_deeply $pkg->new(var => JSON => file => \$json)->fix({var => {old => 1}}),
    {var => {new => 1}};

$json = '[]';

is_deeply $pkg->new(var => JSON => file => \$json)->fix({var => {old => 1}}),
    {var => {old => 1}};
is_deeply $pkg->new(var => JSON => file => \$json, delete => 1)
    ->fix({var => {old => 1}}), {};

is_deeply $pkg->new(var => HTTPError => code => 404, ignore_404 => 1)
    ->fix({var => {old => 1}}), {var => {old => 1}};
is_deeply $pkg->new(var => HTTPError => code => 404, ignore_404 => 1,
    delete => 1)->fix({var => {old => 1}}), {};
throws_ok {
    $pkg->new(var => HTTPError => code => 404)->fix({var => {old => 1}})
}
'Catmandu::HTTPError';

done_testing;
