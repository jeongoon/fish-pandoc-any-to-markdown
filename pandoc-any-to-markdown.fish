#!/usr/bin/env fish
# filename: pandoc-any-to-markdown.fish

set -l input_filepath $argv[1]

if not test -f $input_file
    echo \
"Usage: <document file path> &> <output file path>
        will print out converted text to stdout.
"
    exit 1;
end

set -l numof_printed -1
# ^ indicating phase -1: meta not found (>=0): meta found
set -l pandoc_from (string split "." $input_filepath | tail -n1)
# ^ pandoc reader relys on extension

for x in once
    while read -l line
        if string match -q --regex '^---' -- "$line"
            set numof_printed (math "$numof_printed + 1")
            if test $numof_printed -gt 0
                echo $line
                break;
            end
        end

        if test $numof_printed -ge 0
            echo $line
            set numof_printed (math "$numof_printed + 1")
        end
    end

    pandoc -f $pandoc_from -t markdown -
end < $argv[1]
