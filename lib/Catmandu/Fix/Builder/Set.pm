package Catmandu::Fix::Builder::Set;

use Catmandu::Sane;

our $VERSION = '1.0507';

use Moo;

extends 'Catmandu::Fix::Builder';

has path  => (is => 'ro', required => 1);
has value => (is => 'ro');

sub emit {
    my ($self, $fixer, $label, $var) = @_;
    $var ||= $fixer->var;

    my $path = $fixer->split_path($self->path);
    my $key  = pop @$path;

    my $builder = $self->get($path);
    $builder->create($key)->update($self->value);
    $builder->emit($fixer, $label, $var);

    #$fixer->emit_walk_path(
        #$var,
        #$path,
        #sub {
            #my $var = $_[0];
            #$fixer->emit_set_key(
                #$var, $key,
                #Catmandu::Fix::Builder::Update->new(value => $self->value)->emit($fixer, $label, $var);
            #);
        #}
    #);
}

1;
