#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;


my $title_file = './number_to_title.txt';
my $cit_file   = './citations.txt';
my $section_file = './section_starts.txt';

die "Title file not found: $title_file\n" unless -e $title_file;
die "Citation file not found: $cit_file\n" unless -e $cit_file;
die "Section start file not found: $section_file\n" unless -e $section_file;


sub load_titles($) {
    my $file = shift;

    open(my $fh, $file) or die "Can't open $file: $!\n";

    my $hash;

    while (<$fh>) {
        chop;
        my ($k, $v) = split(',', $_);
        $hash->{$k} = $v;
    }

    close $fh;
    return $hash;
}


# play->act->scene->number
# Act = number or Arg.* or Prologue
# Scene = number or null if Arg or Prologue
# Number = start number of section
#
sub load_sections($) {
    my $file = shift;

    open(my $fh, $file) or die "Can't open $file: $!\n";

    my $hash;

    while (<$fh>) {
        chop;
        my ($play, $act, $scene, $line) = split(',', $_);
        $hash->{$play}->{$act}->{$scene} = $line;
    }

    close $fh;
    return $hash;
}

sub parse_citations($$) {
    my $file = shift;
    my $sections = shift;

    open(my $fh, $file) or die "Can't open $file: $!\n";

    while (<$fh>) {
        chop;
        my ($play, $act, $scene_or_line, $line_or_null) = split(':', $_);

        # output play:prologue:line as-is, assume from line 1
        if (! $scene_or_line) { # either "020:prol. line" or "20:123"
            if ($act =~ /^\d+$/) {
                print "$_,$play:1,1,$act\n";
            } else {
                my ($prol, $line) = split/\s+/, $act;
                print "$_,$play:$prol:$line\n";
            }
            next;
        }
        # output play:act:scene:line is offset from start of scene, lookup startup
        if ($line_or_null) {
            my $start = $sections->{$play}->{$act}->{$scene_or_line};

            if (!$start) {
                warn "ERROR: no start for $_\n";
                warn Dumper $sections->{$play};
            } else {
                my $line = $start + $line_or_null;
                print "$_,$play:$act:$scene_or_line:$line\n";
            }
        } else {
            if ($act =~ /^\d+$/) {
                print "$_,$play:$act:1:$scene_or_line\n";
            } else {
                print "$_,$play:$act:$scene_or_line\n";
            }
        }
    }

    close $fh;
}


my $titles = load_titles($title_file);
my $sections = load_sections($section_file);

parse_citations($cit_file, $sections);
