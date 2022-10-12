# Unfinished distrobox completions

function __distrobox_manager
    if set -q DBX_CONTAINER_MANAGER
        command $DBX_CONTAINER_MANAGER $argv
    else if command -qs podman
        command podman $argv
    else if command -qs docker
        command docker $argv
    end
end

function __distrobox_list_containers
    __distrobox_manager ps -a --filter volume=/usr/bin/distrobox-host-exec --format "{{.Names}}\t{{.Image}}" $argv
end

complete -xc distrobox -n __fish_use_subcommand -a create
complete -xc distrobox -n __fish_use_subcommand -a enter
complete -xc distrobox -n __fish_use_subcommand -a list
complete -xc distrobox -n __fish_use_subcommand -a stop
complete -xc distrobox -n __fish_use_subcommand -a rm
complete -xc distrobox -n __fish_use_subcommand -a version
# complete -c distrobox -n "__fish_seen_subcommand_from create" -w distrobox-create
# complete -c distrobox -n "__fish_seen_subcommand_from enter" -w distrobox-enter
# complete -c distrobox -n "__fish_seen_subcommand_from list" -w distrobox-list
# complete -c distrobox -n "__fish_seen_subcommand_from stop" -w distrobox-stop
# complete -c distrobox -n "__fish_seen_subcommand_from rm" -w distrobox-rm

complete -c distrobox-enter -s e -s - -d "end arguments"
complete -c distrobox-enter -s T -l no-tty -d "Don't instantiate a tty"
complete -c distrobox-enter -o nw -l no-workdir -d "Start from container's home directory"
complete -c distrobox-enter -s a -l additional-flags -d "Additional flags to pass to the container manager command"

complete -c distrobox-rm -s f -l force -d "Force deletion"

for cmd in distrobox-create distrobox-enter
    complete -c $cmd -s d -l dry-run -d "Only print the container manager command generated"
end

for cmd in distrobox-enter distrobox-rm
    complete -c $cmd -x -a "(__distrobox_list_containers)"
    complete -c $cmd -s n -l name -d "Name for the distrobox" -a "(__distrobox_list_containers)"
end

for cmd in distrobox-create distrobox-enter distrobox-list distrobox-rm distrobox-stop
    complete -c $cmd -s r -l root -d "Launch podman/docker with root privileges"
end

for cmd in distrobox-create distrobox-enter distrobox-export distrobox-host-exec distrobox-init distrobox-list distrobox-rm distrobox-stop
    complete -c $cmd -s h -l help -d "Show help"
    complete -c $cmd -s v -l verbose -d "Show more verbosity"
    complete -c $cmd -s V -l version -d "Show version"
end
