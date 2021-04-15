#!/usr/bin/env perl

use strict;
use warnings;

while (<STDIN>) {
    next unless /^\<div/;
    chomp;
    /\<bibl n="(Perseus:abo:phi,0119.*?)"\>/;
    print $1, "\n" if $1;
}
