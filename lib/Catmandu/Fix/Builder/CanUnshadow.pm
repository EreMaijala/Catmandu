package Catmandu::Fix::Builder::CanUnshadow;

use Catmandu::Sane;

our $VERSION = '1.0507';

use Clone qw(clone);
use Catmandu::Util qw(is_code_ref);
require Catmandu::Fix::Builder::Unshadow;
use Moo::Role;
use namespace::clean;

requires 'steps';

sub unshadow {
    my ($self) = @_;
    my $step = Catmandu::Fix::Builder::Unshadow->new;
    push @{$self->steps}, $step;
    $self;
}

1;

