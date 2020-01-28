# vim:ft=zsh:fdm=marker:tw=80

# Pre-work {{{1
if [[ -o 'aliases' ]]; then
  # Temporarily disable aliases.
  'builtin' 'unsetopt' 'aliases'
  local p10k_lean_restore_aliases=1
else
  local p10k_lean_restore_aliases=0
fi

() {
  emulate -L zsh
  setopt no_unset

  # Unset all configuration options. This allows you to apply configiguration
  # changes without restarting zsh.
  unset -m 'POWERLEVEL9K_*'

  # Prompt segments {{{1

  # The list of segments shown on the left.
  #zstyle ':plugin:p10k:prompt:left:' elements os_icon dir vcs prompt_char
  typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
      os_icon     # os identifier
      dir         # current directory
      vcs         # git status
      prompt_char # prompt symbol
  )

  # The list of segments shown on the right. Hidden whenever needed.
  #zstyle ':plugin:p10k:prompt:right:' elements \
  #  status command_execution_time background_jobs virtualenv anaconda pyenv \
  #  context time
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
      status                  # exit code of the last command
      command_execution_time  # duration of the last command
      background_jobs         # presence of background jobs
      virtualenv              # Python virtual environment
      # anaconda              # conda environment
      pyenv                   # python environment
      # go_version            # golang version
      # rust_version          # rust version
      context                 # user@host
      # public_ip             # public IP address
      # battery               # internal battery
      time                    # current time
  )

  # Universal config {{{1
  # Basic style options that define the overall look of your prompt.

  typeset -g POWERLEVEL9K_BACKGROUND=
  # transparent background

  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_{LEFT,RIGHT}_WHITESPACE=
  # no surrounding whitespace

  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SUBSEGMENT_SEPARATOR=' '
  # separate segments with a space

  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SEGMENT_SEPARATOR=
  # no end-of-line symbol

  typeset -g POWERLEVEL9K_MODE=nerdfont-complete
  # This option makes a difference only when default icons are enabled for all
  # or some prompt segments (see POWERLEVEL9K_VISUAL_IDENTIFIER_EXPANSION above).
  # LOCK_ICON can be printed as $'\uE0A2', $'\uE138' or $'\uF023' depending on
  # POWERLEVEL9K_MODE. The correct value of this parameter depends on the
  # provider of the font your terminal is using.
  #
  #   Font Provider                    | POWERLEVEL9K_MODE
  #   ---------------------------------+-------------------
  #   Powerline                        | powerline
  #   Font Awesome                     | awesome-fontconfig
  #   Adobe Source Code Pro            | awesome-fontconfig
  #   Source Code Pro                  | awesome-fontconfig
  #   Awesome-Terminal Fonts (regular) | awesome-fontconfig
  #   Awesome-Terminal Fonts (patched) | awesome-patched
  #   Nerd Fonts                       | nerdfont-complete
  #   Other                            | compatible

  typeset -g POWERLEVEL9K_ICON_BEFORE_CONTENT=true
  # When true, icons appear before content on both sides of the prompt. When
  # false, icons go after content. If empty or unset, icons go before content in
  # the left prompt and after content in the right prompt.
  #
  # You can also override it for a specific segment:
  #
  #   POWERLEVEL9K_STATUS_ICON_BEFORE_CONTENT=false
  #
  # Or for a specific segment in specific state:
  #
  #   POWERLEVEL9K_DIR_NOT_WRITABLE_ICON_BEFORE_CONTENT=false

  typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=false
  # Don't add an empty line before each prompt.

  typeset -g POWERLEVEL9K_SHOW_RULER=false
  # Disable the horizontal line before each prompt.

  # os_icon: os identifier {{{1

  typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND=212
  #zstyle ':plugin:p10k:segment:os_icon:' list-colors fg=212
  # OS identifier color.

  # prompt_char: prompt symbol {{{1

  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS}_FOREGROUND=76
  #zstyle ':plugin:p10k:segment:prompt_char:ok:*' list-colors fg=76
  # Green prompt symbol if the last command succeeded.

  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS}_FOREGROUND=196
  #zstyle ':plugin:p10k:segment:prompt_char:error:*' list-colors fg=196
  # Red prompt symbol if the last command failed.

  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION='❯'
  #zstyle ':plugin:p10k:segment:prompt_char:*:viins' format '❯'
  # Default prompt symbol.

  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VICMD_CONTENT_EXPANSION='❮'
  #zstyle ':plugin:p10k:segment:prompt_char:*:vicmd' format '❮'
  # Prompt symbol in command vi mode.

  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIVIS_CONTENT_EXPANSION='Ⅴ'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=''
  # Prompt symbol in visual vi mode.

  # dir: current directory {{{1

  typeset -g POWERLEVEL9K_DIR_FOREGROUND=31
  #zstyle ':plugin:p10k:segment:dir:' list-colors fg=31
  # Default CWD color.

  typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_from_right
  # Shorten CWD as much as possible

  typeset -g POWERLEVEL9K_SHORTEN_DELIMITER=
  # Replace removed segment suffixes with this symbol.

  typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND=103
  # Color of the shortened directory segments.

  typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND=39
  # Color of the anchor directory segments. Anchor segments are never
  # shortened. The first segment is always an anchor.

  typeset -g POWERLEVEL9K_DIR_ANCHOR_BOLD=true
  # Display anchor directory segments in bold.

  typeset -g POWERLEVEL9K_SHORTEN_FOLDER_MARKER='(.shorten_folder_marker|.bzr|CVS|.git|.hg|.svn|.terraform|.citc)'
  # Don't shorten directories that contain files matching this pattern. They
  # are anchors.

  typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
  # Don't shorten this many last directory segments. They are anchors.

  typeset -g POWERLEVEL9K_DIR_MAX_LENGTH=80
  # Shorten directory if it's longer than this even if there is space for it.
  # The value can be either absolute (e.g., '80') or a percentage of terminal
  # width (e.g, '50%'). If empty, directory will be shortened only when prompt
  # doesn't fit.

  typeset -g POWERLEVEL9K_DIR_HYPERLINK=false
  # If true, embed a hyperlink into the directory. Useful for quickly opening a
  # directory in the file manager simply by clicking the link. Can also be handy
  # when the directory is shortened, as it allows you to see the full directory
  # that was used in previous commands.

  typeset -g POWERLEVEL9K_DIR_SHOW_WRITABLE=true
  # Enable special styling for non-writable directories.

  typeset -g POWERLEVEL9K_DIR_CLASSES=()
  # POWERLEVEL9K_DIR_CLASSES allows you to specify custom icons for different
  # directories. It must be an array with 3 * N elements. Each triplet consists of:
  #
  #   1 A pattern against which the current directory is matched. Matching is
  #     done with extended_glob option enabled.
  #   2 Directory class for the purpose of styling.
  #   3 Icon.
  #
  # Triplets are tried in order. The first triplet whose pattern matches $PWD
  # wins. If there are no matches, the directory will have no icon.
  #
  # Example:
  #
  #   typeset -g POWERLEVEL9K_DIR_CLASSES=(
  #       '~/work(/*)#'  WORK     '(╯°□°）╯︵ ┻━┻'
  #       '~(/*)#'       HOME     '⌂'
  #       '*'            DEFAULT  '')
  #
  # With these settings, the current directory in the prompt may look like this:
  #
  #   (╯°□°）╯︵ ┻━┻ ~/work/projects/important/urgent
  #
  # Or like this:
  #
  #   ⌂ ~/best/powerlevel10k
  #
  # You can also set different colors for directories of different classes.
  # Remember to override FOREGROUND, SHORTENED_FOREGROUND and ANCHOR_FOREGROUND
  # for every directory class that you wish to have its own color.
  #
  #   typeset -g POWERLEVEL9K_DIR_WORK_FOREGROUND=12
  #   typeset -g POWERLEVEL9K_DIR_WORK_SHORTENED_FOREGROUND=4
  #   typeset -g POWERLEVEL9K_DIR_WORK_ANCHOR_FOREGROUND=39
  #

  # vcs: git status {{{1
  # Git status: feature:master#tag ⇣42⇡42 *42 merge ~42 +42 !42 ?42.
  # We are using parameters defined by the gitstatus plugin. See reference:
  # https://github.com/romkatv/gitstatus/blob/master/gitstatus.plugin.zsh.

  local vcs=''
  vcs+='${${VCS_STATUS_LOCAL_BRANCH:+%76F${(g::)POWERLEVEL9K_VCS_BRANCH_ICON}${VCS_STATUS_LOCAL_BRANCH//\%/%%}}'
  vcs+=':-%f@%76F${VCS_STATUS_COMMIT[1,8]}}'
  # 'feature' or '@72f5c8a' if not on a branch.

  vcs+='${${VCS_STATUS_REMOTE_BRANCH:#$VCS_STATUS_LOCAL_BRANCH}:+%f:%76F${VCS_STATUS_REMOTE_BRANCH//\%/%%}}'
  # ':master' if the tracking branch name differs from local branch.

  vcs+='${VCS_STATUS_TAG:+%f#%76F${VCS_STATUS_TAG//\%/%%}}'
  # '#tag' if on a tag.

  vcs+='${${VCS_STATUS_COMMITS_BEHIND:#0}:+ %76F⇣${VCS_STATUS_COMMITS_BEHIND}}'
  # ⇣42 if behind the remote.

  vcs+='${${VCS_STATUS_COMMITS_AHEAD:#0}:+${${(M)VCS_STATUS_COMMITS_BEHIND:#0}:+ }%76F⇡${VCS_STATUS_COMMITS_AHEAD}}'
  # ⇡42 if ahead of the remote; no leading space if also behind the remote: ⇣42⇡42.
  # If you want '⇣42 ⇡42' instead, replace '${${(M)VCS_STATUS_COMMITS_BEHIND:#0}:+ }' with ' '.

  vcs+='${${VCS_STATUS_STASHES:#0}:+ %76F*${VCS_STATUS_STASHES}}'
  # *42 if have stashes.

  vcs+='${VCS_STATUS_ACTION:+ %196F${VCS_STATUS_ACTION//\%/%%}}'
  # 'merge' if the repo is in an unusual state.

  vcs+='${${VCS_STATUS_NUM_CONFLICTED:#0}:+ %196F~${VCS_STATUS_NUM_CONFLICTED}}'
  # ~42 if have merge conflicts.

  vcs+='${${VCS_STATUS_NUM_STAGED:#0}:+ %227F+${VCS_STATUS_NUM_STAGED}}'
  # +42 if have staged changes.

  vcs+='${${VCS_STATUS_NUM_UNSTAGED:#0}:+ %227F!${VCS_STATUS_NUM_UNSTAGED}}'
  # !42 if have unstaged changes.

  vcs+='${${VCS_STATUS_NUM_UNTRACKED:#0}:+ %39F?${VCS_STATUS_NUM_UNTRACKED}}'
  # ?42 if have untracked files.

  vcs="\${P9K_CONTENT:-$vcs}"
  # If P9K_CONTENT is not empty, leave it unchanged. It's either "loading" or from vcs_info.

  typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=''
  # Branch icon. Set this parameter to $'\uF126' for the popular Powerline
  # branch icon.

  typeset -g POWERLEVEL9K_VCS_DISABLE_GITSTATUS_FORMATTING=true
  # Disable the default Git status formatting.

  typeset -g POWERLEVEL9K_VCS_{CLEAN,UNTRACKED,MODIFIED}_CONTENT_EXPANSION=$vcs
  # Install our own Git status formatter.

  typeset -g POWERLEVEL9K_VCS_LOADING_CONTENT_EXPANSION=${${vcs//\%f}//\%<->F}
  typeset -g POWERLEVEL9K_VCS_LOADING_FOREGROUND=244
  # When Git status is being refreshed asynchronously, display the last known
  # repo status in grey.

  typeset -g POWERLEVEL9K_VCS_{STAGED,UNSTAGED,UNTRACKED,COMMITS_AHEAD,COMMITS_BEHIND}_MAX_NUM=-1
  # Enable counters for staged, unstaged, etc.

  typeset -g POWERLEVEL9K_VCS_VISUAL_IDENTIFIER_EXPANSION=
  # Custom icon.

  # typeset -g POWERLEVEL9K_VCS_PREFIX='%fon '
  # Custom prefix.

  typeset -g POWERLEVEL9K_VCS_BACKENDS=(git)
  # Show status of repositories of these types. You can add svn and/or hg if you
  # are using them. If you do, your prompt may become slow even when your
  # current directory isn't in an svn or hg reposotiry.

  typeset -g POWERLEVEL9K_VCS_{CLEAN,MODIFIED,UNTRACKED}_FOREGROUND=76
  typeset -g POWERLEVEL9K_VCS_REMOTE_BRANCH_ICON=':'
  typeset -g POWERLEVEL9K_VCS_COMMIT_ICON='@'
  typeset -g POWERLEVEL9K_VCS_INCOMING_CHANGES_ICON='⇣'
  typeset -g POWERLEVEL9K_VCS_OUTGOING_CHANGES_ICON='⇡'
  typeset -g POWERLEVEL9K_VCS_STASH_ICON='*'
  typeset -g POWERLEVEL9K_VCS_TAG_ICON=$'%{\b#%}'
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_ICON=$'%{\b?%}'
  typeset -g POWERLEVEL9K_VCS_UNSTAGED_ICON=$'%{\b!%}'
  typeset -g POWERLEVEL9K_VCS_STAGED_ICON=$'%{\b+%}'
  # These settings are used for respositories other than Git or when gitstatusd
  # fails and Powerlevel10k has to fall back to using vcs_info.

  # status: exit code of the last command {{{1

  typeset -g POWERLEVEL9K_STATUS_EXTENDED_STATES=true
  # Status on success. No content, just an icon. Enable OK_PIPE, ERROR_PIPE and
  # ERROR_SIGNAL status states to allow us to enable, disable and style them
  # independently from the regular OK and ERROR state.

  typeset -g POWERLEVEL9K_STATUS_OK=false
  typeset -g POWERLEVEL9K_STATUS_OK_FOREGROUND=70
  typeset -g POWERLEVEL9K_STATUS_OK_VISUAL_IDENTIFIER_EXPANSION='✔'
  # Status on success. No content, just an icon. No need to show it if prompt_char
  # is enabled as it will signify success by turning green.

  typeset -g POWERLEVEL9K_STATUS_OK_PIPE=true
  typeset -g POWERLEVEL9K_STATUS_OK_PIPE_FOREGROUND=70
  typeset -g POWERLEVEL9K_STATUS_OK_PIPE_VISUAL_IDENTIFIER_EXPANSION='✔'
  # Status when some part of a pipe command fails but the overall exit status
  # is zero. It may look like this: 1|0.

  typeset -g POWERLEVEL9K_STATUS_ERROR=false
  typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND=160
  typeset -g POWERLEVEL9K_STATUS_ERROR_VISUAL_IDENTIFIER_EXPANSION='↵'
  # Status when it's just an error code (e.g., '1'). No need to show it if
  # prompt_char is enabled as it will signify error by turning red.

  typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL=true
  typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL_FOREGROUND=160
  # Status when the last command was terminated by a signal.

  typeset -g POWERLEVEL9K_STATUS_VERBOSE_SIGNAME=false
  typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL_VISUAL_IDENTIFIER_EXPANSION='↵'
  # Use terse signal names: "INT" instead of "SIGINT(2)".

  typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE=true
  typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE_FOREGROUND=160
  typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE_VISUAL_IDENTIFIER_EXPANSION='↵'
  # Status when some part of a pipe command fails and the overall exit status
  # is also non-zero. It may look like this: 1|0.

  # command_execution_time: duration of the last command {{{1

  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=3
  # Show duration of the last command if takes longer than this many seconds.

  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=0
  # Show this many fractional digits. Zero means round to seconds.

  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=101
  # Execution time color.

  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FORMAT='d h m s'
  # Duration format: 1d 2h 3m 4s.

  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_VISUAL_IDENTIFIER_EXPANSION=
  # Custom icon.

  # typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PREFIX='%ftook '
  # Custom prefix.

  # background_jobs: presence of background jobs {{{1

  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_VERBOSE=false
  # Don't show the number of background jobs.

  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND=70
  # Background jobs color.

  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_VISUAL_IDENTIFIER_EXPANSION='${P9K_VISUAL_IDENTIFIER// }'
  # Icon to show when there are background jobs.

  # context: user@host {{{1

  typeset -g POWERLEVEL9K_CONTEXT_FOREGROUND=180
  # Default context color.

  typeset -g POWERLEVEL9K_CONTEXT_TEMPLATE='%n@%m'
  # Default context format: %n is username, %m is hostname.

  typeset -g POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND=227
  # Context color when running with privileges.

  typeset -g POWERLEVEL9K_CONTEXT_ROOT_TEMPLATE='%n@%m'
  # Context format when running with privileges: %n is username, %m is hostname.

  typeset -g POWERLEVEL9K_CONTEXT_{DEFAULT,SUDO}_{CONTENT,VISUAL_IDENTIFIER}_EXPANSION=
  typeset -g POWERLEVEL9K_ALWAYS_SHOW_CONTEXT=true
  # Don't show context unless running with privileges on in SSH.

  # typeset -g POWERLEVEL9K_CONTEXT_VISUAL_IDENTIFIER_EXPANSION='⭐'
  # Custom icon.

  # typeset -g POWERLEVEL9K_CONTEXT_PREFIX='%fwith '
  # Custom prefix.

  # virtualenv: python virtual environment {{{1
  # see: https://docs.python.org/3/library/venv.html

  typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND=37
  # Python virtual environment color.

  typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_PYTHON_VERSION=false
  # Don't show Python version next to the virtual environment name.

  typeset -g POWERLEVEL9K_VIRTUALENV_{LEFT,RIGHT}_DELIMITER=
  # Separate environment name from Python version only with a space.

  # typeset -g POWERLEVEL9K_VIRTUALENV_VISUAL_IDENTIFIER_EXPANSION='⭐'
  # Custom icon.

  # anaconda: conda environment {{{1
  # see: https://conda.io/

  typeset -g POWERLEVEL9K_ANACONDA_FOREGROUND=37
  # Anaconda environment color.

  typeset -g POWERLEVEL9K_ANACONDA_SHOW_PYTHON_VERSION=false
  # Don't show Python version next to the anaconda environment name.

  typeset -g POWERLEVEL9K_ANACONDA_{LEFT,RIGHT}_DELIMITER=
  # Separate environment name from Python version only with a space.

  # typeset -g POWERLEVEL9K_ANACONDA_VISUAL_IDENTIFIER_EXPANSION='⭐'
  # Custom icon.

  # pyenv: python environment {{{1
  # see: https://github.com/pyenv/pyenv

  typeset -g POWERLEVEL9K_PYENV_FOREGROUND=37
  # Pyenv color.

  typeset -g POWERLEVEL9K_PYENV_PROMPT_ALWAYS_SHOW=false
  # Don't show the current Python version if it's the same as global.

  # typeset -g POWERLEVEL9K_PYENV_VISUAL_IDENTIFIER_EXPANSION='⭐'
  # Custom icon.

  # go_version: golang version {{{1

  typeset -g POWERLEVEL9K_GO_VERSION_FOREGROUND=37
  # Golang version color.

  # typeset -g POWERLEVEL9K_GO_VERSION_VISUAL_IDENTIFIER_EXPANSION='⭐'
  # Custom icon.

  # public_ip: public IP address {{{1

  typeset -g POWERLEVEL9K_PUBLIC_IP_FOREGROUND=94
  #zstyle ':plugin:p10k:segment:public_ip:' list-colors fg=94
  # Public IP color.

  # battery: internal battery {{{1

  typeset -g POWERLEVEL9K_BATTERY_LOW_THRESHOLD=20
  typeset -g POWERLEVEL9K_BATTERY_LOW_FOREGROUND=1
  # Show battery in red when it's below this level and not connected to power
  # supply.

  typeset -g POWERLEVEL9K_BATTERY_CHARGING_FOREGROUND=70
  # Show battery in green when it's charging.

  typeset -g POWERLEVEL9K_BATTERY_DISCONNECTED_FOREGROUND=178
  # Show battery in yellow when not connected to power supply.

  typeset -g POWERLEVEL9K_BATTERY_STAGES='▁▂▃▄▅▆▇'
  # Battery pictograms going from low to high level of charge.

  typeset -g POWERLEVEL9K_BATTERY_VISUAL_IDENTIFIER_EXPANSION='%K{232}${P9K_VISUAL_IDENTIFIER}%k'
  # Display battery pictogram on black background.

  typeset -g POWERLEVEL9K_BATTERY_CHARGED_{CONTENT,VISUAL_IDENTIFIER}_EXPANSION=
  # Don't show battery when it's fully charged and connected to power supply.

  typeset -g POWERLEVEL9K_BATTERY_VERBOSE=false
  # Don't show the remaining time to charge/discharge.

  # time: current time {{{1

  typeset -g POWERLEVEL9K_TIME_FOREGROUND=66
  #zstyle ':plugin:p10k:segment:time:' list-colors fg=66
  # Current time color.

  typeset -g POWERLEVEL9K_TIME_FORMAT='%D{%H:%M:%S}'
  #zstyle ':plugin:p10k:segment:time:' format '%D{%H:%M:%S}'
  # Format for the current time: 09:51:02. See `man 3 strftime`.

  typeset -g POWERLEVEL9K_TIME_UPDATE_ON_COMMAND=false
  #zstyle ':plugin:p10k:segment:time:update-on-command' disabled true
  # If true, time will update when you hit enter. This way prompts for the past
  # commands will contain the start times of their commands as opposed to the
  # default behavior where they contain the end times of their preceding commands.

  typeset -g POWERLEVEL9K_TIME_VISUAL_IDENTIFIER_EXPANSION=
  # Disable icon
}

(( ! p10k_lean_restore_aliases )) || setopt aliases
'builtin' 'unset' 'p10k_lean_restore_aliases'
