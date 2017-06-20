package Catmandu::Fix::set_field;

use Catmandu::Sane;

our $VERSION = '1.06';

use Moo;
use namespace::clean;
use Catmandu::Fix::Has;

extends 'Catmandu::Fix::Builder';

has path => (fix_arg => 1);
has value => (fix_arg => 1, default => sub {});

sub BUILD {
    my ($self) = @_;

    $self->set($self->path, $self->value);
}

1;

__END__

=pod

=head1 NAME

Catmandu::Fix::set_field - add or change the value of a HASH key or ARRAY index

=head1 DESCRIPTION

Contrary to C<add_field>, this will not create the intermediate structures
if they are missing.

=head1 SYNOPSIS

   # Change the value of 'foo' to 'bar 123'
   set_field(foo, 'bar 123')

   # Change a deeply nested key
   set_field(my.deep.nested.key, hi)

   # If the second argument is omitted the field has a null value
   add_field(foo)

=head1 SEE ALSO

L<Catmandu::Fix>

=cut
