package Catmandu::Fix::Builder::Stash;

use Catmandu::Sane;

our $VERSION = '1.06';

use Moo;
use namespace::clean;

with 'Catmandu::Fix::Builder::Base';

sub emit {
    my ($self, %ctx) = @_;
    my ($var, $stash_var) = ($ctx{var}, $ctx{stash_var});
    "unshift(\@{${stash_var}}, clone(${var}));";
}

1;

