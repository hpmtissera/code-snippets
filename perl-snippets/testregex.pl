#!/usr/share/netld/perl/bin/perl

use strict;
use warnings;

my $string1 = ' REVISIONS                                                                                                                       |PREV_REVISION_TIME';
my $string2 = '  revisions                           | mime_type';

print "$string1\n";
print "$string2\n";

my $result1 = _has_column($string1, 'REVISIONS', 'PREV_REVISION_TIME');
my $result2 = _has_column($string2, 'revisions', 'mime_type');

print "Result for string 1 : $result1\n";
print "Result for string 2 : $result2\n";

sub _has_column
{
    my ($capture, $table, $column) = @_;
    if ($capture =~ /^\s*$table\s*\|\s?$column\s*$/im)
    {
        return 'Match';
    }

    return 'No Match';
}