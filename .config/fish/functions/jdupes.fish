function jdupes
    if isatty stdout
        and command -qs systemd-run
        wrap-systemd.scope cmd-jdupes- jdupes $argv
    else
        command jdupes $argv
    end
end
