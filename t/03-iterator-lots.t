#!/usr/bin/env raku

use Test;
use Math::Primesieve;

plan 2;

unless Version.new(Math::Primesieve.version) ~~ v7+
{
    skip-rest "Old version of library, skipping";
    exit;
}

ok my $iterator = Math::Primesieve::iterator.new, 'Make an iterator';

my $sum;
$sum += $iterator.next for ^1000000;

is $sum, 7472966967499, 'Sum lots of primes';

done-testing;
