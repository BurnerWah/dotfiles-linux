function _bin_manager_get_bins
    test -r ~/.config/bin/config.json || return
    jq -r '.bins[] | .path + "\t" + .url + " " + .version' ~/.config/bin/config.json
end

complete -c bin -l debug -d 'Enable debug mode'
complete -c bin -s h -l help -d 'help for bin'
complete -c bin -s v -l version -d 'version for bin'

complete -xc bin -n __fish_use_subcommand -a help -d 'Help about any command'
complete -xc bin -n __fish_use_subcommand -a install -d 'Installs the specified project'
complete -xc bin -n __fish_use_subcommand -a i -d 'Installs the specified project'
complete -xc bin -n __fish_use_subcommand -a list -d 'List binaries managed by bin'
complete -xc bin -n __fish_use_subcommand -a ls -d 'List binaries managed by bin'
complete -xc bin -n __fish_use_subcommand -a prune -d 'Prunes binaries that no longer exist in the system'
complete -xc bin -n __fish_use_subcommand -a remove -d 'Removes binaries managed by bin'
complete -xc bin -n __fish_use_subcommand -a rm -d 'Removes binaries managed by bin'
complete -xc bin -n __fish_use_subcommand -a update -d 'Updates one or multiple binaries managed by bin'
complete -xc bin -n __fish_use_subcommand -a u -d 'Updates one or multiple binaries managed by bin'

complete -c bin -n '__fish_seen_subcommand_from i install' -s f -l force -d 'Force the installation even if the file already exists'

complete -xc bin -n '__fish_seen_subcommand_from ls list prune'
complete -xc bin -n '__fish_seen_subcommand_from rm remove u update' -a "(_bin_manager_get_bins)"
