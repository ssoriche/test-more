package Test::Builder::NoOutput;

use strict;
use warnings;

use base qw(Test::Builder);


=head1 NAME

Test::Builder::NoOutput - A subclass of Test::Builder which prints nothing

=head1 SYNOPSIS

    use Test::Builder::NoOutput;

    my $tb = Test::Builder::NoOutput->new;

    ...test as normal...

    my $output = $tb->read;

=head1 DESCRIPTION

This is a subclass of Test::Builder which traps all its output.
It is mostly useful for testing Test::Builder.

=head3 read

    my $all_output = $tb->read;
    my $output     = $tb->read($stream);

Returns all the output (including failure and todo output) collected
so far.  It is destructive, each call to read clears the output
buffer.

If $stream is given it will return just the output from that stream.
$stream's are...

    out         output()
    err         failure_output()
    all         all outputs

Defaults to 'all'.

=cut

my $Test = __PACKAGE__->new;

sub create {
    my $class = shift;
    my $self = $class->SUPER::create(@_);

    my %outputs = (
        all  => '',
        out  => '',
        err  => '',
    );
    $self->{_outputs} = \%outputs;

    require Test::Builder::Tee;
    tie *OUT,  "Test::Builder::Tee", \$outputs{all}, \$outputs{out};
    tie *ERR,  "Test::Builder::Tee", \$outputs{all}, \$outputs{err};

    $self->output(*OUT);
    $self->failure_output(*ERR);

    return $self;
}

sub read {
    my $self = shift;
    my $stream = @_ ? shift : 'all';

    my $out = $self->{_outputs}{$stream};

    $self->{_outputs}{$stream} = '';

    # Clear all the streams if 'all' is read.
    if( $stream eq 'all' ) {
        my @keys = keys %{$self->{_outputs}};
        $self->{_outputs}{$_} = '' for @keys;
    }

    return $out;
}

1;
