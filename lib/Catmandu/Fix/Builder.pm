package Catmandu::Fix::Builder;

use Catmandu::Sane;

our $VERSION = '1.0507';

use Moo;
use namespace::clean;

with 'Catmandu::Fix::Builder::Steps', 'Catmandu::Fix::Builder::CanGet', 'Catmandu::Fix::Builder::CanCreate';

sub emit {
    my ($self, @args) = @_;
    $self->emit_steps(@args);
}

1;
