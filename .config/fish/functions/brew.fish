# Alias for brew that automatically runs sudo as needed
function brew
    for i in autoremove cleanup doctor install remove uninstall tap update upgrade
        if contains -- $i $argv
            sudo -u linuxbrew (command -s brew) $argv
            return
        end
    end
    command brew $argv
end
