package JSON::Patch::Exception;

use strict;
use warnings;

use overload (q|""| => "to_string");
use Carp;
use Class::Accessor::Lite (
    new => 0,
    rw  => [qw/code message path/]
);
use Exporter qw(import);

our @CODES = (qw/
    ERROR_INVALID_OPERATION_TYPE
    ERROR_NOT_EXIST_OP_FIELD
    ERROR_UNSUPPORTED_OP
    ERROR_INVALID_OPERATION_FIELD
    ERROR_INVALID_POINTER_ERROR
    ERROR_POINTER_REFERENCES_NON_EXISTENCE_VALUE
/);

our @EXPORT_OK = (@CODES);
our %EXPORT_TAGS = (
    codes => [ @CODES, ],
);

sub ERROR_INVALID_OPERATION_TYPE { 1; }
sub ERROR_NOT_EXIST_OP_FIELD { 2; }
sub ERROR_UNSUPPORTED_OP { 3; }
sub ERROR_INVALID_OPERATION_FIELD { 4; }
sub ERROR_INVALID_POINTER_ERROR { 5; }
sub ERROR_POINTER_REFERENCES_NON_EXISTENCE_VALUE { 6; }

sub new {
    my ($class, %args) = @_;
    bless \%args => $class;
}

sub throw {
    my ($class, %args) = @_;
    croak $class->new(%args);
}

sub to_string {
    my $self = shift;
    sprintf(
        "%s at %s (code: %d)", 
        $self->{message},
        $self->{path},
        $self->{code},
    );
}

1;
