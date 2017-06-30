#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Exception;

my $pkg;

BEGIN {
    $pkg = 'Catmandu::Fix::copy_field';
    use_ok $pkg;
}

is_deeply $pkg->new('old', 'new')->fix({old => 'old'}),
    {old => 'old', new => 'old'}, "copy field at root";

is_deeply $pkg->new('old', 'deeply.nested.$append.new')->fix({old => 'old'}),
    {old => 'old', deeply => {nested => [{new => 'old'}]}},
    "copy field creates intermediate path";

is_deeply $pkg->new('old.*', 'deeply.nested.$append.new')
    ->fix({old => ['old', 'older']}),
    {
    old => ['old', 'older'],
    deeply => {nested => [{new => 'old'}, {new => 'older'}]}
    },
    "copy field creates intermediate path (with wildcard)";

is_deeply $pkg->new('data.$first', 'test')->fix({data => [qw(0 1 2)]}),
    {data => [qw(0 1 2)], test => 0}, 'get $first test';

is_deeply $pkg->new('data.$last', 'test')->fix({data => [qw(0 1 2)]}),
    {data => [qw(0 1 2)], test => 2}, 'get $last test';

is_deeply $pkg->new('data.1', 'test')->fix({data => [qw(0 1 2)]}),
    {data => [qw(0 1 2)], test => 1}, 'get position test arary';

is_deeply $pkg->new('data.1', 'test')->fix({data => {1 => 1}}), {data => {1 => 1}, test => 1},
    'get position test hash';

is_deeply $pkg->new('data.*', 'test')->fix({data => [qw(0 1 2)]}),
    {data => [qw(0 1 2)], test => 2}, 'get star test arary';

is_deeply $pkg->new('data', 'test.1')->fix({data => 1}), {data => 1, test => [undef, 1]},
    'set position test';

is_deeply $pkg->new('data', 'test.$first')->fix({data => 1, test => [qw(0 1 2)]}),
    {data => 1, test => [qw(1 1 2)]}, 'set $first test';

is_deeply $pkg->new('data', 'test.$last')->fix({data => 1, test => [qw(0 1 2)]}),
    {data => 1, test => [qw(0 1 1)]}, 'set $last test';

is_deeply $pkg->new('data', 'test.$prepend')->fix({data => 1, test => [qw(0 1 2)]}),
    {data => 1, test => [qw(1 0 1 2)]}, 'set $prepend test';

is_deeply $pkg->new('data', 'test.$append')->fix({data => 1, test => [qw(0 1 2)]}),
    {data => 1, test => [qw(0 1 2 1)]}, 'set $append test';

is_deeply $pkg->new('data', 'test.*')->fix({data => 1, test => [qw(0 1 2)]}),
    {data => 1, test => [qw(1 1 1)]}, 'set star test';

is_deeply $pkg->new('data', 'test.1')->fix({data => 1, test => {}}),
    {data => 1, test => {1 => 1}}, 'set hash test';

done_testing;
