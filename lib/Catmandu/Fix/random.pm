package Catmandu::Fix::random;

use Catmandu::Sane;

our $VERSION = '1.0603';

use Moo;
use namespace::clean;
use Catmandu::Fix::Has;

with 'Catmandu::Fix::Base';

has path => (fix_arg => 1);
has max  => (fix_arg => 1);

sub BUILD {
    my ($self) = @_;

    my $max = $self->max;
    $self->builder->create($self->path)->update(sub {int(rand($max))});
}

1;

__END__

=pod

=head1 NAME

Catmandu::Fix::random - create an random number in a field

=head1 SYNOPSIS

   # Add a new field 'foo' with a random value between 0 and 9
   random(foo, 10)

   # Add a new field 'my.random.number' with a random value 0 or 1
   random(my.random.number,2)
   
=head1 SEE ALSO

L<Catmandu::Fix>

=cut
