package Catmandu::Fix::sort_field;

use Catmandu::Sane;

our $VERSION = '1.0604';

use Catmandu::Util qw(is_array_ref);
use List::MoreUtils qw(all uniq);
use Moo;
use namespace::clean;
use Catmandu::Fix::Has;

with 'Catmandu::Fix::Base';

has path           => (fix_arg => 1);
has uniq           => (fix_opt => 1);
has reverse        => (fix_opt => 1);
has numeric        => (fix_opt => 1);
has undef_position => (fix_opt => 1, default => sub {'last'});

sub BUILD {
    my ($self) = @_;

    my $builder        = $self->builder;
    my $uniq           = $self->uniq;
    my $reverse        = $self->reverse;
    my $numeric        = $self->numeric;
    my $undef_position = $self->undef_position;
    $builder->get($self->path)->update(
        sub {
            my $val = $_[0];

            return $builder->cancel unless is_array_ref($val);

            #filter out undef
            my $undefs = [grep {!defined($_)} @$val];
            $val = [grep {defined($_)} @$val];

            #uniq
            if ($uniq) {
                $val = [uniq(@$val)];
            }

            #sort
            if ($reverse && $numeric) {
                $val = [sort {$b <=> $a} @$val];
            }
            elsif ($numeric) {
                $val = [sort {$a <=> $b} @$val];
            }
            elsif ($reverse) {
                $val = [sort {$b cmp $a} @$val];
            }
            else {
                $val = [sort {$a cmp $b} @$val];
            }

            #insert undef at the end
            if ($undef_position eq 'first') {
                if ($uniq) {
                    unshift @$val, undef if @$undefs;
                }
                else {
                    unshift @$val, @$undefs;
                }
            }
            elsif ($undef_position eq 'last') {
                if ($uniq) {
                    push @$val, undef if @$undefs;
                }
                else {
                    push @$val, @$undefs;
                }
            }

            $val;
        }
    );
}

sub emit_value {
    my ($self, $var, $fixer) = @_;
    my $comparer = $self->numeric ? "<=>" : "cmp";

    my $perl = "if (is_array_ref(${var})) {";

    #filter out undef
    my $undef_values = $fixer->generate_var;
    $perl .= "my ${undef_values} = [ grep { !defined(\$_) } \@{${var}} ];";
    $perl .= "${var} = [ grep { defined(\$_) } \@{${var}} ];";

    #uniq
    if ($self->uniq) {
        $perl .= "${var} = [List::MoreUtils::uniq(\@{${var}})];";
    }

    #sort
    if ($self->reverse) {
        $perl .= "${var} = [sort { \$b $comparer \$a } \@{${var}}];";
    }
    else {
        $perl .= "${var} = [sort { \$a $comparer \$b } \@{${var}}];";
    }

    #insert undef at the end
    if ($self->undef_position eq "last") {
        if ($self->uniq) {
            $perl .= "push \@{${var}},undef if scalar(\@{${undef_values}});";
        }
        else {
            $perl .= "push \@{${var}},\@{${undef_values}};";
        }
    }

    #insert undef at the beginning
    elsif ($self->undef_position eq "first") {
        if ($self->uniq) {
            $perl
                .= "unshift \@{${var}},undef if scalar(\@{${undef_values}});";
        }
        else {
            $perl .= "unshift \@{${var}},\@{${undef_values}};";
        }
    }

    #leave undef out of the list

    $perl .= "}";
    $perl;
}

1;

__END__

=pod

=head1 NAME

Catmandu::Fix::sort_field - sort the values of an array

=head1 SYNOPSIS

   # e.g. tags => ["foo", "bar","bar"]
   sort_field(tags) # tags =>  ["bar","bar","foo"]
   sort_field(tags, uniq: 1) # tags =>  ["bar","foo"]
   sort_field(tags, uniq: 1, reverse: 1) # tags =>  ["foo","bar"]
   # e.g. nums => [ 100, 1 , 10]
   sort_field(nums, numeric: 1) # nums => [ 1, 10, 100]

   #push undefined values to the end of the list (default)
   #beware: reverse has no effect on this!
   sort_field(tags,undef_position: last)

   #push undefined values to the beginning of the list
   #beware: reverse has no effect on this!
   sort_field(tags,undef_position: first)

   #remove undefined values from the list
   sort_field(tags,undef_position: delete)

=head1 SEE ALSO

L<Catmandu::Fix>

=cut
