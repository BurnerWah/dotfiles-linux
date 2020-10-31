#!/usr/bin/env fish
if command -qs zoxide
  zoxide init fish | source
end

if command -qs vivid
  set -gx LS_COLORS (vivid generate burner)
  # This was done with psub before but ALE didn't like that
end
