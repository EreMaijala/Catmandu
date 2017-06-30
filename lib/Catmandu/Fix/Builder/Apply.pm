package Catmandu::Fix::Builder::Apply;

use Catmandu::Sane;

our $VERSION = '1.06';

use Moo;
use namespace::clean;

with 'Catmandu::Fix::Builder::Base';

has cb => (is => 'ro');

sub emit {
    my ($self, %ctx) = @_;

    my $cb     = $self->cb;
    my $var    = $ctx{var};
    my $cb_var = $ctx{fixer}->capture($cb);

    "${cb_var}->(${var});";
}

1;

