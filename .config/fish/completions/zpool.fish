source $__fish_data_dir/completions/zpool.fish

# Fix to avoid outputting garbage data
# Also include symlinks (which may be better to use as arguments)
function __fish_zpool_list_available_vdevs
    # Not sure if i'm a fan of this yet
    # lsblk -n -M --output PATH,TYPE,KNAME,LABEL | string replace -r '(\S+)\s+(\S+)\s+(\S+)(\s*( \S+))?' '$1\t$2 ($3$5)'
    find -L /dev -mount -type b | string replace /dev/ ''
end
