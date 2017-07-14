package Catmandu::Fix::Builder::CanShadow;

use Catmandu::Sane;

our $VERSION = '1.0507';

use Clone qw(clone);
require Catmandu::Fix::Builder::Shadow;
use Moo::Role;
use namespace::clean;

requires 'steps';

sub shadow {
    my ($self) = @_;
    my $step = Catmandu::Fix::Builder::Shadow->new;
    push @{$self->steps}, $step;
    $self;
}

1;

