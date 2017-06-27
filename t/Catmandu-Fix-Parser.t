#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use Test::Exception;
use Catmandu::Fix;

my $pkg;

BEGIN {
    $pkg = 'Catmandu::Fix::Parser';
    use_ok $pkg;
}

my $parser = $pkg->new;

isa_ok $parser, $pkg;
can_ok $parser, 'parse';

lives_ok {$parser->parse("")} 'parse empty string';
lives_ok {$parser->parse("    \n    ")} 'parse whitespace only string';
dies_ok {$parser->parse("if exists(foo)")} 'die on if without end';
dies_ok {$parser->parse("if end")} 'die on if without condition';
dies_ok {$parser->parse("unless exists(foo)")} 'die on unless without end';
dies_ok {$parser->parse("unless end")} 'die on unless without condition';
dies_ok {$parser->parse("foo()")} 'die on unknown fix';

my $fixes = $parser->parse("");

cmp_deeply $fixes, [];

sub is_upcase_foo {
    my $fixes = $_[0];
    @$fixes == 1
        && $fixes->[0]->isa('Catmandu::Fix::upcase')
        && $fixes->[0]->path eq 'foo';
}

sub is_upcase_downcase_foo {
    my $fixes = $_[0];
           @$fixes == 2
        && $fixes->[0]->isa('Catmandu::Fix::upcase')
        && $fixes->[0]->path eq 'foo'
        && $fixes->[1]->isa('Catmandu::Fix::downcase')
        && $fixes->[1]->path eq 'foo';
}

ok is_upcase_foo(
    $parser->parse(
        "# a comment
    # another comment
    #
    upcase(foo) # yet another comment"
    )
    ),
    'ignore comments';

ok is_upcase_foo($parser->parse("upcase(foo)")),
    'parse unquoted string argument';
ok is_upcase_foo($parser->parse("upcase('foo')")),
    'parse single quoted string argument';
ok is_upcase_foo($parser->parse(q|upcase("foo")|)),
    'parse double quoted string argument';

ok is_upcase_downcase_foo($parser->parse("upcase(foo) downcase(foo)"));
ok is_upcase_downcase_foo($parser->parse("upcase(foo); downcase(foo)"));
ok is_upcase_downcase_foo($parser->parse("upcase(foo)\n downcase(foo)"));

# if
$fixes = $parser->parse("if exists(foo) end");
ok @$fixes == 1;
ok $fixes->[0]->isa('Catmandu::Fix::Condition::exists');
ok @{$fixes->[0]->pass_fixes} == 0;
ok @{$fixes->[0]->fail_fixes} == 0;

$fixes = $parser->parse("if exists(foo) downcase(foo) end");
ok @$fixes == 1;
ok $fixes->[0]->isa('Catmandu::Fix::Condition::exists');
ok @{$fixes->[0]->pass_fixes} == 1;
ok $fixes->[0]->pass_fixes->[0]->isa('Catmandu::Fix::downcase');
ok @{$fixes->[0]->fail_fixes} == 0;

# if ... else
$fixes = $parser->parse("if exists(foo) downcase(foo) else upcase(foo) end");
ok @$fixes == 1;
ok $fixes->[0]->isa('Catmandu::Fix::Condition::exists');
ok @{$fixes->[0]->pass_fixes} == 1;
ok $fixes->[0]->pass_fixes->[0]->isa('Catmandu::Fix::downcase');
ok @{$fixes->[0]->fail_fixes} == 1;
ok $fixes->[0]->fail_fixes->[0]->isa('Catmandu::Fix::upcase');

# unless
$fixes = $parser->parse("unless exists(foo) downcase(foo) end");
ok @$fixes == 1;
ok $fixes->[0]->isa('Catmandu::Fix::Condition::exists');
ok @{$fixes->[0]->pass_fixes} == 0;
ok @{$fixes->[0]->fail_fixes} == 1;
ok $fixes->[0]->fail_fixes->[0]->isa('Catmandu::Fix::downcase');

# nested if
for (
    (
        "if exists(foo) if exists(bar) downcase(foo) end upcase(foo) end",
        "if exists(foo); if exists(bar); downcase(foo); end; upcase(foo); end;",
    )
    )
{
    $fixes = $parser->parse($_);
    ok @$fixes == 1;
    ok $fixes->[0]->isa('Catmandu::Fix::Condition::exists');
    ok @{$fixes->[0]->pass_fixes} == 2;
    ok $fixes->[0]->pass_fixes->[0]->isa('Catmandu::Fix::Condition::exists');
    ok $fixes->[0]->pass_fixes->[1]->isa('Catmandu::Fix::upcase');
    ok @{$fixes->[0]->fail_fixes} == 0;
}

# if ... elsif
$fixes = $parser->parse(
    "if exists(foo) downcase(foo) elsif exists(bar) upcase(foo) end");
ok @$fixes == 1;
ok $fixes->[0]->isa('Catmandu::Fix::Condition::exists');
ok @{$fixes->[0]->pass_fixes} == 1;
ok $fixes->[0]->pass_fixes->[0]->isa('Catmandu::Fix::downcase');
ok @{$fixes->[0]->fail_fixes} == 1;
ok $fixes->[0]->fail_fixes->[0]->isa('Catmandu::Fix::Condition::exists');
ok @{$fixes->[0]->fail_fixes->[0]->pass_fixes} == 1;
ok $fixes->[0]->fail_fixes->[0]->pass_fixes->[0]
    ->isa('Catmandu::Fix::upcase');
ok @{$fixes->[0]->fail_fixes->[0]->fail_fixes} == 0;

# if ... elsif ... else
$fixes
    = $parser->parse(
    "if exists(foo) downcase(foo) elsif exists(bar) upcase(foo) else capitalize(bar) end"
    );
ok @$fixes == 1;
ok $fixes->[0]->isa('Catmandu::Fix::Condition::exists');
ok @{$fixes->[0]->pass_fixes} == 1;
ok $fixes->[0]->pass_fixes->[0]->isa('Catmandu::Fix::downcase');
ok @{$fixes->[0]->fail_fixes} == 1;
ok $fixes->[0]->fail_fixes->[0]->isa('Catmandu::Fix::Condition::exists');
ok @{$fixes->[0]->fail_fixes->[0]->pass_fixes} == 1;
ok $fixes->[0]->fail_fixes->[0]->pass_fixes->[0]
    ->isa('Catmandu::Fix::upcase');
ok @{$fixes->[0]->fail_fixes->[0]->fail_fixes} == 1;
ok $fixes->[0]->fail_fixes->[0]->fail_fixes->[0]
    ->isa('Catmandu::Fix::capitalize');

# if ... elsif ... elsif ... else
$fixes
    = $parser->parse(
    "if exists(foo) downcase(foo) elsif exists(bar) upcase(foo) elsif exists(baz) trim(bar) else capitalize(bar) end"
    );
ok @$fixes == 1;
ok $fixes->[0]->isa('Catmandu::Fix::Condition::exists');
ok @{$fixes->[0]->pass_fixes} == 1;
ok $fixes->[0]->pass_fixes->[0]->isa('Catmandu::Fix::downcase');
ok @{$fixes->[0]->fail_fixes} == 1;
ok $fixes->[0]->fail_fixes->[0]->isa('Catmandu::Fix::Condition::exists');
ok @{$fixes->[0]->fail_fixes->[0]->pass_fixes} == 1;
ok $fixes->[0]->fail_fixes->[0]->pass_fixes->[0]
    ->isa('Catmandu::Fix::upcase');
ok @{$fixes->[0]->fail_fixes->[0]->fail_fixes} == 1;
ok $fixes->[0]->fail_fixes->[0]->fail_fixes->[0]
    ->isa('Catmandu::Fix::Condition::exists');
ok @{$fixes->[0]->fail_fixes->[0]->fail_fixes->[0]->pass_fixes} == 1;
ok $fixes->[0]->fail_fixes->[0]->fail_fixes->[0]->pass_fixes->[0]
    ->isa('Catmandu::Fix::trim');
ok @{$fixes->[0]->fail_fixes->[0]->fail_fixes->[0]->fail_fixes} == 1;
ok $fixes->[0]->fail_fixes->[0]->fail_fixes->[0]->fail_fixes->[0]
    ->isa('Catmandu::Fix::capitalize');

# and, or
for (
    (
        "exists(foo) and downcase(foo)",
        "exists(foo) && downcase(foo)",
        "exists(foo) && downcase(foo);",
    )
    )
{
    $fixes = $parser->parse($_);
    ok @$fixes == 1;
    ok $fixes->[0]->isa('Catmandu::Fix::Condition::exists');
    ok @{$fixes->[0]->pass_fixes} == 1;
    ok $fixes->[0]->pass_fixes->[0]->isa('Catmandu::Fix::downcase');
    ok @{$fixes->[0]->fail_fixes} == 0;
}

for (
    (
        "exists(foo) or downcase(foo)",
        "exists(foo) || downcase(foo)",
        "exists(foo) || downcase(foo);",
    )
    )
{
    $fixes = $parser->parse($_);
    ok @$fixes == 1;
    ok $fixes->[0]->isa('Catmandu::Fix::Condition::exists');
    ok @{$fixes->[0]->pass_fixes} == 0;
    ok @{$fixes->[0]->fail_fixes} == 1;
    ok $fixes->[0]->fail_fixes->[0]->isa('Catmandu::Fix::downcase');
}

dies_ok {$parser->parse("exists(foo) || if exists(foo) downcase(foo) end")}
'die on bool without fix';
dies_ok {$parser->parse("|| downcase(foo)")} 'die on bool without condition';

# select, reject
$fixes = $parser->parse("select exists(foo)");
ok @$fixes == 1;
ok $fixes->[0]->isa('Catmandu::Fix::Condition::exists');
ok @{$fixes->[0]->pass_fixes} == 0;
ok @{$fixes->[0]->fail_fixes} == 1;
ok $fixes->[0]->fail_fixes->[0]->isa('Catmandu::Fix::reject');

$fixes = $parser->parse("reject exists(foo)");
ok @$fixes == 1;
ok $fixes->[0]->isa('Catmandu::Fix::Condition::exists');
ok @{$fixes->[0]->pass_fixes} == 1;
ok $fixes->[0]->pass_fixes->[0]->isa('Catmandu::Fix::reject');
ok @{$fixes->[0]->fail_fixes} == 0;

throws_ok {
    $parser->parse('unknown_fix()');
}
'Catmandu::NoSuchFixPackage', 'using unknown fixes throws NoSuchFixPackage';

throws_ok {
    $parser->parse('copy_field()');
}
'Catmandu::BadFixArg', 'missing or bad fix arguments throw BadFixArg';

throws_ok {
    $parser->parse('syntax_error((((((');
}
'Catmandu::FixParseError', 'syntax errors throw FixParseError';

# bare strings
{
    my $fixes = $parser->parse(q|add_field(022, 022)|);
    is $fixes->[0]->path, '022';
}

# string and regex escapes
{
    my $fixes;
    lives_ok {
        $parser->parse(q|set_field(test, "\"")|);
    };
    dies_ok {
        $parser->parse(q|set_field(test, "\\\\"")|);
    };
    lives_ok {
        $parser->parse(q|set_field(test, '\'')|);
    };
    dies_ok {
        $parser->parse(q|set_field(test, '\\\\'')|);
    };
    lives_ok {
        $parser->parse(q|replace_all(test, '\+(\d{2}):(\d{2})', '+$1$2')|);
    };
    lives_ok {
        $fixes = $parser->parse(
            q|replace_all(test, '\+(\d{2}):(\d{2})', '+$1$2')|);
    };
    is $fixes->[0]->search, '\+(\d{2}):(\d{2})';
    $fixes
        = $parser->parse(q|replace_all(test, "\+(\d{2}):(\d{2})", "+$1$2")|);
    is $fixes->[0]->search,  '\+(\d{2}):(\d{2})';
    is $fixes->[0]->replace, '+$1$2';
}

done_testing;
