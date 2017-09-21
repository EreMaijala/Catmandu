package Catmandu::Fix::replace_all;

use Catmandu::Sane;

our $VERSION = '1.0605';

use Catmandu::Util qw(is_value);
use Moo;
use namespace::clean;
use Catmandu::Fix::Has;

has path    => (fix_arg => 1);
has search  => (fix_arg => 1);
has replace => (fix_arg => 1);

with 'Catmandu::Fix::Base';

sub BUILD {
    my ($self) = @_;

    my $builder = $self->builder;
    my $substituter = $builder->substitution($self->search, $self->replace);
    $builder->get($self->path)->update(
        sub {
            my $val = $_[0];
            return $builder->cancel unless is_value($val);
            $substituter->($val);
        }
    );
}

1;

__END__

=pod

=head1 NAME

Catmandu::Fix::replace_all - search and replace using regex expressions

=head1 SYNOPSIS

   # Extract a substring out of the value of a field
   # {author => "tom jones"}
   replace_all(author, '([^ ]+) ([^ ]+)', '$2, $1')
   # {author => "jones, tom"}

=head1 SEE ALSO

L<Catmandu::Fix>

=cut
