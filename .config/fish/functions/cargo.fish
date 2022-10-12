function cargo
    if isatty stdout
        and command -qs systemd-run
        wrap-systemd.scope cmd-cargo- cargo $argv
    else
        command cargo $argv
    end
end
