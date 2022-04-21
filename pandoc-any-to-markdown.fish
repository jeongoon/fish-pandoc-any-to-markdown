#!/usr/bin/env fish
# filename: pandoc-any-to-markdown.fish

set -g pandoc_any_to_markdown_version 0.1.2

set -l input_filepath $argv[1]

if not test -f $input_file
    echo \
"Usage: <document file path> > <output file path>
        will print out converted text to stdout.
"
    exit 1;
end

# --| numof_printed
# --  -1 : metadata not found yet
# --   0 : metadata entered
# --   * : metadata is printing
set -l numof_printed -1

# --| convert_from
# --  option which is passed to pandoc with `-f` option

set -l convert_from (string split "." $input_filepath | tail -n1)
# ^ pandoc reader relys on extension

begin
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

    pandoc -f $convert_from -t markdown -
end < $argv[1]
