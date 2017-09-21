package Catmandu::Fix::upcase;

use Catmandu::Sane;

our $VERSION = '1.0605';

use Moo;
use Catmandu::Util qw(is_string as_utf8);
use namespace::clean;
use Catmandu::Fix::Has;

with 'Catmandu::Fix::Base';

has path => (fix_arg => 1);

sub BUILD {
    my ($self) = @_;

    $self->builder->get($self->path)->if_is_string->update(
        sub {
            uc as_utf8($_[0]);
        }
    );
}

1;

__END__

=pod

=head1 NAME

Catmandu::Fix::upcase - uppercase the value of a field

=head1 SYNOPSIS

   # Uppercase the value of 'foo'. E.g. foo => 'bar'
   upcase(foo) # foo => 'BAR'

=head1 SEE ALSO

L<Catmandu::Fix>

=cut
