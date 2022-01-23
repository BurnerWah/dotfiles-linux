set -l seen __fish_seen_subcommand_from
set -l needs_subcmd __fish_use_subcommand

function __whalebrew_images
    whalebrew list --no-headers | string replace -r '\s+' '\t'
end

complete -c whalebrew -s h -l help -d "Show help"

complete -xc whalebrew -n "$needs_subcmd || $seen help" -a edit -d "Edit a package file"
complete -xc whalebrew -n "$needs_subcmd" -a help -d "Help about any command"
complete -xc whalebrew -n "$needs_subcmd || $seen help" -a install -d "Install a package"
complete -xc whalebrew -n "$needs_subcmd || $seen help" -a lint -d "lints a package"
complete -xc whalebrew -n "$needs_subcmd || $seen help" -a list -d "List installed packages"
complete -xc whalebrew -n "$needs_subcmd || $seen help" -a search -d "Search for packages"
complete -xc whalebrew -n "$needs_subcmd || $seen help" -a uninstall -d "Uninstall a package"
complete -xc whalebrew -n "$needs_subcmd || $seen help" -a version -d "Print the version number of Whalebrew"

complete -c whalebrew -n "$seen install uninstall" -s y -l assume-yes -d "Assume 'yes' as answer to all prompts and run non-interactively"

complete -c whalebrew -n "$seen install" -x -s e -l entrypoint -d "Custom entrypoint to run the image with"
complete -c whalebrew -n "$seen install" -s f -l force -d "Replace existing package if already exists"
complete -c whalebrew -n "$seen install" -x -s n -l name -d "Name to give installed package"
complete -c whalebrew -n "$seen install" -l strict -d "Fail installing the image if it contains any skippable error"

complete -c whalebrew -n "$seen list" -l no-headers -d "Hide column headers for output"

complete -c whalebrew -n "$seen edit uninstall" -xa "(__whalebrew_images)"
