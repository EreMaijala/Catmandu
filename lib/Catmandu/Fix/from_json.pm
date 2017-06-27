package Catmandu::Fix::from_json;

use Catmandu::Sane;

our $VERSION = '1.0602';

use Cpanel::JSON::XS ();
use Catmandu::Util qw(is_string);
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
            return $self->cancel unless is_string($val);
            $json->decode($val);
        }
    );
}

1;

__END__

=pod

=head1 NAME

Catmandu::Fix::from_json - replace a json field with the parsed value

=head1 SYNOPSIS

   from_json(my.field)

=head1 SEE ALSO

L<Catmandu::Fix>

=cut


