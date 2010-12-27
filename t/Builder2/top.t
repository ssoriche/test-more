#!/usr/bin/perl -w

use strict;
use warnings;

BEGIN { require 't/test.pl' }
plan tests => 4;

use Test::Builder2;
my $tb = Test::Builder2->create;

sub outer {
    $tb->assert_start;
    my @ret = $tb->top_stack->from_top("outer");
    push @ret, inner(@_);
    $tb->assert_end;

    return @ret;
}

sub inner {
    $tb->assert_start;
    my $ret = $tb->top_stack->from_top("inner");
    $tb->assert_end;

    return $ret;
}

ok eq_array($tb->top_stack->asserts, []), "top_stack() empty";

#line 29
ok eq_array([inner()], ["inner at $0 line 29"]), "from_top() shallow";
ok eq_array([outer()], ["outer at $0 line 30", "inner at $0 line 30"]), "from_top() deep";

ok eq_array( $tb->top_stack->asserts, []), "top_stack() still empty";
