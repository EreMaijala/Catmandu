package Catmandu::Fix::Builder::CanDelete;

use Catmandu::Sane;

our $VERSION = '1.0507';

require Catmandu::Fix::Builder::Delete;
use Moo::Role;
use namespace::clean;

requires 'steps';

sub delete {
    my ($self) = @_;
    state $step = Catmandu::Fix::Builder::Delete->new;
    push @{$self->steps}, $step;
    $self;
}

1;

