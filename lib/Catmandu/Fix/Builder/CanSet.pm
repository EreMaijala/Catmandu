package Catmandu::Fix::Builder::CanSet;

use Catmandu::Sane;

our $VERSION = '1.0507';

require Catmandu::Fix::Builder::Set;
use Moo::Role;
use namespace::clean;

requires 'steps';

sub set {
    my ($self, $path, $value) = @_;
    my $step
        = Catmandu::Fix::Builder::Set->new({path => $path, value => $value});
    push @{$self->steps}, $step;
    $step;
}

1;

