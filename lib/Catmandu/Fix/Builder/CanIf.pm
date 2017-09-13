package Catmandu::Fix::Builder::CanIf;

use Catmandu::Sane;

our $VERSION = '1.0507';

require Catmandu::Fix::Builder::If;
use Sub::Quote    ();
use Data::Util    ();
use Moo::Role;
use namespace::clean;

requires 'steps';

sub if {
    my ($self, $cb) = @_;
    my $step = Catmandu::Fix::Builder::If->new({cb => $cb});
    push @{$self->steps}, $step;
    $step;
}

sub if_is_value {
    my $self = $_[0];
    my $step = Catmandu::Fix::Builder::If->new({type => 'value'});
    push @{$self->steps}, $step;
    $step;
}

sub if_is_string {
    my $self = $_[0];
    my $step = Catmandu::Fix::Builder::If->new({type => 'string'});
    push @{$self->steps}, $step;
    $step;
}

sub if_is_array_ref {
    my $self = $_[0];
    my $step = Catmandu::Fix::Builder::If->new({type => 'array_ref'});
    push @{$self->steps}, $step;
    $step;
}

sub if_is_hash_ref {
    my $self = $_[0];
    my $step = Catmandu::Fix::Builder::If->new({type => 'hash_ref'});
    push @{$self->steps}, $step;
    $step;
}

#for my $sym (qw(value string array_ref hash_ref)) {
    #my $sub
        #= Sub::Quote::quote_sub(
        #"my \$self = \$_[0]; my \$step = Catmandu::Fix::Builder::If->new({type => '$sym'}); push(\@{\$self->steps}, \$step); \$step;"
        #);
    #Data::Util::install_subroutine(__PACKAGE__, "if_is_${sym}" => $sub);
#}

1;

