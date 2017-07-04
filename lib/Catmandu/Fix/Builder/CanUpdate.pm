package Catmandu::Fix::Builder::CanUpdate;

use Catmandu::Sane;

our $VERSION = '1.0507';

require Catmandu::Fix::Builder::Update;
use Moo::Role;
use namespace::clean;

requires 'steps';

sub update {
    my ($self, $value) = @_;
    my $step = Catmandu::Fix::Builder::Update->new({value => $value});
    push @{$self->steps}, $step;
    $self;
}

1;

