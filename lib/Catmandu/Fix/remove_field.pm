package Catmandu::Fix::remove_field;

use Catmandu::Sane;

our $VERSION = '1.0507';

use Moo;
use namespace::clean;
use Catmandu::Fix::Has;

extends 'Catmandu::Fix::Builder';

has path => (fix_arg => 1);

sub BUILD {
    my ($self) = @_;

    $self->delete($self->path);
}

1;

__END__

=pod

=head1 NAME

Catmandu::Fix::remove_field - remove a field form the data

=head1 SYNOPSIS

   # Remove the foo.bar field
   remove_field(foo.bar)

=head1 SEE ALSO

L<Catmandu::Fix>

=cut
