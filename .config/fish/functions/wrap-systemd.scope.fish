function wrap-systemd.scope
    systemd-run --user --scope --same-dir --no-block --quiet --collect --unit $argv[1](string replace -a -- - '' < /proc/sys/kernel/random/uuid) $argv[2..-1]
    # systemd-run --user --scope --same-dir --no-block --quiet --collect --unit {$argv[1]}{$fish_pid}-(random) $argv[2..-1]
end
