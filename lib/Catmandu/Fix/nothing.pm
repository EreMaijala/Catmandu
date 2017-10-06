package Catmandu::Fix::nothing;

use Catmandu::Sane;

our $VERSION = '1.0606';

use Moo;
use namespace::clean;

with 'Catmandu::Fix::Base';

1;

__END__

=pod

=head1 NAME

Catmandu::Fix::nothing - does nothing (for testing)

=head1 SYNOPSIS

   nothing()

=head1 SEE ALSO

L<Catmandu::Fix>

=cut
