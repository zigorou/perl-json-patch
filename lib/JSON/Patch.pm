package JSON::Patch;

use 5.008_001;
use strict;
use warnings;

use JSON::Patch::Context;
use JSON::Patch::Exception qw(:codes);
use Module::Load;
use Module::Loaded;

our $VERSION = '0.01';
our @CORE_OPS = qw/Add Remove Replace Move Copy Test/;
our %OP = ();

__PACKAGE__->load_operators(@CORE_OPS);

sub load_operators {
    my $class = shift;
    my @operators = ref $_[0] ? @{$_[0]} : @_;
    for (@operators) {
        $class->load_operator($_);
    }
}

sub load_operator {
    my ($class, $operator) = @_;
    if (index($operator, "+") == -1) {
        $operator = "JSON::Patch::Operator::" . $operator;
    }
    else {
        $operator = substr($operator, 1);
    }

    unless (is_loaded($operator)) {
        load $operator;
        $OP{$operator->name} = $operator;
    }
}

sub new {
    my $class = shift;
    my $args = ref $_[0] ? $_[0] : { @_ };
    %$args = (
        extra_operators => [],
        operations      => [],
        %$args,
        op              => {},
    );

    $class->load_operators($args->{extra_operators});
    %{$args->{op}} = (
        map { $_->name => $_ }
        grep { UNIVERSAL::can($_, "name") && exists $OP{$_->name} }
        (( map { "JSON::Patch::Operator::" . $_ } @CORE_OPS ), @{$args->{extra_operators}})
    );

    my $self = bless $args => $class;
    $self->validate;
    return $self;
}

sub validate {
    my $self = shift;
    my $pos = 0;
    for my $operation (@{$self->{operations}}) {
        $self->validate_operation($operation, $pos++);
    }
}

sub validate_operation {
    my ($self, $operation, $pos) = @_;

    unless (ref $operation eq "HASH") {
        JSON::Patch::Exception->throw(
            code => ERROR_INVALID_OPERATION_TYPE,
            message => "Invalid operation type",
            path => "/$pos",
        );
    }

    unless (exists $operation->{op}) {
        JSON::Patch::Exception->throw(
            code => ERROR_NOT_EXIST_OP_FIELD,
            message => "Not exist op field",
            path => "/$pos",
        );
    }

    unless (exists $self->{op}{$operation->{op}}) {
        JSON::Patch::Exception->throw(
            code => ERROR_NOT_EXIST_OP_FIELD,
            message => sprintf("Unsupported operator (%s)", $operation->{op}),
            path => "/$pos/op",
        );
    }

    my $operator = $self->{op}{$operation->{op}};
    $operator->validate($operation, $pos);

    return 1;
}

sub patch {
    my ($self, $document) = @_;

    my $ctx = JSON::Patch::Context->new(+{
        document => $document,
    });

    my $pos = 0;
    for my $operation (@{$self->{operations}}) {
        my $operator = $self->{op}{$operation->{op}};
        $operator->apply($ctx, $operation);
        last unless $ctx->result;
        $ctx->pos(++$pos);
    }

    return $ctx;
}

1;

__END__

=encoding utf8

=head1 NAME

JSON::Patch - ...

=head1 SYNOPSIS

  use JSON::Patch;

=head1 DESCRIPTION

JSON::Patch is

B<THIS IS A DEVELOPMENT RELEASE. API MAY CHANGE WITHOUT NOTICE>.

=head1 AUTHOR

Toru Yamaguchi E<lt>zigorou@cpan.orgE<gt>

=head1 SEE ALSO

=head1 LICENSE

Copyright (C) Toru Yamaguchi

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
