# development has been put on hold by podman no longer working on my computer

set -l is_subcmd __fish_use_subcommand
set -l seen __fish_seen_subcommand_from

function __toolbox_containers
    toolbox list -c 2>/dev/null | tail -n +2 2>/dev/null | string replace -r '^\S+\s+(\S+)\s.*' '$1'
end

function __toolbox_images
    toolbox list -i 2>/dev/null | tail -n +2 2>/dev/null | string replace -r '^\S+\s+(\S+)\s.*' '$1'
end

complete -c toolbox -s v -l verbose -d "Print debug information"
complete -c toolbox -s h -l help -d "Open manual"

complete -c toolbox -n "$is_subcmd" -xa create -d "Create a new toolbox container"
complete -c toolbox -n "$is_subcmd" -xa enter -d "Enter a toolbox container for interactive use"
complete -c toolbox -n "$is_subcmd" -xa help -d "Display help information about Toolbox"
complete -c toolbox -n "$is_subcmd" -xa init-container -d "Initialize a running container"
complete -c toolbox -n "$is_subcmd" -xa list -d "List existing toolbox containers and images"
complete -c toolbox -n "$is_subcmd" -xa reset -d "Remove all local podman (and toolbox) state"
complete -c toolbox -n "$is_subcmd" -xa rm -d "Remove one or more toolbox containers"
complete -c toolbox -n "$is_subcmd" -xa rmi -d "Remove one or more toolbox images"
complete -c toolbox -n "$is_subcmd" -xa run -d "Run a command in an existing toolbox container"

complete -fc toolbox -n "$seen create"
complete -c toolbox -n "$seen create" -l candidate-registry -d "Pull base image from candidate-registry.fedoraproject.org"
complete -xc toolbox -n "$seen create" -s c -l container -d "Set the container's name"
complete -xc toolbox -n "$seen create" -s i -l image -d "Change the base image's name" -a "(__toolbox_images)"
complete -xc toolbox -n "$seen create enter run" -s r -l release -d "Use a different release than the host"
complete -xc toolbox -n "$seen create enter run" -s d -l distro -d "Use a specific distro" -a "fedora rhel"

# complete -fc toolbox -n "$seen enter" -a "(complete -C 'podman attach ')"
complete -fc toolbox -n "$seen enter" -a "(__toolbox_containers)"

complete -fc toolbox -n "$seen list"
complete -c toolbox -n "$seen list" -s c -l containers -d "List only toolbox containers"
complete -c toolbox -n "$seen list" -s i -l images -d "List only toolbox images"

complete -xc toolbox -n "$seen rm" -a "(__toolbox_containers)"
complete -c toolbox -n "$seen rm" -s a -l all -d "Remove all toolbox containers"
complete -c toolbox -n "$seen rm" -s f -l force -d "Force the removal of running and paused toolbox containers"
complete -xc toolbox -n "$seen rmi" -a "(__toolbox_images)"
complete -c toolbox -n "$seen rmi" -s a -l all -d "Remove all toolbox images"
complete -c toolbox -n "$seen rmi" -s f -l force -d "Force the removal of images in use by containers"

complete -fc toolbox -n "$seen init-container"
complete -xc toolbox -n "$seen init-container" -l gid -d "Set the user's GID"
complete -xc toolbox -n "$seen init-container" -l home -d "Set the user's HOME directory"
complete -c toolbox -n "$seen init-container" -l home-link -d "Make /home a symbolic link to /var/home"
complete -c toolbox -n "$seen init-container" -l media-link -d "Make /media a symbolic link to /run/media"
complete -c toolbox -n "$seen init-container" -l mnt-link -d "Make /mnt a symbolic link to /var/mnt"
complete -c toolbox -n "$seen init-container" -l monitor-host -d "Ensure certain config files are synced with the host"
complete -xc toolbox -n "$seen init-container" -l shell -d "Set the user's SHELL"
complete -xc toolbox -n "$seen init-container" -l uid -d "Set the user's UID"
complete -xc toolbox -n "$seen init-container" -l user -d "Set the user's login name"
