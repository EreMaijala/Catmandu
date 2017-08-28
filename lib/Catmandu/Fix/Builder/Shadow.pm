package Catmandu::Fix::Builder::Shadow;

use Catmandu::Sane;

our $VERSION = '1.06';

use Moo;
use namespace::clean;

with 'Catmandu::Fix::Builder::Base';

# TODO support callback, cancel
sub emit {
    my ($self, %ctx) = @_;
    my ($fixer, $var, $stash_var) = ($ctx{fixer}, $ctx{var}, $ctx{stash_var});
    my $name = $fixer->emit_string('_shadow');

    $fixer->emit_create_path("${stash_var}->{${name}}", $fixer->current_path, sub {
        my ($shadow_var) = @_;
        "${shadow_var} = ${var};";
    });
}

1;

