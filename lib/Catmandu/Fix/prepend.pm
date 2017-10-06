package Catmandu::Fix::prepend;

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
            join('', $str, $_[0]);
        }
    );
}

1;

__END__

=pod

=head1 NAME

Catmandu::Fix::prepend - add a prefix to the value of a field

=head1 SYNOPSIS

   # prepend to a value. e.g. {name => 'smith'}
   prepend(name, 'mr. ') # {name => 'mr. smith'}

=head1 SEE ALSO

L<Catmandu::Fix>

=cut
