package Catmandu::Fix::downcase;

use Catmandu::Sane;

our $VERSION = '1.0601';

use Moo;
use Catmandu::Util qw(is_string as_utf8);
use namespace::clean;
use Catmandu::Fix::Has;

extends 'Catmandu::Fix::Builder';

has path => (fix_arg => 1);

sub BUILD {
    my ($self) = @_;

    $self->get($self->path)->if(\&is_string)->update(sub { lc as_utf8($_[0]) });
}

1;

__END__

=pod

=head1 NAME

Catmandu::Fix::downcase - lowercase the value of a field

=head1 SYNOPSIS

   # Lowercase 'foo'. E.g. foo => 'BAR'
   downcase(foo) # foo => 'bar'

=head1 SEE ALSO

L<Catmandu::Fix>

=cut
