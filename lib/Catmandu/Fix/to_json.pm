package Catmandu::Fix::to_json;

use Catmandu::Sane;

our $VERSION = '1.0606';

use Cpanel::JSON::XS ();
use Catmandu::Util qw(is_maybe_value is_array_ref is_hash_ref);
use Moo;
use namespace::clean;
use Catmandu::Fix::Has;

has path => (fix_arg => 1);

with 'Catmandu::Fix::Base';

sub BUILD {
    my ($self) = @_;

    my $json    = Cpanel::JSON::XS->new->utf8(0)->pretty(0)->allow_nonref(1);
    my $builder = $self->builder;
    $builder->get($self->path)->update(
        sub {
            my $val = $_[0];
            if (   is_maybe_value($val)
                || is_array_ref($val)
                || is_hash_ref($val))
            {
                $json->encode($val);
            }
            else {
                $builder->cancel;
            }
        }
    );
}

1;

__END__

=pod

=head1 NAME

Catmandu::Fix::to_json - convert the value of a field to json

=head1 SYNOPSIS

   to_json(my.field)

=head1 SEE ALSO

L<Catmandu::Fix>

=cut

