# NAME

UUID4::Tiny - Cryptographically secure v4 UUIDs for Linux x64

# SYNOPSIS

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

# DESCRIPTION

Uses the Linux getrandom() system call to generate a version 4 UUID.

Requires Linux kernel 3.17 or newer for getrandom().

# FUNCTIONS

## create\_uuid

    my $uuid = create_uuid;

Gets a series of 16 random bytes via the getrandom() system call
and sets the UUID4 version and variant on those bytes.

## uuid\_to\_string

    my $uuid_string = uuid_to_string( create_uuid );

Converts a 16 byte UUID to a canonical 8-4-4-4-12 format UUID string.

## create\_uuid\_string

    my $uuid_string = create_uuid_string;

Shortcut for uuid\_to\_string called on create\_uuid.

## string\_to\_uuid

    my $uuid = string_to_uuid( $uuid_string );

Converts a canonical 8-4-4-4-12 format UUID string to a 16 byte UUID.

## is\_uuid\_string

    if ( is_uuid_string( $input ) ) { ... }

Checks if the input matches the canonical 8-4-4-4-12 format.

## is\_uuid4\_string

    if ( is_uuid4_string( $input ) ) { ... }

Similar to is\_uuid\_string, additionaly checking that the
variant and version are correct for UUID v4.
