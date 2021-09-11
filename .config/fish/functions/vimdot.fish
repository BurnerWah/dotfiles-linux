function vimdot
    set -lx EDITOR (command -s $EDITOR)
    command vimdot $argv
end
