#!/usr/bin/env fish
if isatty

    # Push ssh sessions into a user scope
    if string match --quiet '0::/user.slice/user-*.slice/session-*.scope' </proc/self/cgroup
        exec systemd-run --user --scope --same-dir --no-block --quiet --collect --unit run-ssh-fish-$fish_pid fish $argv
    end

    if command -qs zoxide
        zoxide init fish | source
    end

    if command -qs vivid
        set -gx LS_COLORS (vivid generate burner)
        # This was done with psub before but ALE didn't like that
    end

    # Mark scalar arrays
    set -q XDG_DATA_DIRS && set --path XDG_DATA_DIRS $XDG_DATA_DIRS
    set -q XDG_CONFIG_DIRS && set --path XDG_CONFIG_DIRS $XDG_CONFIG_DIRS
    set -q TERMINFO_DIRS && set --path TERMINFO_DIRS $TERMINFO_DIRS
    set -q GTK_RC_FILES && set --path GTK_RC_FILES $GTK_RC_FILES
    set -q GTK2_RC_FILES && set --path GTK2_RC_FILES $GTK2_RC_FILES

    # Add fisher functions & completions to fish path
    if set -q fisher_path && [ $fisher_path != $__fish_config_dir ]
        if not contains -- $fisher_path/functions $fish_function_path
            set -a fish_function_path $fisher_path/functions
        end
        if not contains -- $fisher_path/completions $fish_complete_path
            set -a fish_complete_path $fisher_path/completions
        end
    end

    if not contains -- $__fish_config_dir/vendor_completions.d $fish_complete_path
        set -a fish_complete_path $__fish_config_dir/vendor_completions.d
    end

    if set -q HOMEBREW_PREFIX
        if not contains -- $HOMEBREW_PREFIX/share/fish/vendor_functions.d $fish_function_path
            set -a fish_function_path $HOMEBREW_PREFIX/share/fish/vendor_functions.d
        end
        if not contains -- $HOMEBREW_PREFIX/share/fish/vendor_completions.d $fish_complete_path
            set -a fish_complete_path $HOMEBREW_PREFIX/share/fish/vendor_completions.d
        end
    end

    # if not contains -- $XDG_DATA_HOME/fish/generated_completions $fish_complete_path
    #     set -a fish_complete_path $XDG_DATA_HOME/fish/generated_completions
    # end
end
