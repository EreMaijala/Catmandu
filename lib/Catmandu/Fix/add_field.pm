package Catmandu::Fix::add_field;

use Catmandu::Sane;

our $VERSION = '1.0603';

use Moo;
use namespace::clean;
use Catmandu::Fix::Has;

with 'Catmandu::Fix::Base';

has path => (fix_arg => 1);
has value => (fix_arg => 1, default => sub { });

sub BUILD {
    my ($self) = @_;

    $self->builder->create($self->path)->update($self->value);
}

1;

__END__

=pod

=head1 NAME

Catmandu::Fix::add_field - add or change the value of a HASH key or ARRAY index

=head1 DESCRIPTION

Contrary to C<set_field>, this will create the intermediate structures
if they are missing.

=head1 SYNOPSIS

   # Add a new field 'foo' with value 2
   add_field(foo, 2)

   # Change the value of 'foo' to 'bar 123'
   add_field(foo, 'bar 123')

   # Create a deeply nested key
   add_field(my.deep.nested.key, hi)

   # If the second argument is omitted the field has a null value
   add_field(foo)

=head1 SEE ALSO

L<Catmandu::Fix>

=cut
