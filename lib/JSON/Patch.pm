package JSON::Patch;

use 5.008_001;
use strict;
use warnings;

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
        extra_operators => [qw//],
        %$args,
        operators => {},
    );

    $class->load_operators($args->{extra_operators});
    %{$args->{operators}} = (
        map { $_->name => $_ }
        grep { UNIVERSAL::can($_, "name") && exists $OP{$_->name} }
        (( map { "JSON::Patch::Operator::" . $_ } @CORE_OPS ), @{$args->{extra_operators}})
    );

    bless $args => $class;
}

sub patch {
    my ($self, $document, $operations) = @_;
    my $ctx = +{
        document => $document,
        operations => $operations,
        result => 1,
    };

    my $is_success = 1;

    for my $operation (@$operations) {
        my $operator = $OP{$operation->{op}};
        $is_success = $operator->patch($ctx, $operation);
        last unless $is_success;
    }

    $ctx->{result} = $is_success;
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
