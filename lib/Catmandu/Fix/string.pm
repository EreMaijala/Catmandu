package Catmandu::Fix::string;

use Catmandu::Sane;

our $VERSION = '1.0604';

use Catmandu::Util qw(is_string is_value is_array_ref is_hash_ref);
use List::Util qw(all);
use Moo;
use namespace::clean;
use Catmandu::Fix::Has;

has path => (fix_arg => 1);

with 'Catmandu::Fix::Base';

sub BUILD {
    my ($self) = @_;

    my $builder = $self->builder;
    $builder->get($self->path)->update(
        sub {
            my $val = $_[0];
            if (is_string($val)) {
                "${val}";
            }
            elsif (is_array_ref($val) && all {is_value($_)} @$val) {
                join('', @$val);
            }
            elsif (is_hash_ref($val) && all {is_value($_)} values %$val) {
                join('', map {$val->{$_}} sort keys %$val);
            }
            else {
                '';
            }
        }
    );
}

1;

__END__

=pod

=head1 NAME

Catmandu::Fix::string - convert a value to a string

=head1 SYNOPSIS

    # year => 2016
    string(year)
    # year => "2016"

    # foo => ["a", "b", "c"]
    string(foo)
    # foo => "abc"

    # foo => ["a", {b => "c"}, "d"]
    string(foo)
    # foo => ""
    
    # foo => {2 => "b", 1 => "a"}
    string(foo)
    # foo => "ab"

    # foo => {a => ["b"]}
    string(foo)
    # foo => ""

=head1 SEE ALSO

L<Catmandu::Fix>

=cut
