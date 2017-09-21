package Catmandu::Fix::import;

use Catmandu::Sane;

our $VERSION = '1.0604';

use Catmandu;
use Moo;
use namespace::clean;
use Catmandu::Fix::Has;

with 'Catmandu::Fix::Base';

has path       => (fix_arg => 1);
has name       => (fix_arg => 1);
has delete     => (fix_opt => 1);
has ignore_404 => (fix_opt => 1);
has opts       => (fix_opt => 'collect');

sub BUILD {
    my ($self)     = @_;
    my $builder    = $self->builder;
    my $name       = $self->name;
    my $opts       = $self->opts;
    my $delete     = $self->delete;
    my $ignore_404 = $self->ignore_404;
    $builder->get($self->path)->update(
        sub {
            my $val = $_[0];
            try {
                $val = Catmandu->importer($name, variables => $val, %$opts)
                    ->first;
            }
            catch_case [
                'Catmandu::HTTPError' => sub {
                    if ($_->code eq '404' && $ignore_404) {$val = undef}
                    else                                  {$_->throw}
                }
            ];

            return $val if defined $val;
            return $builder->cancel_and_delete if $delete;
            $builder->cancel;
        }
    );
}

1;

__END__

=pod

=head1 NAME

Catmandu::Fix::import - change the value of a HASH key or ARRAY index by replacing
its value with imported data

=head1 SYNOPSIS

   import(foo.bar, JSON, file: "http://foo.com/bar.json", data_path: data.*)

=head1 SEE ALSO

L<Catmandu::Fix>

=cut
