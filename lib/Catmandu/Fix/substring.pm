package Catmandu::Fix::substring;

use Catmandu::Sane;

our $VERSION = '1.0602';

use Catmandu::Util qw(as_utf8 is_value);
use Moo;
use namespace::clean;
use Catmandu::Fix::Has;

has path => (fix_arg => 1);
has args => (fix_arg => 'collect');

with 'Catmandu::Fix::Base';

sub BUILD {
    my ($self) = @_;

    my $builder = $self->builder;
    my $args    = $self->args;
    my $cb;
    if (@$args == 1) {
        $cb = sub {
            my $val = $_[0];
            return $builder->cancel unless is_value($val);
            my $new_val;
            eval {
                no warnings 'substr';
                $new_val = substr(as_utf8($val), $args->[0]);
            };
            $new_val // $builder->cancel;
            }
    }
    elsif (@$args == 2) {
        $cb = sub {
            my $val = $_[0];
            return $builder->cancel unless is_value($val);
            my $new_val;
            eval {
                no warnings 'substr';
                $new_val = substr(as_utf8($val), $args->[0], $args->[1]);
            };
            $new_val // $builder->cancel;
            }
    }
    else {
        $cb = sub {
            my $val = $_[0];
            return $builder->cancel unless is_value($val);
            my $new_val = as_utf8($val);
            eval {
                no warnings 'substr';
                substr($new_val, $args->[0], $args->[1]) = $args->[2];
            } // return $builder->cancel;
            $new_val;
            }
    }

    $builder->get($self->path)->update($cb);
}

sub emit_value {
    my ($self, $var, $fixer) = @_;
    my $args = $self->args;
    my $str_args = @$args > 1 ? join(", ", @$args[0, 1]) : $args->[0];

    if (@$args < 3) {
        return
            "eval { ${var} = substr(as_utf8(${var}), ${str_args}) } if is_value(${var});";
    }
    my $replace = $fixer->emit_string($args->[2]);
    "if (is_value(${var})) {"
        . "utf8::upgrade(${var});"
        . "eval { substr(${var}, ${str_args}) = ${replace} };" . "}";
}

1;

__END__

=pod

=head1 NAME

Catmandu::Fix::substring - extract a substring out of the value of a field

=head1 SYNOPSIS

   # Extract a substring out of the value of a field
   # - Extact from 'initials' the characters at offset 0 (first character) with a length 3
   substring(initials, 0, 3)

=head1 SEE ALSO

L<Catmandu::Fix>, substr

=cut
