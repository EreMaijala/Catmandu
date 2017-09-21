package Catmandu::Fix::Builder::CanIf;

use Catmandu::Sane;

our $VERSION = '1.0507';

require Catmandu::Fix::Builder::If;
use Sub::Quote ();
use Data::Util ();
use Moo::Role;
use namespace::clean;

requires 'steps';

sub if {
    my ($self, $condition) = @_;
    my $step = Catmandu::Fix::Builder::If->new({condition => $condition});
    push @{$self->steps}, $step;
    $step;
}

1;

