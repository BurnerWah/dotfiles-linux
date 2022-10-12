function ninja
    if isatty stdout
        and command -qs systemd-run
        wrap-systemd.scope cmd-ninja- ninja $argv
    else
        command ninja $argv
    end
end
