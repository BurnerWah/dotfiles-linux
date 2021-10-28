function go
    if isatty stdout
        and command -qs systemd-run
        wrap-systemd.scope run-golang- go $argv
    else
        command go $argv
    end
end
