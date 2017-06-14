package Catmandu::Store::Simple::Bag;

our $VERSION = '1.0507';

use Catmandu::Sane;
use Moo;
use Carp;
use IO::File;
use Path::Tiny;
use File::Spec;
use File::Copy;
use Catmandu::Util;
use URI::Escape;
use Catmandu::FileStore::MimeType;
use namespace::clean;
use utf8;

with 'Catmandu::Bag', 'Catmandu::FileStore::Bag' , 'Catmandu::Droppable';

has _path     => (is => 'lazy');
has _mimeType => (is => 'lazy');

sub _build__path {
    my $self = shift;
    $self->store->path_string($self->name);
}

sub _build__mimeType {
    Catmandu::FileStore::MimeType->new;
}

sub generator {
    my ($self) = @_;
    my $path = $self->_path;

    sub {
        state $children = [ path($path)->children ];

        my $child = shift @$children;

        return undef unless $child;

        my ($volume,$directories,$file) = File::Spec->splitpath($child);

        next if index($file, ".") == 0;

        my $unpacked_key = $self->unpack_key($file);

        return $self->get($unpacked_key);
    };
}

sub exists {
    my ($self, $id) = @_;
    my $path = $self->_path;

    my $packed_key = $self->pack_key($id);

    my $file = File::Spec->catfile($path,$packed_key);

    -f $file;
}

sub get {
    my ($self, $id) = @_;
    my $path = $self->_path;

    my $packed_key = $self->pack_key($id);

    my $file = File::Spec->catfile($path,$packed_key);

    return undef unless -f $file;

    my $data = IO::File->new($file, "r");

    my $stat = [$data->stat];

    my $size     = $stat->[7];
    my $modified = $stat->[9];
    my $created  = $stat->[10];    # no real creation time exists on Unix

    my $content_type = $self->_mimeType->content_type($id);

    return {
        _id          => $id,
        size         => $size,
        md5          => '',
        content_type => $content_type,
        created      => $created,
        modified     => $modified,
        _stream      => sub {
            my $out = $_[0];
            my $bytes = 0;

            Catmandu::Error->throw("no io defined or not writable") unless defined($out);

            while (!$data->eof) {
                my $buffer;
                $data->read($buffer, 1024);
                $bytes += $out->write($buffer);
            }

            $out->close();
            $data->close();

            $bytes;
        }
    };
}

sub add {
    my ($self, $data) = @_;
    my $path = $self->_path;

    my $id = $data->{_id};
    my $io = $data->{_stream};

    return $self->get($id) unless $io;

    my $packed_key = $self->pack_key($id);

    my $file = File::Spec->catfile($path,$packed_key);

    if (Catmandu::Util::is_invocant($io)) {
        return copy($io, $file);
    }
    else {
        return Catmandu::Util::write_file($file, $io);
    }

    return $self->get($id);
}

sub delete {
    my ($self, $id) = @_;
    my $path = $self->_path;

    my $packed_key = $self->pack_key($id);

    my $file = File::Spec->catfile($path,$packed_key);

    return undef unless -f $file;

    unlink $file;
}

sub delete_all {
    my ($self) = @_;

    $self->each(sub {
        my $key = shift->{_id};
        $self->delete($key);
    });

    1;
}

sub drop {
    $_[0]->delete_all;
}

sub commit {
    return 1;
}

sub pack_key {
    my $self = shift;
    my $key  = shift;
    utf8::encode($key);
    uri_escape($key);
}

sub unpack_key {
    my $self = shift;
    my $key  = shift;
    my $str  = uri_unescape($key);
    utf8::decode($str);
    $str;
}

1;

__END__

=pod

=head1 NAME

Catmandu::Store::Simple::Bag - Index of all "files" in a Catmandu::Store::Simple "folder"

=head1 SYNOPSIS

    use Catmandu;

    my $store = Catmandu->store('Simple' , root => 't/data');

    my $index = $store->index;

    # List all containers
    $index->each(sub {
        my $container = shift;

        print "%s\n" , $container->{_id};
    });

    # Add a new folder
    $index->add({_id => '1234'});

    # Delete a folder
    $index->delete(1234);

    # Get a folder
    my $folder = $index->get(1234);

    # Get the files in an folder
    my $files = $index->files(1234);

    $files->each(sub {
        my $file = shift;

        my $name         = $file->_id;
        my $size         = $file->size;
        my $content_type = $file->content_type;
        my $created      = $file->created;
        my $modified     = $file->modified;

        $file->stream(IO::File->new(">/tmp/$name"), file);
    });

    # Add a file
    $files->upload(IO::File->new("<data.dat"),"data.dat");

    # Retrieve a file
    my $file = $files->get("data.dat");

    # Stream a file to an IO::Handle
    $files->stream(IO::File->new(">data.dat"),$file);

    # Delete a file
    $files->delete("data.dat");

    # Delete a folders
    $index->delete("1234");

=head1 DESCRIPTION

A L<Catmandu::Store::Simple::Bag> contains all "files" available in a
L<Catmandu::Store::Simple> FileStore "folder". All methods of L<Catmandu::Bag>,
L<Catmandu::FileStore::Index> and L<Catmandu::Droppable> are
implemented.

Every L<Catmandu::Bag> is also an L<Catmandu::Iterable>.

=head1 FOLDERS

All files in a L<Catmandu::Store::Simple> are organized in "folders". To add
a "folder" a new record needs to be added to the L<Catmandu::Store::Simple::Index> :

    $index->add({_id => '1234'});

The C<_id> field is the only metadata available in Simple stores. To add more
metadata fields to a Simple store a L<Catmandu::Plugin::SideCar> is required.

=head1 FILES

Files can be accessed via the "folder" identifier:

    my $files = $index->files('1234');

Use the C<upload> method to add new files to a "folder". Use the C<download> method
to retrieve files from a "folder".

    $files->upload(IO::File->new("</tmp/data.txt"),'data.txt');

    my $file = $files->get('data.txt');

    $files->download(IO::File->new(">/tmp/data.txt"),$file);

=head1 METHODS

=head2 each(\&callback)

Execute C<callback> on every "file" in the Simple store "folder". See L<Catmandu::Iterable> for more
iterator functions

=head2 exists($name)

Returns true when a "file" with identifier $name exists.

=head2 add($hash)

Adds a new "file" to the Simple store "folder". It is very much advised to use the
C<upload> method below to add new files

=head2 get($id)

Returns a hash containing the metadata of the file. The hash contains:

    * _id : the file name
    * size : file file size
    * content_type : the content_type
    * created : the creation date of the file
    * modified : the modification date of the file
    * _stream: a callback function to write the contents of a file to an L<IO::Handle>

If is very much advised to use the C<stream> method below to retrieve files from
the store.

=head2 delete($name)

Delete the "file" with name $name, if exists.

=head2 delete_all()

Delete all files in this folder.

=head2 upload(IO::Handle,$name)

Upload the IO::Handle reference to the Simple store "folder" and use $name as identifier.

=head2 stream(IO::Handle,$file)

Write the contents of the $file returned by C<get> to the IO::Handle.

=head1 SEE ALSO

L<Catmandu::Store::Simple::Bag> ,
L<Catmandu::Store::Simple> ,
L<Catmandu::FileStore::Index> ,
L<Catmandu::Plugin::SideCar> ,
L<Catmandu::Bag> ,
L<Catmandu::Droppable> ,
L<Catmandu::Iterable>

=cut