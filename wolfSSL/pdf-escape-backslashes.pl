#!/usr/bin/env perl
#
# Escape backslashes in the Doxybook2 API reference pages before the PDF
# build. pandoc reads a backslash followed by letters (for example "\xHH" in
# an API comment) as a raw LaTeX command and passes it to xelatex, which then
# fails with "Undefined control sequence". Such a backslash is doubled so that
# pandoc prints it literally.
#
# Left unchanged:
#   - fenced code blocks (``` or ~~~, closed by a fence of the same character
#     that is at least as long as the opening one)
#   - inline code spans, including spans that continue onto the next line
#   - existing Markdown escapes, i.e. a backslash followed by anything other
#     than a letter (this includes an already escaped "\\")
#
# Usage: perl pdf-escape-backslashes.pl FILE...   (files are edited in place)

use strict;
use warnings;

sub escape_prose {
    my ($text) = @_;
    $text =~ s{
        (                                   # 1: inline code span
            (?<!`) (`+) (?!`)               # 2: opening backtick run
            (?: (?! \n [ \t]* \n ) . )*?    #    content, not across a blank line
            (?<!`) \2 (?!`)                 #    closing run of the same length
        )
      | ( \\ [^A-Za-z] )                    # 3: existing escape, kept as is
      | \\ (?= [A-Za-z] )                   #    lone backslash before a letter
    }{ defined $1 ? $1 : defined $3 ? $3 : "\\\\" }gsxe;
    return $text;
}

for my $file (@ARGV) {
    open my $in, '<', $file or die "$file: $!\n";
    my @lines = <$in>;
    close $in;

    my ($out, $prose, $fence) = ('', '', '');
    for my $line (@lines) {
        if ($fence eq '') {
            if ($line =~ /^[ \t]*(`{3,}|~{3,})/) {
                $out .= escape_prose($prose) . $line;
                $prose = '';
                $fence = $1;
            }
            else {
                $prose .= $line;
            }
        }
        else {
            $out .= $line;
            my $c = substr($fence, 0, 1);
            if ($line =~ /^[ \t]*(\Q$c\E{3,})\s*$/
                    && length($1) >= length($fence)) {
                $fence = '';
            }
        }
    }
    $out .= escape_prose($prose);

    open my $o, '>', $file or die "$file: $!\n";
    print {$o} $out;
    close $o or die "$file: $!\n";
}
