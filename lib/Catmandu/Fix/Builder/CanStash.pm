package Catmandu::Fix::Builder::CanStash;

use Catmandu::Sane;

our $VERSION = '1.0507';

use Clone qw(clone);
require Catmandu::Fix::Builder::Stash;
use Moo::Role;
use namespace::clean;

requires 'steps';

sub stash {
    my ($self, $name, $value) = @_;
    my $args = {};
    $args->{name}  = $name  if defined $name;
    $args->{value} = $value if @_ == 3;
    my $step = Catmandu::Fix::Builder::Stash->new($args);
    push @{$self->steps}, $step;
    $self;
}

1;

