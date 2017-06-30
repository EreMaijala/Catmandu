#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Exception;

my $pkg;

BEGIN {
    $pkg = 'Catmandu::Fix::remove_field';
    use_ok $pkg;
}

is_deeply $pkg->new('remove')->fix({remove => 'me', keep => 'me'}),
    {keep => 'me'}, "remove field at root";

is_deeply $pkg->new('many.*.remove')->fix(
    {
        many =>
            [{remove => 'me', keep => 'me'}, {remove => 'me', keep => 'me'}]
    }
    ),
    {many => [{keep => 'me'}, {keep => 'me'}]},
    "remove nested field with wildcard";

is_deeply $pkg->new('data.$first')->fix({data => [qw(0 1 2)]}), {data => [qw(1 2)]},
    'remove $first test';

is_deeply $pkg->new('data.$last')->fix({data => [qw(0 1 2)]}), {data => [qw(0 1)]},
    'remove $last test';

is_deeply $pkg->new('data.1')->fix({data => [qw(0 1 2)]}), {data => [qw(0 2)]},
    'remove position test arary';

is_deeply $pkg->new('data.1')->fix({data => {1 => 1}}), {data => {}},
    'remove position test hash';

is_deeply $pkg->new('data.*')->fix({data => [qw(0 1 2)]}), {data => []},
    'remove star test arary';

done_testing;
