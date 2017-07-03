package Catmandu::Fix::Builder::Stash;

use Catmandu::Sane;

our $VERSION = '1.06';

use Moo;
use namespace::clean;

with 'Catmandu::Fix::Builder::Base';

has name => (is => 'ro', default => sub {'_'});

sub emit {
    my ($self, %ctx) = @_;
    my $name = $self->name;
    my ($var, $stash_var) = ($ctx{var}, $ctx{stash_var});
    "unshift(\@{${stash_var}->{${name}} ||= []}, clone(${var}));";
}

1;

