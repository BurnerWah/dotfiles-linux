#!/usr/bin/env fish
z.lua --init fish | source
set -gx LS_COLORS (vivid generate burner)
# This was done with psub before but ALE didn't like that
