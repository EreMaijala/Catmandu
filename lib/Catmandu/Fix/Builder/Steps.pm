package Catmandu::Fix::Builder::Steps;

use Catmandu::Sane;

our $VERSION = '1.0507';

use Moo::Role;
use namespace::clean;

with 'Catmandu::Fix::Builder::Base';

has steps => (is => 'lazy', default => sub {[]});

sub emit_steps {
    my ($self, @args) = @_;
    join '', map {$_->emit(@args)} @{$self->steps};
}

1;



