function glow -w "glow -w 80" -d "Render markdown on the CLI, with pizzazz!"
    command glow -w (tput cols) $argv
end
