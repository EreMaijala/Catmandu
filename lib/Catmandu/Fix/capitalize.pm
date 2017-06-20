package Catmandu::Fix::capitalize;

use Catmandu::Sane;

our $VERSION = '1.0507';

use Moo;
use Catmandu::Util qw(is_string as_utf8);
use namespace::clean;
use Catmandu::Fix::Has;

extends 'Catmandu::Fix::Builder';

has path => (fix_arg => 1);

sub BUILD {
    my ($self) = @_;

    $self->get($self->path)->if(\&is_string)->update(sub { ucfirst lc as_utf8($_[0]) });
}

1;

__END__

=pod

=head1 NAME

Catmandu::Fix::capitalize - capitalize the value of a key

=head1 SYNOPSIS

   # Capitalize the value of foo. E.g. foo => 'bar'
   capitalize(foo)  # foo => 'Bar'

=head1 SEE ALSO

L<Catmandu::Fix>

=cut
