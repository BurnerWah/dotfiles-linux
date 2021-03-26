function _printers::json -d "JSON Pretty printer"
    # prefer whatever does things the best (or the fastest)
    begin
        # formatter
        [ (command -s prettier tput | count) = 2 ] && prettier --parser json --print-width (tput cols)
        # we use tput to use as much of the terminal's width as possible
        or command -qs jq && jq
        # jq isn't as clean of a formatter as prettier but it's a lot faster and
        # more likely to be installed
    end | begin
        # highlighter
        command -qs bat && bat --language json --paging never --color always --style plain
        or command -qs highlight && highlight --syntax json --out-format truecolor
        # highlight can end up as a dependency for stuff so it might not be
        # intentionally installed. IMO it also isn't the greatest at highlighting
        # code, although it's perfectly serviceable.
        # TODO make sure output format is actually set correctly
    end
end
