package Catmandu::Fix::clone;

use Catmandu::Sane;

our $VERSION = '1.0603';

use Clone qw(clone);
use Moo;
use namespace::clean;

with 'Catmandu::Fix::Base';

sub BUILD {
    my ($self) = @_;

    $self->builder->update(\&clone);
}

1;

__END__

=pod

=head1 NAME

Catmandu::Fix::clone - create a clone of the data object

=head1 SYNOPSIS

   # Create a clone of the data object
   clone()

   # Now do all the changes on the clone
   add_field(foo, 2)

=head1 SEE ALSO

L<Catmandu::Fix>

=cut
