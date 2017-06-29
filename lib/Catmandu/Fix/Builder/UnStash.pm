package Catmandu::Fix::Builder::UnStash;

use Catmandu::Sane;

our $VERSION = '1.06';

use Moo;
use namespace::clean;

with 'Catmandu::Fix::Builder::Base';

sub emit {
    my ($self, %ctx) = @_;
    my ($var, $stash_var) = ($ctx{var}, $ctx{stash_var});
    "${var} = shift(\@{${stash_var}};";
}

1;

