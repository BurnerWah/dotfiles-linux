# gio completions

# TODO look into completing attributes

set -l seen __fish_seen_subcommand_from
set -l needs_subcmd __fish_use_subcommand
set -l words '(count (commandline -poc))'
set -l cmdline 'commandline -poc'
set -l seq contains_seq
set -l is_subcmd "$needs_subcmd || $seen help && [ $words -lt 3 ]"
set -l using "! $seen help && $seen"

# Subcommands
complete -xc gio -n "$is_subcmd" -a '
help\	"Print help"
version\	"Print version"
cat\	"Concatenate files to standard output"
copy\	"Copy one or more files"
info\	"Show information about locations"
list\	"List the contents of locations"
mime\	"Get or set the handler for a mimetype"
mkdir\	"Create directories"
monitor\	"Monitor files and directories for changes"
mount\	"Mount or unmount the locations"
move\	"Move one or more files"
open\	"Open files with the default application"
rename\	"Rename a file"
remove\	"Delete one or more files"
save\	"Read from standard input and save"
set\	"Set a file attribute"
trash\	"Move files or directories to the trash"
tree\	"Lists the contents of locations in a tree"
'

# Completion blockers
complete -xc gio -n "$seen help && [ $words -gt 2 ]"
complete -xc gio -n "$seen version"

# gio cat - no completions needed
# gio copy
complete -c gio -n "$using copy" -s T -l no-target-directory -d "No target directory"
complete -c gio -n "$using copy" -s p -l progress -d "Show progress"
complete -c gio -n "$using copy" -s i -l interactive -d "Prompt before overwrite"
complete -c gio -n "$using copy" -l preserve -d "Preserve all attributes"
complete -c gio -n "$using copy" -s b -l backup -d "Backup existing destination files"
complete -c gio -n "$using copy" -s P -l no-deference -d "Never follow symbolic links"
complete -c gio -n "$using copy" -l default-permissions -d "Use default permissions for the destination"
# gio info
complete -c gio -n "$using info" -s w -l query-writable -d "List writable attributes"
complete -c gio -n "$using info" -s f -l filesystem -d "Get file system info"
complete -xc gio -n "$using info" -s a -l attributes -d "The attributes to get" # TODO add arguments
complete -c gio -n "$using info" -s n -l nofollow-symlinks -d "Don’t follow symbolic links"
# gio list
complete -xc gio -n "$using list" -s a -l attributes -d "The attributes to get" # TODO add arguments
complete -c gio -n "$using list" -s h -l hidden -d "Show hidden files"
complete -c gio -n "$using list" -s l -l long -d "Use a long listing format"
complete -c gio -n "$using list" -s n -l nofollow-symlinks -d "Don’t follow symbolic links"
complete -c gio -n "$using list" -s d -l print-display-names -d "Print display names"
complete -c gio -n "$using list" -s u -l print-uris -d "Print full URIs"
# gio mime - TODO
# gio mkdir
complete -c gio -n "$using mkdir" -s p -l parent -d "Create parent directories"
# gio monitor - TODO
# gio mount - TODO
# gio move
complete -c gio -n "$using move" -s T -l no-target-directory -d "No target directory"
complete -c gio -n "$using move" -s p -l progress -d "Show progress"
complete -c gio -n "$using move" -s i -l interactive -d "Prompt before overwrite"
complete -c gio -n "$using move" -s b -l backup -d "Backup existing destination files"
complete -c gio -n "$using move" -s C -l no-copy-fallback -d "Don’t use copy and delete fallback"
# gio open - no completions needed
# gio rename - XXX completions might not be needed
# gio remove
complete -c gio -n "$using remove" -s f -l force -d "Ignore nonexistent files, never prompt"
# gio save - TODO
# gio set - TODO
# gio trash
complete -c gio -n "$using trash" -s f -l force -d "Ignore nonexistent files, never prompt"
complete -c gio -n "$using trash" -l empty -d "Empty the trash"
# gio tree
complete -c gio -n "$using tree" -s h -l hidden -d "Show hidden files"
complete -c gio -n "$using tree" -s l -l follow-symlinks -d "Follow symbolic links, mounts and shortcuts"
complete -xc gio -n "$using tree" -a "(__fish_complete_directories)"
