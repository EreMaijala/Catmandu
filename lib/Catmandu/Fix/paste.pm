package Catmandu::Fix::paste;

use Catmandu::Sane;

our $VERSION = '1.0602';

use Catmandu::Util qw(is_value);
use Moo;
use namespace::clean;
use Catmandu::Fix::Has;

with 'Catmandu::Fix::Base';

has path   => (fix_arg => 1);
has values => (fix_arg => 'collect');

sub BUILD {
    my ($self) = @_;

    my $builder = $self->builder;
    my $values  = $self->values;
    my @parsed_values;
    my $join_char = ' ';

    while (@$values) {
        my $val = shift @$values;
        if ($val eq 'join_char') {
            $join_char = shift @$values;
            last;
        }
        else {
            push @parsed_values, $val;
        }
    }

    for my $val (@parsed_values) {
        if (my ($literal) = $val =~ /^~(.*)/) {
            $builder->stash('vals', $literal);
        }
        else {
            $builder->get($val)->if(\&is_value)->stash('vals');
        }
    }

    $builder->create($self->path)->unstash(
        'vals',
        sub {
            my ($old_val, $vals) = @_;
            join($join_char, @$vals);
        }
    );
}

1;

__END__

=pod

=head1 NAME

Catmandu::Fix::paste - concatenate path values

=head1 SYNOPSIS

   # If you data record is:
   #   a: eeny
   #   b: meeny
   #   c: miny
   #   d: moe
   paste(my.string,a,b,c,d)                 # my.string: eeny meeny miny moe

   # Use a join character
   paste(my.string,a,b,c,d,join_char:", ")  # my.string: eeny, meeny, miny, moe

   # Paste literal strings with a tilde sign
   paste(my.string,~Hi,a,~how are you?)    # my.string: Hi eeny how are you?

=head1 DESCRIPTION

Paste places a concatenation of all paths starting from the second path into the first path.
Literal values can be pasted by prefixing them with a tilde (~) sign.

=head1 SEE ALSO

L<Catmandu::Fix>

=cut
