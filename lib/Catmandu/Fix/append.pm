package Catmandu::Fix::append;

use Catmandu::Sane;

our $VERSION = '1.0606';

use Moo;
use Catmandu::Util qw(is_value);
use namespace::clean;
use Catmandu::Fix::Has;

with 'Catmandu::Fix::Base';

has path  => (fix_arg => 1);
has value => (fix_arg => 1);

sub BUILD {
    my ($self) = @_;

    my $str = $self->value;
    $self->builder->get($self->path)->if('is_value')->update(
        sub {
            join('', $_[0], $str);
        }
    );
}

1;

__END__

=pod

=head1 NAME

Catmandu::Fix::append - add a suffix to the value of a field

=head1 SYNOPSIS

   # append to a value. e.g. {name => 'joe'}
   append(name, y) # {name => 'joey'}

=head1 SEE ALSO

L<Catmandu::Fix>

=cut
