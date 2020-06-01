# This is a more complicated wrapper for id(1) meant mostly to test adding
# custom flags to commands
#
# PERFORMANCE:
# 'command id' ran
#  2.30 ± 3.55 times faster than 'id'
# 31.47 ± 40.64 times faster than 'id -J'

function id -d "Display current user and group identity"
  # Parse arguments
  argparse --name=id --ignore-unknown 'h/help' 'v/version' 'J/json' 'a' -- $argv
  # -J is completely custom
  # --help & --version have no short options by default
  # -a is ignored by id so we just get rid of it

  set -l cmd id

  if set -q _flag_h
    # If present, -h is the only argument that really matters
    command $cmd --help $argv
    return
  else if set -q _flag_v
    # Same as -h for -v
    command $cmd --version $argv
    return
  else if set -q _flag_J && command -qs jc
    # If -J is present, we need to pass the output off to a different program
    if isatty stdout && [ (command -s prettier tput bat | count) = 3 ]
      # If we're outputting data to a TTY we should also make the output easy
      # to read
      command $cmd $argv \
         | jc --id \
         | prettier --parser json --print-width (tput cols) \
         | bat --language=json --paging=never --color=always --style=plain
    else
      # If there isn't a TTY involved we shouldn't fuck with the output
      command $cmd $argv | jc --id
    end
  else
    # Fall back on mostly normal operation
    if isatty stdout && command -qs grc
      # If we're outputting to a TTY add colors to the output
      set -p cmd grc
    end
    command $cmd $argv
  end
end
