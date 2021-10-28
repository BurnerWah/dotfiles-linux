# This is for usage with systemd-run wrappers
function _generate_rand_string
    string replace -a -- - '' </proc/sys/kernel/random/uuid
end
