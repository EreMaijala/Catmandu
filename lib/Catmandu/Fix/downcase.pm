package Catmandu::Fix::downcase;

use Catmandu::Sane;

our $VERSION = '1.0603';

use Moo;
use Catmandu::Util qw(is_string as_utf8);
use namespace::clean;
use Catmandu::Fix::Has;

with 'Catmandu::Fix::Base';

has path => (fix_arg => 1);

sub BUILD {
    my ($self) = @_;

    my $builder = $self->builder;
    $builder->get($self->path)->update(
        sub {
            my $val = $_[0];
            return $builder->cancel unless is_string($val);
            lc as_utf8($val);
        }
    );
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
