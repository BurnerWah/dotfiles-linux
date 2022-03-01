function __gtk_launch_apps -d "internal completion function"
    set -l dirs $XDG_DATA_HOME/applications
    for i in (string split : $XDG_DATA_DIRS)
        set -a dirs (echo $i/applications | string replace // /)
    end
    # set -S dirs

    # fd -d 1 -e desktop . $dirs | string replace -r '^/.+/' '' | string replace -r '.desktop$' ''
    # this is imperfect since we need to also invert a match on NoDisplay=true
    # we also need to limit it to just .desktop files with a max depth of 1.
    rg -l -e '^Exec=' -e '^Type=Application' $dirs 2>/dev/null | string replace -r '^/.+/' '' | string replace -r '.desktop$' ''
    # rg -l '^Exec=' $dirs
end

complete -c gtk-launch -n __fish_use_subcommand -xa "(__gtk_launch_apps)"
