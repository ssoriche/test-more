#!/usr/bin/perl

use strict;
use warnings;

BEGIN { require 't/test.pl' }

use_ok( 'Test::Builder2::Stack' );

# bare type
{
    ok my $stack = Test::Builder2::Stack->new , q{fresh stack} ;
    ok eq_array $stack->items, [], q{empty stack};
    ok $stack->push(1..3), q{push};
    ok eq_array $stack->items, [1..3], q{stack};
    ok $stack->unshift('nil'), q{unshift};
    ok eq_array $stack->items, ['nil',1..3], q{stack};
    is $stack->pop, 3, q{pop};
    is $stack->shift, 'nil', q{shift};
    ok eq_array $stack->items, [1,2], q{stack};
    is $stack->count, 2, q{count};
}

# simple type
{
    ok my $stack = Test::Builder2::Stack->new(type => 'Int') , q{fresh stack} ;
    ok $stack->push(1), q{push int};
    eval { $stack->push(undef) };
    like $@, qr{Attribute \(items\) does not pass the type constraint}, q{type check}; 
    ok eq_array $stack->items, [1];


}

done_testing;
