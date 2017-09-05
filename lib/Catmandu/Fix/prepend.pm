package Catmandu::Fix::prepend;

use Catmandu::Sane;

our $VERSION = '1.0603';

use Moo;
use Catmandu::Util qw(is_value);
use namespace::clean;
use Catmandu::Fix::Has;

with 'Catmandu::Fix::Base';

has path  => (fix_arg => 1);
has value => (fix_arg => 1);

sub BUILD {
    my ($self) = @_;

    my $str     = $self->value;
    my $builder = $self->builder;
    $builder->get($self->path)->update(
        sub {
            my $val = $_[0];
            return $builder->cancel unless is_value($val);
            join('', $str, $val);
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
