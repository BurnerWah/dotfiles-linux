#!/usr/bin/env fish
z.lua --init fish | source
set -gx LS_COLORS (vivid generate burner)
# This was done with psub before but ALE didn't like that
if not contains -- $HOMEBREW_PREFIX/share/fish/vendor_completions.d $fish_complete_path
  and test $fish_complete_path[-1] = $XDG_DATA_HOME/fish/generated_completions
    set fish_complete_path[-1] $HOMEBREW_PREFIX/share/fish/vendor_completions.d
    set -a fish_complete_path $XDG_DATA_HOME/fish/generated_completions
end
