function spec_needs_buildrequires --description "Print BuildRequires packages for a spec that can't be satisfied"
    for i in (rg '^BuildRequires:' $argv[1] | string replace -r '^BuildRequires:\s+(\S+)$' '$1')
        dnf info $i 2&>/dev/null || echo "Package '$i' not found"
    end
end
