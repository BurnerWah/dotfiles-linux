# I occasionally use this to keep my internet from cutting out
if command -qs daemonize
    function pingd -w ping -d "Ping daemon"
        command daemonize (which nice) -n 10 -- ping $argv
    end
end
