package Catmandu::Fix::Builder::CanGet;

use Catmandu::Sane;

our $VERSION = '1.0507';

use Catmandu::Util;
use Catmandu::Fix::Builder::Get;
use Moo::Role;
use namespace::clean;

requires 'steps';

sub get {
    my ($self, $path) = @_;
    my $step = Catmandu::Fix::Builder::Get->new({path => $path});
    push @{$self->steps}, $step;
    $step;
}

1;

