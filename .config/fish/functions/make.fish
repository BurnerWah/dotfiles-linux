function make
    if isatty stdout
        and command -qs systemd-run
        wrap-systemd.scope cmd-make- make $argv
    else
        command make $argv
    end
end
