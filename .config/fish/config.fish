#!/usr/bin/env fish

# Push ssh sessions into a user scope
if string match --quiet '0::/user.slice/user-*.slice/session-*.scope' </proc/self/cgroup
    exec systemd-run --user --scope --same-dir --no-block --quiet --collect --unit run-ssh-fish-$fish_pid fish $argv
end

if command -qs zoxide
    zoxide init fish | source
end

if command -qs vivid
    set -gx LS_COLORS (vivid generate burner)
    # This was done with psub before but ALE didn't like that
end
