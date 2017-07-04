package Catmandu::Fix::Builder::Stash;

use Catmandu::Sane;

our $VERSION = '1.06';

use Moo;
use namespace::clean;

with 'Catmandu::Fix::Builder::Base';

has name => (is => 'ro', default => sub {'_'});
has value => (is => 'ro', predicate => 1);

# TODO support callback, cancel
sub emit {
    my ($self, %ctx) = @_;
    my ($fixer, $var, $stash_var) = ($ctx{fixer}, $ctx{var}, $ctx{stash_var});
    my $name = $fixer->emit_string($self->name);
    # TODO allow other values than strings (cfr update)
    if ($self->has_value) {
        my $val = $fixer->emit_string($self->value);
        "unshift(\@{${stash_var}->{${name}} ||= []}, ${val});";
    } else {
        "unshift(\@{${stash_var}->{${name}} ||= []}, clone(${var}));";
    }
}

1;

