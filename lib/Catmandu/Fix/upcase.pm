package Catmandu::Fix::upcase;

use Catmandu::Sane;

our $VERSION = '1.0602';

use Moo;
use Catmandu::Util qw(is_string as_utf8);
use namespace::clean;
use Catmandu::Fix::Has;

with 'Catmandu::Fix::Base';

has path => (fix_arg => 1);

sub BUILD {
    my ($self) = @_;

    my $builder = $self->builder;
    $builder->get($self->path)->update(sub {
        my $val = $_[0];
        return $builder->cancel unless is_string($val);
        ucfirst uc as_utf8($val);
    });
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
