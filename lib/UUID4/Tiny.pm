package UUID4::Tiny;

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

sub create_uuid {
    my $call = syscall( 318, my $uuid = "\0" x 16, 16, 0x0001 );
    croak "Syscall Error: $!" if $call == -1;
    croak 'Insufficient Bytes Copied' if $call < 16;

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

__END__

=head1 NAME

UUID4::Tiny - Cryptographically secure v4 UUIDs for Linux x64

=head1 SYNOPSIS

 use UUID4::Tiny qw/
    create_uuid
    create_uuid_string
    is_uuid_string
    is_uuid4_string
    string_to_uuid
    uuid_to_string
    /;

 my $uuid        = create_uuid;
 my $uuid_string = create_uuid_string;

 $uuid        = string_to_uuid $uuid_string;
 $uuid_string = uuid_to_string $uuid;

 if ( is_uuid4_string $uuid_string ) { ... }

=head1 DESCRIPTION

Uses the Linux getrandom() system call to generate a version 4 UUID.

Requires Linux kernel 3.17 or newer for getrandom().

=head1 FUNCTIONS

=head2 create_uuid

    my $uuid = create_uuid;

Gets a series of 16 random bytes via the getrandom() system call
and sets the UUID4 version and variant on those bytes.

=head2 uuid_to_string

    my $uuid_string = uuid_to_string( create_uuid );

Converts a 16 byte UUID to a canonical 8-4-4-4-12 format UUID string.

=head2 create_uuid_string

    my $uuid_string = create_uuid_string;

Shortcut for uuid_to_string called on create_uuid.

=head2 string_to_uuid

    my $uuid = string_to_uuid( $uuid_string );

Converts a canonical 8-4-4-4-12 format UUID string to a 16 byte UUID.

=head2 is_uuid_string

    if ( is_uuid_string( $input ) ) { ... }

Checks if the input matches the canonical 8-4-4-4-12 format.

=head2 is_uuid4_string

    if ( is_uuid4_string( $input ) ) { ... }

Similar to is_uuid_string, additionaly checking that the
variant and version are correct for UUID v4.
