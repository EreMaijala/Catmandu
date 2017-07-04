package Catmandu::Fix::Builder::CanCreate;

use Catmandu::Sane;

our $VERSION = '1.0507';

require Catmandu::Fix::Builder::Create;
use Moo::Role;
use namespace::clean;

requires 'steps';

sub create {
    my ($self, $path) = @_;
    my $step = Catmandu::Fix::Builder::Create->new({path => $path});
    push @{$self->steps}, $step;
    $step;
}

1;

