function dnf
    command ionice -c best-effort -n 7 dnf $argv
end
