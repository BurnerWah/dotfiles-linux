# Heavily patched completions for dnf
# Optimized for speed and accuracy

set -l seen __fish_seen_subcommand_from
set -l has __fish_contains_opt
set -l needs_subcmd __fish_use_subcommand
set -l no_args __fish_no_arguments

function __dnf_argparse
    set -l saved_args $argv
    set -l global_args
    set -l cmd (commandline -opc)
    set -e cmd[1]
    if argparse -s (__dnf_global_optspecs) -- $cmd
    end
end
function __dnf_global_optspecs
    string join \n c-config= q-quiet v-verbose -version -installroot= -nodocs -noplugins -enableplugin=+ \
        -disableplugin=+ -releasever= -setopt=+ -skip-broken h-help -allowerasing b-best -nobest C-cacheonly \
        R-randomwait= d-debuglevel= -debugsolver -showduplicates e-errorlevel= -obsoletes -rpmverbosity= \
        y-assumeyes -assumeno -enablerepo=+ -disablerepo=+ -repo=+ -repoid=+ -enable -disable x-exclude=+ \
        -disableexcludes=+ -repofrompath=+ -noautoremove -nogpgcheck -color= -refresh 4 6 -destdir= -downloaddir= \
        -downloadonly -comment= -bugfix -enhancement -newpackage -security -advisory=+ -bz=+ -cve=+ -sec-severity= \
        -forcearch=
end

if type -q sqlite3
    function __dnf_list_installed_packages
        sqlite3 -readonly /var/cache/dnf/packages.db "SELECT pkg FROM installed" | string replace -r -- '-[^-]*-[^-]*$' ''
    end
    function __dnf_list_available_packages
        set -l tok (commandline -ct | string collect)
        if string match -q -- '*/*' $tok
            __fish_complete_suffix .rpm
            return
        end
        __fish_complete_suffix .rpm | string match -r -- '.*\\.rpm$'
        sqlite3 -readonly /var/cache/dnf/packages.db "SELECT pkg FROM available WHERE pkg LIKE \"$tok%\"" 2>/dev/null | string replace -r -- '-[^-]*-[^-]*$' ''
    end
    function __dnf_list_transactions
        sqlite3 -readonly -tabs /var/lib/dnf/history.sqlite "SELECT id, cmdline FROM trans" 2>/dev/null
    end
else
    function __dnf_list_installed_packages
        dnf repoquery --cacheonly "$cur*" --qf "%{NAME}" --installed
    end
    function __dnf_list_available_packages
        set -l tok (commandline -ct | string collect)
        set -l files (__fish_complete_suffix .rpm)
        if string match -q -- '*/*' $tok
            # Fast path - package names can't contain slashes, so show files.
            string join -- \n $files
            return
        end
        set -l results
        # dnf --cacheonly list --available gives a list of non-installed packages dnf is aware of,
        # but it is slow as molasses. Unfortunately, sqlite3 is not available oob (Fedora Server 32).
        if type -q sqlite3
            # This schema is bad, there is only a "pkg" field with the full
            #    packagename-version-release.fedorarelease.architecture
            # tuple. We are only interested in the packagename.
            set results (sqlite3 /var/cache/dnf/packages.db "SELECT pkg FROM available WHERE pkg LIKE \"$tok%\"" 2>/dev/null |
            string replace -r -- '-[^-]*-[^-]*$' '')
        else
            set results (dnf repoquery --cacheonly "$tok*" --qf "%{NAME}" --available 2>/dev/null)
        end
        if set -q results[1]
            set results (string match -r -- '.*\\.rpm$' $files) $results
        else
            set results $files
        end
        string join \n $results
    end
    function __dnf_list_transactions
        if type -q sqlite3
            sqlite3 /var/lib/dnf/history.sqlite "SELECT id, cmdline FROM trans" 2>/dev/null | string replace "|" \t
        end
    end
end

function __dnf_list_aliases
    dnf alias list | string replace -r "^Alias\s+(\S+?)='(.*)'\$" '$1\t$2'
end

### COMPAT ###
# complete -c dnf -n "$seen deplist" -w "dnf repoquery --deplist"

# Alias
complete -c dnf -n "$needs_subcmd" -xa alias -d "Manage aliases"
complete -c dnf -n "$seen alias" -f
complete -c dnf -n "$seen alias && ! $seen add list delete" -xa add -d "Add a new alias"
complete -c dnf -n "$seen alias && ! $seen add list delete" -xa list -d "Lists all defined aliases"
complete -c dnf -n "$seen alias && ! $seen add list delete" -xa delete -d "Delete an alias"
complete -c dnf -n "$seen alias && $seen delete" -xa "(__dnf_list_aliases)"

# Autoremove
complete -c dnf -n "$needs_subcmd" -xa autoremove -d "Removes unneeded packages"
complete -c dnf -n "$seen autoremove" -xa "(__dnf_list_installed_packages)"

# Check
complete -c dnf -n "$needs_subcmd" -xa check -d "Check for problems in packagedb"
complete -c dnf -n "$seen check" -f
complete -c dnf -n "$seen check" -l dependencies -d "Checks dependencies"
complete -c dnf -n "$seen check" -l duplicates -d "Checks duplicates"
complete -c dnf -n "$seen check" -l obsoleted -d "Checks obsoleted"
complete -c dnf -n "$seen check" -l provides -d "Checks provides"

# Check-Update
complete -c dnf -n "$needs_subcmd" -xa check-update -d "Checks for updates"
complete -c dnf -n "$seen check-update check-upgrade" -l changelogs

# Clean
complete -c dnf -n "$needs_subcmd" -xa clean -d "Clean up cache directory"
complete -c dnf -n "$seen clean" -xa dbcache -d "Removes the database cache"
complete -c dnf -n "$seen clean" -xa expire-cache -d "Marks the repository metadata expired"
complete -c dnf -n "$seen clean" -xa metadata -d "Removes repository metadata"
complete -c dnf -n "$seen clean" -xa packages -d "Removes any cached packages"
complete -c dnf -n "$seen clean" -xa all -d "Removes all cache"

# Distro-sync
complete -c dnf -n "$needs_subcmd" -xa distro-sync -d "Synchronizes packages to match the latest"

# Downgrade
complete -c dnf -n "$needs_subcmd" -xa downgrade -d "Downgrades the specified package"
complete -c dnf -n "$seen downgrade dg" -xa "(__dnf_list_installed_packages)"

# Group
complete -c dnf -n "$needs_subcmd" -xa group -d "Manage groups"

complete -c dnf -n "$seen group && ! $seen mark" -xa summary -d "Display overview of installed and available groups"
complete -c dnf -n "$seen group && ! $seen mark" -xa info -d "Display package list of a group"
# Group install
complete -c dnf -n "$seen group && ! $seen mark" -xa install -d "Install group"
complete -c dnf -n "$seen group && $seen install" -l with-optional -d "Include optional packages"
# Group list
complete -c dnf -n "$seen group && ! $seen mark" -xa list -d "List groups"
complete -c dnf -n "$seen group && $seen list" -l installed -d "List installed groups"
complete -c dnf -n "$seen group && $seen list" -l available -d "List available groups"
complete -c dnf -n "$seen group && $seen list" -l hidden -d "List hidden groups"
# Group remove
complete -c dnf -n "$seen group && ! $seen mark" -xa remove -d "Remove group"
complete -c dnf -n "$seen group && $seen remove" -l with-optional -d "Include optional packages"

complete -c dnf -n "$seen group && ! $seen mark" -xa upgrade -d "Upgrade group"
# Group mark
complete -c dnf -n "$seen group && ! $seen mark" -xa mark -d "Marks group without manipulating packages"
complete -c dnf -n "$seen group && $seen mark" -xa install -d "Mark group installed without installing packages"
complete -c dnf -n "$seen group && $seen mark" -xa remove -d "Mark group removed without removing packages"

# Help
complete -c dnf -n "$needs_subcmd" -xa help -d "Display help and exit"

# History
complete -c dnf -n "$needs_subcmd" -xa history -d "View and manage past transactions"
complete -c dnf -n "$seen history" -xa list -d "Lists all transactions"
complete -c dnf -n "$seen history" -xa info -d "Describe the given transactions"
complete -c dnf -n "$seen history" -xa redo -d "Redoes the specified transaction"
complete -c dnf -n "$seen history" -xa rollback -d "Undo all transactions performed after the specified transaction"
complete -c dnf -n "$seen history" -xa undo -d "Undoes the specified transaction"
complete -c dnf -n "$seen history" -xa userinstalled -d "Lists all user installed packages"

for i in info redo rollback undo
    complete -c dnf -n "$seen history &&  $seen $i" -xa "(__dnf_list_transactions)"
end

# Info
complete -c dnf -n "$needs_subcmd" -xa info -d "Describes the given package"
complete -c dnf -n "$seen info && ! $seen history" -k -xa "(__dnf_list_available_packages)"

# Install
complete -c dnf -n "$needs_subcmd" -xa install -d "Install package"
complete -c dnf -n "$seen install" -k -xa "(__dnf_list_available_packages)"

# List
complete -c dnf -n "$needs_subcmd" -xa list -d "Lists all packages"
complete -c dnf -n "$seen list" -l all -d "Lists all packages"
complete -c dnf -n "$seen list" -l installed -d "Lists installed packages"
complete -c dnf -n "$seen list" -l available -d "Lists available packages"
complete -c dnf -n "$seen list" -l extras -d "Lists installed packages that are not in any known repository"
complete -c dnf -n "$seen list" -l obsoletes -d "List installed obsoleted packages"
complete -c dnf -n "$seen list" -l recent -d "List recently added packages"
complete -c dnf -n "$seen list" -l upgrades -d "List available upgrades"
complete -c dnf -n "$seen list" -l autoremove -d "List packages which will be removed by autoremove"

# Makecache
complete -c dnf -n "$needs_subcmd" -xa makecache -d "Downloads and caches metadata for all known repos"
complete -c dnf -n "$seen makecache" -l timer -d "Instructs DNF to be more resource-aware"

# Mark
complete -c dnf -n "$needs_subcmd" -xa mark -d "Mark packages"
complete -c dnf -n "$seen mark" -xa install -d "Mark package installed"
complete -c dnf -n "$seen mark" -xa remove -d "Unmarks installed package"
complete -c dnf -n "$seen mark" -xa group -d "Mark installed by group"

# Module
complete -c dnf -n "$needs_subcmd" -xa module -d "Manage modules"
complete -c dnf -n "$seen module" -xa install -d "Install module"
complete -c dnf -n "$seen module" -xa update -d "Update modules"
complete -c dnf -n "$seen module" -xa remove -d "Remove module"
complete -c dnf -n "$seen module" -xa enable -d "Enable a module"
complete -c dnf -n "$seen module" -xa disable -d "Disable a module"
complete -c dnf -n "$seen module" -xa reset -d "Reset module state"
complete -c dnf -n "$seen module" -xa list -d "List modules"
complete -c dnf -n "$seen module && $seen list" -l all -d "Lists all module "
complete -c dnf -n "$seen module && $seen list" -l enabled -d "Lists enabled module"
complete -c dnf -n "$seen module && $seen list" -l disabled -d "Lists disabled module"
complete -c dnf -n "$seen module && $seen list" -l installed -d "List  installed modules"
complete -c dnf -n "$seen module" -xa info -d "Print module information"
complete -c dnf -n "$seen module && $seen info" -l profile -d "Print module profiles information"

# Provides
complete -c dnf -n "$needs_subcmd" -xa provides -d "Finds packages providing the given command"

# Reinstall
complete -c dnf -n "$needs_subcmd" -xa reinstall -d "Reinstalls a package"
complete -c dnf -n "$seen reinstall" -xa "(__dnf_list_installed_packages)"

# Remove
complete -c dnf -n "$needs_subcmd" -xa remove -d "Remove packages"
complete -c dnf -n "$seen remove" -xa "(__dnf_list_installed_packages)" -d "Removes the specified packages"
complete -c dnf -n "$seen remove" -l duplicates -d "Removes older version of duplicated packages"
complete -c dnf -n "$seen remove" -l oldinstallonly -d "Removes old installonly packages"

# Repolist and Repoinfo
complete -c dnf -n "$needs_subcmd" -xa repoinfo -d "Verbose repolist"
complete -c dnf -n "$needs_subcmd" -xa repolist -d "Lists all enabled repositories"

for i in repolist repoinfo
    complete -c dnf -n "$seen $i" -l enabled -d "Lists all enabled repositories"
    complete -c dnf -n "$seen $i" -l disabled -d "Lists all disabled repositories"
    complete -c dnf -n "$seen $i" -l all -d "Lists all repositories"
end

# Repoquery
complete -c dnf -n "$needs_subcmd" -xa repoquery -d "Queries DNF repositories"
complete -c dnf -n "$seen repoquery" -l querytags -d "Provides the list of tags"

# repoquery select options
complete -c dnf -n "$seen repoquery" -s a -l all
complete -c dnf -n "$seen repoquery" -l enabled
complete -c dnf -n "$seen repoquery" -l arch -l archlist
complete -c dnf -n "$seen repoquery" -l duplicates
complete -c dnf -n "$seen repoquery" -l unneeded
complete -c dnf -n "$seen repoquery" -l available
complete -c dnf -n "$seen repoquery" -l extras
complete -c dnf -n "$seen repoquery" -s f -l file
complete -c dnf -n "$seen repoquery" -l installed
complete -c dnf -n "$seen repoquery" -l installonly
complete -c dnf -n "$seen repoquery" -l latest-limit
complete -c dnf -n "$seen repoquery" -l recent
complete -c dnf -n "$seen repoquery" -l repo
complete -c dnf -n "$seen repoquery" -l unsatisfied
complete -c dnf -n "$seen repoquery" -l upgrades
complete -c dnf -n "$seen repoquery" -l userinstalled
complete -c dnf -n "$seen repoquery" -l whatdepends
complete -c dnf -n "$seen repoquery" -l whatconflicts
complete -c dnf -n "$seen repoquery" -l whatenhances
complete -c dnf -n "$seen repoquery" -l whatobsoletes
complete -c dnf -n "$seen repoquery" -l whatprovides
complete -c dnf -n "$seen repoquery" -l whatrecommends
complete -c dnf -n "$seen repoquery" -l whatrequires
complete -c dnf -n "$seen repoquery" -l whatsuggests
complete -c dnf -n "$seen repoquery" -l whatsupplements
complete -c dnf -n "$seen repoquery" -l alldeps
complete -c dnf -n "$seen repoquery" -l exactdeps
complete -c dnf -n "$seen repoquery" -l srpm

# Query options
complete -c dnf -n "$seen repoquery" -s i -l info -d "Show detailed information about the package"
complete -c dnf -n "$seen repoquery" -s l -l list -d "Show the list of files in the package"
complete -c dnf -n "$seen repoquery" -s s -l source -d "Show the package source RPM name"
complete -c dnf -n "$seen repoquery" -l changelogs -d "Print the package changelogs"
complete -c dnf -n "$seen repoquery" -l conflicts -d "Display capabilities that the package conflicts with"
complete -c dnf -n "$seen repoquery" -l depends -d "Display capabilities that the package depends on"
complete -c dnf -n "$seen repoquery" -l enhances -d "Display capabilities enhanced by the package"
complete -c dnf -n "$seen repoquery" -l location -d "Show a location where the package could be downloaded from"
complete -c dnf -n "$seen repoquery" -l obsoletes -d "Display capabilities that the package obsoletes"
complete -c dnf -n "$seen repoquery" -l provides -d "Display capabilities provided by the package"
complete -c dnf -n "$seen repoquery" -l recommends -d "Display capabilities recommended by the package"
complete -c dnf -n "$seen repoquery" -l requires -d "Display capabilities that the package depends on"
complete -c dnf -n "$seen repoquery" -l requires-pre -d "Display capabilities that the package depends on"
complete -c dnf -n "$seen repoquery" -l suggests -d "Display capabilities suggested by the package"
complete -c dnf -n "$seen repoquery" -l supplements -d "Display capabilities supplemented by the package"
complete -c dnf -n "$seen repoquery" -l tree -d "Display a recursive tree of packages"
complete -c dnf -n "$seen repoquery" -l deplist -d "Produce a list of all dependencies"
complete -c dnf -n "$seen repoquery" -l nvr -d "Format like name-version-release"
complete -c dnf -n "$seen repoquery" -l nevra -d "Format like name-epoch:version-release.architecture"
complete -c dnf -n "$seen repoquery" -l envra -d "Format like epoch:name-version-release.architecture"
complete -c dnf -n "$seen repoquery" -l qf -l queryformat -d "Custom display format"
complete -c dnf -n "$seen repoquery" -l recursive -d "Query packages recursively"
complete -c dnf -n "$seen repoquery" -l resolve -d "Resolve capabilities to originating packages"

# Repository-Packages
complete -c dnf -n "$needs_subcmd" -xa repository-packages -d "Run commands on all packages in the repository"

# Search
complete -c dnf -n "$needs_subcmd" -xa search -d "Search package metadata for keywords"
complete -c dnf -n "$seen search" -l all -d "Lists packages that match at least one of the keys"

# Shell
complete -c dnf -n "$needs_subcmd" -xa shell -d "Opens an interactive shell"

# Swap
complete -c dnf -n "$needs_subcmd" -xa swap -d "Remove spec and install spec in one transaction"

# Updateinfo
complete -c dnf -n "$needs_subcmd" -xa updateinfo -d "Display information about update advisories"
complete -c dnf -n "$seen updateinfo" -l summary -d "Displays the summary"
complete -c dnf -n "$seen updateinfo" -l list -d "List of advisories"
complete -c dnf -n "$seen updateinfo" -l info -d "Detailed information"

# updateinfo <availability> options
complete -c dnf -n "$seen updateinfo" -l all
complete -c dnf -n "$seen updateinfo" -l available
complete -c dnf -n "$seen updateinfo" -l installed
complete -c dnf -n "$seen updateinfo" -l updates

# Upgrade
complete -c dnf -n "$needs_subcmd" -xa upgrade -d "Updates packages"
complete -c dnf -n "$seen upgrade" -xa "(__dnf_list_installed_packages)"

# Upgrade-Minimal
complete -c dnf -n "$needs_subcmd" -xa upgrade-minimal -d "Updates packages"
complete -c dnf -n "$seen upgrade-minimal" -xa "(__dnf_list_installed_packages)"

# Versionlock
if [ -f /etc/dnf/plugins/versionlock.conf ]
    set -l versionlock_subcmds add exclude list delete clear
    # set -l versionlock_list string match -r '^\s*locklist\s*=\s*\S+' </etc/dnf/plugins/versionlock.conf | string replace -r '^\s*locklist\s*=\s*' ''
    function __dnf_current_versionlock_list
        if [ -f /etc/dnf/plugins/versionlock.list ]
            string match -r '^[^#].+' </etc/dnf/plugins/versionlock.list
        else
            dnf -C versionlock list | string match -v '*metadata*'
        end
    end

    complete -c dnf -n "$needs_subcmd" -xa versionlock -d "DNF versionlock plugin"

    complete -c dnf -n "$seen versionlock && ! $seen $versionlock_subcmds" -xa add -d "Add versionlock for available packages matching a spec"
    complete -c dnf -n "$seen versionlock && ! $seen $versionlock_subcmds" -xa exclude -d "Add an exclude for available packages matching a spec"
    complete -c dnf -n "$seen versionlock && ! $seen $versionlock_subcmds" -xa delete -d "Remove any matching versionlock entries"
    complete -c dnf -n "$seen versionlock && ! $seen $versionlock_subcmds" -xa list -d "List the current versionlock entries"
    complete -c dnf -n "$seen versionlock && ! $seen $versionlock_subcmds" -xa clear -d "Remove all versionlock entries"

    complete -c dnf -n "$seen versionlock && $seen add" -xa "(__dnf_list_installed_packages)"
    complete -c dnf -n "$seen versionlock && $seen exclude" -xa "(__dnf_list_installed_packages)"
    complete -c dnf -n "$seen versionlock && $seen delete" -xa "(__dnf_current_versionlock_list)"
    # complete -c dnf -n "$seen versionlock && $seen list" -xa "(false)"
    # complete -c dnf -n "$seen versionlock && $seen clear" -xa "(false)"
end

complete -c dnf -n "$needs_subcmd" -xa builddep -d "Install build dependencies for package or spec file"
complete -c dnf -n "$seen builddep" -xa "(__dnf_list_available_packages)"
complete -c dnf -n "$seen builddep" -x -s D -l define -d "Define a macro for spec file parsing"
complete -c dnf -n "$seen builddep" -l skip-unavailable -d "Skip build dependencies not available in repositories"
complete -c dnf -n "$seen builddep" -l skip-unavailable -d "Treat commandline arguments as spec files"
complete -c dnf -n "$seen builddep" -l skip-unavailable -d "Treat commandline arguments as source rpm"

complete -c dnf -n "$needs_subcmd" -xa changelog -d "Show changelog data of packages"
complete -c dnf -n "$seen changelog" -xa "(__dnf_list_available_packages)"
complete -c dnf -n "$seen changelog" -l since -x -d "show changelog entries since DATE"
complete -c dnf -n "$seen changelog" -l count -x -d "show given number of changelog entries per package"
complete -c dnf -n "$seen changelog" -l upgrades -d "show only new changelog entries for packages"

complete -c dnf -n "$needs_subcmd" -xa config-manager -d "manage dnf configuration options and repositories"
complete -c dnf -n "$needs_subcmd" -xa copr -d "Interact with Copr repositories"
complete -c dnf -n "$needs_subcmd" -xa debug-dump -d "dump information about installed rpm packages to file"
complete -c dnf -n "$needs_subcmd" -xa debug-restore -d "restore packages recorded in debug-dump file"
complete -c dnf -n "$needs_subcmd" -xa debuginfo-install -d "install debuginfo packages"

complete -c dnf -n "$needs_subcmd" -xa download -d "Download package to current directory"
complete -c dnf -n "$seen download" -xa "(__dnf_list_available_packages)"
complete -c dnf -n "$seen download" -l source -d "download the src.rpm instead"
complete -c dnf -n "$seen download" -l debuginfo -d "download the -debuginfo package instead"
complete -c dnf -n "$seen download" -l debugsource -d "download the -debugsource package instead"
complete -c dnf -n "$seen download" -l arch -l archlist -d "limit the query to packages of given architectures" -x
complete -c dnf -n "$seen download" -l resolve -d "resolve and download needed dependencies"
complete -c dnf -n "$seen download && $has resolve" -l alldeps -d "Download ALL dependencies (incliding installed ones)"
complete -c dnf -n "$seen download" -l url -l urls -d "print list of urls where the rpms can be downloaded instead of downloading"
complete -c dnf -n "$seen download && $has url urls" -l urlprotocols -d "limit to specific protocols" -xa "http\t https\t rsync\t ftp\t"

complete -c dnf -n "$needs_subcmd" -xa groups-manager -d "create and edit groups metadata file"
complete -c dnf -n "$needs_subcmd" -xa needs-restarting -d "determine updated binaries that need restarting"
complete -c dnf -n "$needs_subcmd" -xa playground -d "Interact with Playground repository"
complete -c dnf -n "$needs_subcmd" -xa repoclosure -d "Display a list of unresolved dependencies for repos"
complete -c dnf -n "$needs_subcmd" -xa repodiff -d "List differences between two sets of repositories"
complete -c dnf -n "$needs_subcmd" -xa repograph -d "Output a full package dependency graph in dot format"
complete -c dnf -n "$needs_subcmd" -xa repomanage -d "Manage a directory of rpm packages"
complete -c dnf -n "$needs_subcmd" -xa reposync -d "download all packages from remote repo"


# Options:
# Using __fish_no_arguments here so that users are not completely overloaded with
#   available options when using subcommands (e.g. repoquery) (40 vs 100ish)
#
# However, it also breaks arguments
#
# deprecated:
# -d/debuglevel= -> -v
# -e/errorlevel= -> -v
# --excludepkgs= -> --exclude

# always relevant
complete -c dnf -s h -l help -d "Show the help"
complete -c dnf -n "$no_args" -s q -l quiet -d "Quiet mode"
complete -c dnf -n "$no_args" -s v -l verbose -d "Verbose mode"
complete -c dnf -n "$no_args" -l version -d "Shows DNF version and exit"
complete -c dnf -n "$no_args" -l color -xa "always never auto" -d "Control whether color is used"
complete -c dnf -n "$no_args" -s c -l config -d "Configuration file location"

complete -c dnf -n "$no_args && ! $has -s 4 -s 6 -s C cacheonly" -s 4 -d "Use IPv4 only"
complete -c dnf -n "$no_args && ! $has -s 4 -s 6 -s C cacheonly" -s 6 -d "Use IPv6 only"

complete -c dnf -n "$no_args" -s C -l cacheonly -d "Run entirely from system cache"
complete -c dnf -n "$no_args && ! $has -s C cacheonly" -l refresh -d "Set metadata as expired before running the command"



complete -c dnf -n "$no_args && ! $has -s b best nobest" -s b -l best -d "Try the best available package versions in transactions"
complete -c dnf -n "$no_args && ! $has -s b best nobest" -l nobest -d "Set best option to False"

complete -c dnf -n "$no_args && ! $has -s y assumeyes assumeno" -l assumeno -d "Answer no for all questions"
complete -c dnf -n "$no_args && ! $has -s y assumeyes assumeno" -s y -l assumeyes -d "Answer yes for all questions"

complete -c dnf -n "$no_args" -l allowerasing -d "Allow erasing of installed packages to resolve dependencies"
complete -c dnf -n "$no_args" -l skip-broken -d "Skips broken packages"

complete -c dnf -n "$no_args" -l enableplugin -d "Enable the listed plugins"
complete -c dnf -n "$no_args" -l disableplugin -d "Disable the listed plugins specified"
complete -c dnf -n "$no_args" -l noplugins -d "Disable all plugins"

complete -c dnf -n "$no_args" -l enablerepo -d "Enable additional repositories"
complete -c dnf -n "$no_args" -l disablerepo -d "Disable specified repositories"
complete -c dnf -n "$no_args" -l repofrompath -d "Specify repository to add to the repositories for this query"
complete -c dnf -n "$no_args" -l repo -l repoid -d "Enable just specific repositories by an id or a glob"

complete -c dnf -n "$no_args" -s x -l exclude -d "Exclude packages specified"
complete -c dnf -n "$no_args" -l disableexcludes -l disableexcludepkgs -d "Disable excludes"

complete -c dnf -n "$no_args" -l downloadonly -d "Download packages without performing any transaction"
complete -c dnf -n "$no_args" -l forcearch -d "Force the use of the specified architecture"
complete -c dnf -n "$no_args" -l installroot -d "Specifies an alternative installroot"
complete -c dnf -n "$no_args" -l noautoremove -d "Disable autoremove"
complete -c dnf -n "$no_args" -l nodocs -d "Do not install documentation"
complete -c dnf -n "$no_args" -l nogpgcheck -d "Skip checking GPG signatures on packages"
complete -c dnf -n "$no_args" -s R -l randomwait -d "Maximum command wait time"
complete -c dnf -n "$no_args" -l releasever -d "Configure the distribution release"
complete -c dnf -n "$no_args" -l rpmverbosity -d "RPM debug scriptlet output level"
complete -c dnf -n "$no_args" -l setopt -d "Override a configuration option"

# unknown relevance
complete -c dnf -n "$no_args" -l debugsolver -d "Dump dependency solver debugging info"

# Relevant for explicitly stated commands
# config-manager
# complete -c dnf -n "$no_args" -l enable -l set-enabled -d "Enable specified repositories"
# complete -c dnf -n "$no_args" -l disable -l set-disabled -d "Disable specified repositories"

# install, repoquery, updateinfo, & upgrade
# complete -c dnf -n "$no_args" -x -l advisory -l advisories -d "Include packages corresponding to the advisory ID"
# complete -c dnf -n "$no_args" -l bugfix -d "Include packages that fix a bugfix issue"
# complete -c dnf -n "$no_args" -x -l bz -l bzs -d "Include packages that fix a Bugzilla ID"
# complete -c dnf -n "$no_args" -x -l cve -l cves -d "Include packages that fix a CVE"
# complete -c dnf -n "$no_args" -l enhancement -d "Include enhancement relevant packages"
# complete -c dnf -n "$no_args" -l newpackage -d "Include newpackage relevant packages"
# complete -c dnf -n "$no_args" -l sec-severity -l secseverity -d "Includes packages that provide a fix for an issue of the specified severity"

# --downloadonly, download, system-upgrade
# complete -c dnf -n "$no_args" -l downloaddir -l destdir -d "Change downloaded packages to provided directory"

# upgrade
# complete -c dnf -n "$no_args" -l security -d "Includes packages that provide a fix for a security issue"

# list, search
# complete -c dnf -n "$no_args" -l showduplicates -d "Shows duplicate packages"

# install/update
# complete -c dnf -n "$no_args" -l obsoletes -d "Enables obsoletes processing logic"
