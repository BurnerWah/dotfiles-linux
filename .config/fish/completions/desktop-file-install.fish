set -l prog desktop-file-install
set -l has __fish_contains_opt

function __desktop-file-install_mime
    set -l data_home $XDG_DATA_HOME
    [ -z "$data_home" ] && set data_home $HOME/.local/share/
    set -l data_dirs $XDG_DATA_DIRS
    [ -z "$data_dirs" ] && set data_dirs /usr/local/share/:/usr/share/
    set data_dirs $data_home:$data_dirs
    set -l mime_dirs
    for path in (string split : $data_dirs)/mime
        [ -d "$path" ] && set -a mime_dirs $path
    end
    cat $mime_dirs/types
end

complete -c $prog -xa "(__fish_complete_suffix .desktop)"

complete -xc $prog -l dir -d "Directory to install files to" -a "(__fish_complete_directories)"
complete -xc $prog -s m -l mode -d "Destination file permissions"
complete -xc $prog -l vendor -d "Add a vendor prefix to the desktop files"
complete -c $prog -l delete-original -d "Delete the source desktop files"
complete -c $prog -l rebuild-mime-info-cache -d "Rebuild MIME types application database"
complete -xc $prog -l set-key -d "Set the KEY key to the value passed to the next --set-value option"
complete -xc $prog -l set-value -d "Set the key specified with the previous --set-key option to VALUE"
complete -xc $prog -l set-name -d "Set the name (key Name)" -n "! $has copy-generic-name-to-name"
complete -c $prog -l copy-name-to-generic-name -d "Copy the value of the Name key to GenericName" -n "! $has set-generic-name copy-generic-name-to-name"
complete -xc $prog -l set-generic-name -d "Set the generic name (key GenericName)" -n "! $has copy-name-to-generic-name"
complete -c $prog -l copy-generic-name-to-name -d "Copy the value of GenericName key to Name" -n "! $has set-name copy-name-to-generic-name"
complete -xc $prog -l set-comment -d "Set the comment (key Comment)"
complete -xc $prog -l set-icon -d "Set the icon (key Icon)"
complete -xc $prog -l add-category -d "Add to the list of categories (key Categories)"
complete -xc $prog -l remove-category -d "Remove from the list of categories (key Categories)"
complete -xc $prog -l add-mime-type -d "Add to the list of MIME types (key MimeType)" -a "(__desktop-file-install_mime)\t"
complete -xc $prog -l remove-mime-type -d "from the list of MIME types (key MimeType)" -a "(__desktop-file-install_mime)\t"
complete -xc $prog -l add-only-show-in -d "Add to list of desktop environments to show file"
complete -xc $prog -l remove-only-show-in -d "Remove from list of desktop environments to show file"
complete -xc $prog -l add-not-show-in -d "Add to list of desktop environments to hide file"
complete -xc $prog -l remove-not-show-in -d "Remove from list of desktop environments to hide file"
complete -xc $prog -l remove-key -d "Remove key from desktop file"
