package Catmandu::Fix::Builder::Steps;

use Catmandu::Sane;

our $VERSION = '1.0507';

use Moo::Role;
use namespace::clean;

with 'Catmandu::Fix::Builder::Base';

has steps => (is => 'lazy', default => sub {[]});

sub emit_step {
    my ($self, $step, %ctx) = @_;
    $step->emit(%ctx);
}

sub emit_steps {
    my ($self, %ctx) = @_;
    join '', map {$self->emit_step($_, %ctx)} @{$self->steps};
}

1;

