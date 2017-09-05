package Catmandu::Fix::expand;

use Catmandu::Sane;

our $VERSION = '1.0603';

use Catmandu::Util qw(is_hash_ref);
use Catmandu::Expander ();
use Moo;
use namespace::clean;
use Catmandu::Fix::Has;

with 'Catmandu::Fix::Base';

has sep => (fix_opt => 1, default => sub {undef});

sub BUILD {
    my ($self) = @_;

    my $builder = $self->builder;
    my $sep     = $self->sep;
    $builder->update(
        sub {
            my $val = $_[0];

            return $builder->cancel unless is_hash_ref($val);

            if (defined($sep)) {
                my $new_ref = {};
                for my $key (keys %$val) {
                    my $val = $val->{$key};
                    $key =~ s{$sep}{\.}g;
                    $new_ref->{$key} = $val;
                }

                $val = $new_ref;
            }

            Catmandu::Expander->expand_hash($val);
        }
    );
}

1;

__END__

=pod

=head1 NAME

Catmandu::Fix::expand - convert a flat hash into nested data using the TT2 dot convention

=head1 SYNOPSIS

   # collapse the data into a flat hash
   collapse()

   # expand again to the nested original
   expand()

   # optionally provide a path separator
   collapse(-sep => '/')
   expand(-sep => '/')

=head1 SEE ALSO

L<Catmandu::Fix>

=cut
