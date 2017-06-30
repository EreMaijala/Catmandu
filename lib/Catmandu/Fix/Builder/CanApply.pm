package Catmandu::Fix::Builder::CanApply;

use Catmandu::Sane;

our $VERSION = '1.0507';

use Catmandu::Fix::Builder::Apply;
use Moo::Role;
use namespace::clean;

requires 'steps';

sub apply {
    my ($self, $cb) = @_;
    my $step = Catmandu::Fix::Builder::Apply->new({cb => $cb});
    push @{$self->steps}, $step;
    $self;
}

1;

