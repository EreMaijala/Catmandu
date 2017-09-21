package Catmandu::Fix::filter;

use Catmandu::Sane;

our $VERSION = '1.0605';

use Catmandu::Util qw(is_array_ref);
use Moo;
use namespace::clean;
use Catmandu::Fix::Has;

has path   => (fix_arg => 1);
has search => (fix_arg => 1);

with 'Catmandu::Fix::Base';

sub BUILD {
    my ($self) = @_;

    my $builder = $self->builder;
    my $regex   = $builder->regex($self->search);
    $builder->get($self->path)->if('is_array_ref')->update(
        sub {
            [grep m/$regex/, @{$_[0]}];
        }
    );
}

1;

__END__

=pod

=head1 NAME

Catmandu::Fix::filter - Filter values out of an array based on a regular expression

=head1 SYNOPSIS

   # words => ["Patrick","Nicolas","Paul","Frank"]
   
   filter(words,'Pa')
   
   # words => ["Patrick","Paul"]

=head1 SEE ALSO

L<Catmandu::Fix>

=cut
