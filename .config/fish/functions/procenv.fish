function procenv
    cat /proc/$argv[1]/environ | tr '\0' '\n'
end
