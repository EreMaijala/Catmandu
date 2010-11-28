package Catmandu::Cmd::Routes;

use Moose;
use Plack::Util;
use Catmandu;
use lib Catmandu->lib;

with 'Catmandu::Command';

has app => (
    traits => ['Getopt'],
    is => 'rw',
    isa => 'Str',
    cmd_aliases => 'a',
    documentation => "A Catmandu::App. Can also be the 1st non-option argument.",
);

sub _usage_format {
    "usage: %c %o [app]";
}

sub BUILD {
    my $self = shift;
    if (my $arg = shift @{$self->extra_argv}) {
        $self->app($arg);
    }
}

sub run {
    my $self = shift;
    Plack::Util::load_class($self->app);
    print $self->app->inspect_routes;
}

__PACKAGE__->meta->make_immutable;
no Moose;
__PACKAGE__;
