package UUID4::Tiny 0.001;

use strict;
use warnings;

use Carp qw/carp croak/;
use Exporter qw/import/;

our @EXPORT_OK = qw/
    create_uuid
    create_uuid_string
    is_uuid_string
    is_uuid4_string
    string_to_uuid
    uuid_to_string
    /;

our %EXPORT_TAGS = (all => \@EXPORT_OK);

use constant {
    GRND_NONBLOCK => 0x0001,
    RANDOM_BYTES  => 16,
};

sub create_uuid {
    my $call = syscall( 318, my $uuid = "\0" x RANDOM_BYTES,
        RANDOM_BYTES, GRND_NONBLOCK );
    croak "Syscall Error: $!" if $call == -1;
    croak 'Insufficient Bytes Copied' if $call < RANDOM_BYTES;

    vec( $uuid, 13, 4 ) = 0x4;    # version
    vec( $uuid, 35, 2 ) = 0x2;    # variant

    return $uuid;
}

sub create_uuid_string { uuid_to_string( create_uuid() ) }

sub is_uuid_string {
    $_[0] =~ /^[0-9a-f]{8}(?:-[0-9a-f]{4}){3}-[0-9a-f]{12}$/i;
}

sub is_uuid4_string {
    $_[0] =~ /^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;
}

sub string_to_uuid {
    my $string = shift;
    if ( length $string == 16 ) {
        # Emulates UUID::Tiny behavior to
        # prevent accidental double conversion
        carp 'Input not converted: assumed to be UUID bytes';
        return $string;
    }
    pack 'H*', $string =~ y/-//dr;
}

sub uuid_to_string {
    my $uuid = shift;
    if ( is_uuid_string $uuid ) {
        # Emulates UUID::Tiny behavior to
        # prevent accidental double conversion
        carp 'Input not converted: identified as UUID string';
        return $uuid;
    }
    join '-', unpack 'H8H4H4H4H12', $uuid;
}

1;
