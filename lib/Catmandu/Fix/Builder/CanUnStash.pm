package Catmandu::Fix::Builder::CanUnStash;

use Catmandu::Sane;

our $VERSION = '1.0507';

use Clone qw(clone);
use Catmandu::Fix::Builder::Unstash;
use Moo::Role;
use namespace::clean;

requires 'steps';

sub unstash {
    my ($self) = @_;
    my $step = Catmandu::Fix::Builder::Unstash->new;
    push @{$self->steps}, $step;
    $self;
}

1;

