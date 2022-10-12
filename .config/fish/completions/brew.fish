# Patches bugged homebrew completions
if set -q HOMEBREW_PREFIX
    source $HOMEBREW_PREFIX/share/fish/vendor_completions.d/brew.fish

    function __fish_brew_suggest_casks_installed
        false
    end
end
