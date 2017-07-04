package Catmandu::Fix::Builder::CanUnstash;

use Catmandu::Sane;

our $VERSION = '1.0507';

use Clone qw(clone);
use Catmandu::Util qw(is_code_ref);
require Catmandu::Fix::Builder::Unstash;
use Moo::Role;
use namespace::clean;

requires 'steps';

sub unstash {
    my ($self, @names) = @_;
    my $args = {};
    $args->{cb} = pop @names if @names && is_code_ref($names[-1]);
    $args->{names} = \@names if @names;
    my $step = Catmandu::Fix::Builder::Unstash->new($args);
    push @{$self->steps}, $step;
    $self;
}

1;

