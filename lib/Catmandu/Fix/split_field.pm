package Catmandu::Fix::split_field;

use Catmandu::Sane;

our $VERSION = '1.0604';

use Catmandu::Util qw(is_value);
use Moo;
use namespace::clean;
use Catmandu::Fix::Has;

has path => (fix_arg => 1);
has split_char => (fix_arg => 1, default => sub {qr'\s+'});

with 'Catmandu::Fix::Base';

sub BUILD {
    my ($self) = @_;

    my $builder = $self->builder;
    my $pattern = $builder->regex($self->split_char);
    $builder->get($self->path)->update(
        sub {
            my $val = $_[0];
            return $builder->cancel unless is_value($val);
            [split $pattern, $val];
        }
    );
}

1;

__END__

=pod

=head1 NAME

Catmandu::Fix::split_field - split a string value in a field into an ARRAY

=head1 SYNOPSIS

   # Split the 'foo' value into an array. E.g. foo => '1:2:3'
   split_field(foo, ':') # foo => [1,2,3]

=head1 SEE ALSO

L<Catmandu::Fix>

=cut
