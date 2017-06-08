package Catmandu::Fix::Builder;

use Catmandu::Sane;

our $VERSION = '1.0507';

use Catmandu::Fix::Builder::At;
use Catmandu::Fix::Builder::If;
use Catmandu::Fix::Builder::Unless;
use Catmandu::Fix::Builder::Set;
use Moo;

with 'Catmandu::Fix::Base';

has steps => (is => 'lazy', default => sub { [] });

sub at {
    my ($self, $path, $cb) = @_;
    my $step = Catmandu::Fix::Builder::At->new({path => $path, cb => $cb});
    push @{$self->steps}, $step;
    $step;
}

sub if {
    my ($self, $cb) = @_;
    my $step = Catmandu::Fix::Builder::If->new({cb => $cb});
    push @{$self->steps}, $step;
    $step;
}

sub unless {
    my ($self, $cb) = @_;
    my $step = Catmandu::Fix::Builder::Unless->new({cb => $cb});
    push @{$self->steps}, $step;
    $step;
}

sub set {
    my ($self, $cb) = @_;
    my $step = Catmandu::Fix::Builder::Set->new({cb => $cb});
    push @{$self->steps}, $step;
    $self;
}

sub emit_steps {
    my ($self, @args) = @_;
    join '', map { $_->emit(@args) } @{$self->steps};
}

sub emit {
    my ($self, @args) = @_;
    $self->emit_steps(@args);
}

1;
